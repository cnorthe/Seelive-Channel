[DSCLocalConfigurationManager()]
configuration PullClientConfigNames
{
    Node localhost
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
            ConfigurationNames = @('CreateTestFile')
            AllowUnsecureConnection = $true
        }
    }
}

Set-Location -Path $env:Temp

PullClientConfigNames

Set-DscLocalConfigurationManager -Path .\PullClientConfigNames -Verbose

Get-DscLocalConfigurationManager

Update-DscConfiguration -Verbose