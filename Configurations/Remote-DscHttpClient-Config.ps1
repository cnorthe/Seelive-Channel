[CmdletBinding()]
Param(
    [Parameter()]
    [string[]]
    $ComputerName = @('localhost')
)

[DSCLocalConfigurationManager()]
configuration PullClientNodes
{
Param (
    [String[]]
    $NodeName
    )

    Node $NodeName
    {
        Settings
        {
            RefreshMode = 'Pull'
            RefreshFrequencyMins = 30
            RebootNodeIfNeeded = $true
            ConfigurationMode = 'ApplyAndAutoCorrect'
        }

        ConfigurationRepositoryWeb testlabdsc02
        {
            ServerURL = 'http://testlabdsc02:8080/PSDSCPullServer.svc'
            RegistrationKey = '898aaf1a-c055-48e1-a92b-710a2cb77a4c'
            ConfigurationNames = @('DSCFromGPO')
            AllowUnsecureConnection = $true
        }

        ResourceRepositoryWeb WebResources
        {
            ServerURL = 'http://testlabdsc02:8080/PSDSCPullServer.svc'
            RegistrationKey = '898aaf1a-c055-48e1-a92b-710a2cb77a4c'
            AllowUnsecureConnection = $true
        }

        ReportServerWeb WebReport
        {
            ServerURL = 'http://testlabdsc02:8080/PSDSCPullServer.svc'
            AllowUnsecureConnection = $true
        }

        PartialConfiguration DSCFromGPO
        {
            Description                     = "DSCFromGPO"
            ConfigurationSource             = @("[ConfigurationRepositoryWeb]testlabdsc02")
        }
    }
}


PullClientNodes -NodeName $ComputerName -OutputPath '.\PullClientNodes'

Set-DscLocalConfigurationManager -Path '.\PullClientNodes' -ComputerName $ComputerName