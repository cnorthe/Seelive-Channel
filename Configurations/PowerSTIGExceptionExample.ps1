configuration Example
{
    param
    (
        [parameter()]
        [string]
        $NodeName = 'localhost'
    )

    Import-DscResource -ModuleName PowerStig

    Node $NodeName
    {
        WindowsServer BaseLine
        {
            OsVersion   = '2012R2'
            OsRole      = 'MS'
            StigVersion = '2.12'
            OrgSettings = "\\Share\OrgSettings\Windows-2012R2-MS-2.12.xml"
            Exception   = @{'V-1075' = @{ValueData=1}}
        }
    }
}

Example -OutputPath C:\dev

Start-DSCEAscan -MofFile C:\Dev\localhost.mof -ComputerName Server01 -OutputPath C:\Dev\DSCEA

$audit = Import-Clixml -Path 'C:\Dev\DSCEA\Output\results.20181127-1149-48.xml'
$audit.Compliance
$audit.Compliance.ResourcesNotInDesiredState
$audit.Compliance.ResourcesNotInDesiredState[0]

#Document PowerSTIG Exceptions
$audit = Test-DscConfiguration -ReferenceConfiguration C:\dev\localhost.mof

$audit = Import-Clixml -Path 'C:\repo\Seelive-Channel\Mofs\DSCEA\results.20200103-1517

#Exceptions that need documentation
($audit.ResourcesNotInDesiredState + $audit.ResourcesInDesiredState) | Where-Object ResourceId -match \[Exception\]