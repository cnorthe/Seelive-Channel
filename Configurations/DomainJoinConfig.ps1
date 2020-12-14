#set execution policy to enable running scripts
Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Force

#enable Windows Remote Management service
Get-Service -name 'WinRM' | Start-Service

# Create the private key certificate
$cert = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp -DnsName 'DscDJEncryptionCert' -HashAlgorithm SHA256
# export the private key certificate
$mypwd = ConvertTo-SecureString -String "ANYPASSWORD" -Force -AsPlainText
$cert | Export-PfxCertificate -FilePath "$env:Windir\temp\DscDJPrivateKey.pfx" -Password $mypwd -Force
# import the private key certificate
Import-PfxCertificate -FilePath "$env:Windir\temp\DscDJPrivateKey.pfx" -CertStoreLocation Cert:\LocalMachine\My -Password $mypwd > $null
# remove the private key certificate from the node but keep the public key certificate
$cert | Export-Certificate -FilePath "$env:Windir\temp\DscDJPublicKey.cer" -Force

#Install xAdcsDeployment from PSGallery
Install-Module xAdcsDeployment

#Copy module to PSModulePath location
$params = @{
    Path        = (Get-Module xAdcsDeployment -ListAvailable).ModuleBase
    Destination = "$env:SystemDrive\Program Files\WindowsPowerShell\Modules\xAdcsDeployment"
    ToSession   = $Session
    Force       = $true
    Recurse     = $true
    Verbose     = $true

}
Copy-Item @params

#Domain Join Configuration
configuration DomainJoinConfig
{
    param
    (
        [Parameter(Mandatory)]
        [string]$MachineName,

        [Parameter(Mandatory)]
        [string]$Domain,

        [Parameter(Mandatory)]
        [pscredential]$Credential
    )

    #Import the required DSC Resources
    Import-DscResource -Module xComputerManagement

    Node $AllNodes.NodeName
    {
        xComputer JoinDomain
        {
            Name       = $MachineName
            DomainName = $Domain
            Credential = $Credential  # Credential to join to domain
        }

        LocalConfigurationManager {
            CertificateId = $node.Thumbprint
        }
    }
}

# A Helper to invoke the configuration, with the correct public key
# To encrypt the configuration credentials
function Start-DomainJoin {
    [CmdletBinding()]
    param ($computerName)

    [string] $thumbprint = Get-EncryptionCertificate -computerName $computerName -Verbose
    Write-Verbose "using cert: $thumbprint"

    $certificatePath = $filePath

    $ConfigData = @{
        AllNodes = @(
            @{
                # The name of the node we are describing
                NodeName             = "$computerName"

                # The path to the .cer file containing the
                # public key of the Encryption Certificate
                CertificateFile      = "$certificatePath"

                # The thumbprint of the Encryption Certificate
                # used to decrypt the credentials
                Thumbprint           = $thumbprint
                PSDscAllowDomainUser = $true
            };
        );
    }

    $OutPutPath = "$env:Windir\Temp\Mof\DomainJoinConfig"

    Write-Verbose "Generate DSC Configuration..."
    DomainJoinConfig -ConfigurationData $ConfigData -OutputPath $OutPutPath `
        -MachineName $computerName -credential (Get-Credential -UserName "$env:USERDOMAIN\$env:USERNAME" -Message "Enter credentials for configuration") -Domain "DomainName"

    Write-Host "Setting up LCM to decrypt credentials..."
    Set-DscLocalConfigurationManager $OutPutPath -Verbose

    Write-Verbose "Starting Configuration..."
    Start-DscConfiguration -Path $OutPutPath -Verbose -Wait -Force
}

# Helper Function to get the certificate thumbprint
function Get-EncryptionCertificate {
    [CmdletBinding()]
    param ($computerName)

    $cert = Invoke-Command -ComputerName $computerName -ScriptBlock {
        Get-ChildItem Cert:\LocalMachine\my | Where-Object { $_.Issuer -eq 'CN=DscDJEncryptionCert' }
    }

    return $cert.Thumbprint
}

Start-DomainJoin
