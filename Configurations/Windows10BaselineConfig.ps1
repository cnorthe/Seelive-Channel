$OrgSettingsPath = 'C:\Users\labdomainadmin\Documents\WindowsPowerShell\Modules\PowerSTIG\4.2.0\StigData\Processed'

configuration Windows10Baseline
{

    param
    (
       [Parameter()]
       [string]
       $NodeName = 'localhost'
    )

    Import-DscResource -ModuleName PowerSTIG -ModuleVersion 4.2.0

    node localhost
    {

        WindowsClient STIGBaseline
        {
           OsVersion = '10'
           # OsRole   = '10'
           StigVersion = '1.18'
           OrgSettings = "$OrgSettingsPath\WindowsClient-10-1.18.org.default.xml"
            # DomainName  = 'your.domain'
            # ForestName  = 'your.domin'
        }
    }
}

Windows10Baseline -OutputPath C:\Repo\Seelive-Channel\Mofs\Windows10Baseline

#Start-DscConfiguration -Path C:\Repo\Seelive-Channel\Mofs\Windows10Baseline -Wait -Verbose

Test-DscConfiguration -Detailed | Select-Object ResourcesNotInDesiredState -ExpandProperty ResourcesNotInDesiredState | Out-GridView

Test-DscConfiguration -Path C:\Repo\Seelive-Channel\Mofs\Windows10Baseline -Verbose