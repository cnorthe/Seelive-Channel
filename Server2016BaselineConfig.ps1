configuration Server2016Baseline
{

    param
    (
       [Parameter()]
       [string]
       $NodeName = 'localhost'
    )

    Import-DscResource -ModuleName PowerSTIG -ModuleVersion 4.1.1

    node localhost
    {

        WindowsServer STIGBaseline
        {
           OsVersion = '2016'
           OsRole   = 'MS'
           StigVersion = '1.8'
           OrgSettings = 'C:\Temp\WindowsServer-2016-MS-1.8.org.default.xml'
        }
    }
}

Server2016Baseline -OutputPath C:\Mof\Server2016Baseline

#Start-DscConfiguration -Path C:\Mof\Server2016Baseline -Wait -Verbose

Test-DscConfiguration -Detailed | Select-Object ResourcesNotInDesiredState -ExpandProperty ResourcesNotInDesiredState | Out-GridView

Test-DscConfiguration -Path C:\Mof\Server2016Baseline -Verbose