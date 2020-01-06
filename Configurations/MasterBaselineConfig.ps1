configuration MasterBaseline
{

    param
    (
       [Parameter()]
       [string]
       $OrgSettingsPath = 'C:\Temp\StigData\Processed'
    )

    Import-DscResource -ModuleName PowerSTIG -ModuleVersion 4.2.0

    Node $AllNodes.Where{$_.OsRole -eq 'MS'}.NodeName
    {

        WindowsServer ServerStigBaseline
        {
           OsVersion = $NodeName.OSVersion
           OsRole   = $NodeName.OSRole
           StigVersion = $NodeName.StigVersion
           OrgSettings = $NodeName.OrgSettings
        }

        InternetExplorer IEStigBaseline
        {
            BrowserVersion = $NodeName.BrowserVersion
            StigVersion = $NodeName.IeStigVersion
            OrgSettings = $NodeName.IeOrgSettings
        }
    }

    Node $AllNodes.Where{$_.OsRole -eq '10'}.NodeName
    {
        WindowsClient ClientStigBaseline
        {
           OsVersion = $NodeName.OSVersion
           StigVersion = $NodeName.StigVersion
           OrgSettings = $NodeName.OrgSettings
            # DomainName  = 'your.domain'
            # ForestName  = 'your.domin'
        }

        InternetExplorer IeStigBaseline
        {
            BrowserVersion = $NodeName.BrowserVersion
            StigVersion = $NodeName.IeStigVersion
            OrgSettings = $NodeName.IeOrgSettings
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'testlabdsc01'
            OsVersion = '2019'
            OsRole = 'MS'
            StigVersion = '1.2'
            OrgSettings = "$OrgSettingsPath\WindowsServer-2019-MS-1.2.org.default.xml"
            },
        @{
            NodeName = 'testlabcl01'
            OsVersion = '10'
            OsRole = '10'
            StigVersion = '1.18'
            OrgSettings = "$OrgSettingsPath\WindowsClient-10-1.18.org.default.xml"
            },
        @{
            NodeName = '*'
            BrowserVersion = '11'
            IeStigVersion = '1.18'
            IeOrgSettings = "$OrgSettingsPath\InternetExplorer-11-1.18.org.default.xml"
            }
    )
}

MasterBaseline -ConfigurationData $ConfigurationData -