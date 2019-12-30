#install xPSDesiredStateConfiguration

if ($null -eq (Get-Module xPSDesiredStateConfiguration -ListAvailable))
{
    Find-Module -Name xPSDesiredStateConfiguration -Repository PSGallery | Install-Module -Force
}



configuration DscPullServer
{
    param (
        [string[]]$ComputerName = 'localhost',
        #[ValidateNotNullOrEmpty()]
        #[string]$certificateThumbPrint,
	    [Parameter(Mandatory)]
	    [ValidateNotNullOrEmpty()]
	    [string]$RegistrationKey
    )

	Import-DscResource -ModuleName PSDesiredStateConfiguration
	Import-DscResource -ModuleName xPSDesiredStateConfiguration

    node $ComputerName
    {

        WindowsFeature IISWebServer
        {
           Ensure = 'Present'
           Name   = 'Web-Server'
        }  


	    WindowsFeature DSCServiceFeature
        {
           Ensure = 'Present'
           Name   = 'DSC-Service'
        }

	    xDscWebService PSDSCPullServer
        {
           Ensure = 'Present'
           EndpointName  = 'PSDSCPullServer'
	       #Port = 443
           Port = 8080
           PhysicalPath = "$env:SystemDrive\inetpub\PSDSCPullServer"
	       ModulePath = "$env:ProgramFiles\WindowsPowerShell\DscService\Modules"
           ConfigurationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\Configuration"
	       State = 'Started'
	       DependsOn = '[WindowsFeature]DSCServiceFeature'
           #CertificateThumbPrint = $certificateThumbPrint
	       CertificateThumbPrint = 'AllowUnencryptedTraffic'		
	       UseSecurityBestPractices = $false
	       AcceptSelfSignedCertificates = $false
        }

        File RegistrationKeyFile
        {
            Ensure          = 'Present'
	        Type            = 'File'
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = "$RegistrationKey"
            DependsOn       = '[WindowsFeature]DSCServiceFeature'
        }

	# (Optional)
	WindowsFeature WebMgmtTools
        {
           Ensure = 'Present'
           Name   = 'Web-Mgmt-Tools'
        }     
    }
}

# Find the Thumbprint for an installed SSL certificate for use with the pull server

$cert = Get-ChildItem -Path Cert:\LocalMachine\my | Where-Object FriendlyName -eq 'dscpullserver'
$cert

# Generate a new registration key to pass to the configuration

$regKey = New-Guid
$regKey

# Set to temp location
Set-Location -Path $env:TEMP

# Then include the thumbprint and registration key when running the configuration to create a MOF
#DSCPullServer -certificateThumbprint $cert.Thumbprint -RegistrationKey $regKey
DSCPullServer -RegistrationKey $regKey

# Run the compiled configuration to make the target node a DSC Pull Server
Start-DscConfiguration -Path .\DSCPullServer -Wait -Verbose -Force

#Test configuration
Test-DscConfiguration -Path .\DSCPullServer -Verbose