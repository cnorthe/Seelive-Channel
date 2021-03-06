configuration MasterBaseline
{
    Import-DscResource -ModuleName PowerSTIG -ModuleVersion 4.2.0

    Node $AllNodes.Where{$_.OsRole -eq 'MS'}.NodeName
    {

        WindowsServer ServerStigBaseline
        {
            OsVersion   = $Node.ServerOSVersion
            OsRole      = $Node.OSRole
            StigVersion = $Node.ServerStigVersion
            OrgSettings = $Node.ServerOrgSettings
            SkipRule    = $Node.SkipRule
            #Exception   = $Node.Exception
        }

        InternetExplorer IEStigBaseline
        {
            BrowserVersion = $Node.BrowserVersion
            StigVersion    = $Node.IeStigVersion
            OrgSettings    = $Node.IeOrgSettings
        }
    }

    Node $AllNodes.Where{$_.OsRole -eq '10'}.NodeName
    {
        WindowsClient ClientStigBaseline
        {
           OsVersion   = $Node.ClientOSVersion
           StigVersion = $Node.ClientStigVersion
           OrgSettings = $Node.ClientOrgSettings
        }

        InternetExplorer IeStigBaseline
        {
            BrowserVersion = $Node.BrowserVersion
            StigVersion    = $Node.IeStigVersion
            OrgSettings    = $Node.IeOrgSettings
        }
    }
}

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName          = 'testlabdsc01'
            ServerOsVersion   = '2019'
            OsRole            = 'MS'
            ServerStigVersion = '1.2'
            ServerOrgSettings = 'C:\Temp\StigData\Processed\WindowsServer-2019-MS-1.2.org.default.xml'
            },
        @{
            NodeName          = 'testlabcl01'
            ClientOsVersion   = '10'
            OsRole            = '10'
            ClientStigVersion = '1.18'
            ClientOrgSettings = 'C:\Temp\StigData\Processed\WindowsClient-10-1.18.org.default.xml'
            },
        @{
            NodeName       = '*'
            BrowserVersion = '11'
            IeStigVersion  = '1.18'
            IeOrgSettings  = 'C:\Temp\StigData\Processed\InternetExplorer-11-1.18.org.default.xml'
            SkipRule       = 'V-93025.a','V-93025.b','V-93025.c'
            # DomainName   = 'your.domain'
            # ForestName   = 'your.domin'
            # Exception      = @{'V-92961'= @{'ValueData'='1'}}
            }
    )
}

MasterBaseline -ConfigurationData $ConfigurationData -OutputPath 'C:\Repo\Seelive-Channel\Mofs\MasterBaseline'
$ResourcesNotInDesiredState = Test-DscConfiguration -Path 'C:\Repo\Seelive-Channel\Mofs\MasterBaseline' | Select-Object -ExpandProperty ResourcesNotInDesiredState
$ResourcesNotInDesiredState | Select-Object @{Name='ComputerName';Expression={$_.PSComputerName}}, ModuleName, ModuleVersion, InDesiredState, @{Name='Revision Description';Expression={$_.InstanceName}}, RebootRequested, ResourceName, StartDate, StateChanged | Out-GridView
