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
           OsVersion = $Node.OSVersion
           OsRole   = $Node.OSRole
           StigVersion = $Node.StigVersion
           OrgSettings = $Node.OrgSettings
        }

        InternetExplorer IEStigBaseline
        {
            BrowserVersion = $Node.BrowserVersion
            StigVersion = $Node.IeStigVersion
            OrgSettings = $Node.IeOrgSettings
        }
    }

    Node $AllNodes.Where{$_.OsRole -eq '10'}.NodeName
    {
        WindowsClient ClientStigBaseline
        {
           OsVersion = $Node.OSVersion
           StigVersion = $Node.StigVersion
           OrgSettings = $Node.OrgSettings
            # DomainName  = 'your.domain'
            # ForestName  = 'your.domin'
        }

        InternetExplorer IeStigBaseline
        {
            BrowserVersion = $Node.BrowserVersion
            StigVersion = $Node.IeStigVersion
            OrgSettings = $Node.IeOrgSettings
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

MasterBaseline -ConfigurationData $ConfigurationData -OutputPath 'C:\Repo\Seelive-Channel\Mofs'