#$cred = Get-Credential

[DscLocalConfigurationManager()]
configuration PullClientConfigID
{

    node localhost
    {

        Settings
        {
           RefreshMode = "Pull"
           ConfigurationID   = "430068fe-6b3a-4ee0-85f1-38f2ef8c67a0"
           RefreshFrequencyMins = 30
           RebootNodeIfNeeded = $true
        }

        ConfigurationRepositoryShare SmbConfigShare
        {
            SourcePath = "\\testlabdsc01\DscSmbShare"
            #Credential = $cred
        }

        ResourceRepositoryShare SmbResourceShare
        {
            SourcePath = "\\testlabdsc01\DscSmbShare"
            #Credential = $cred
        }
    }
}

Set-Location -Path $env:Temp
PullClientConfigID
Set-DscLocalConfigurationManager -Path .\PullClientConfigID -Verbose

Update-DscConfiguration -Verbose
Get-DscLocalConfigurationManager