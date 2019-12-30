configuration CreateTestFile
{

param (
        [string]$DestinationPath = 'C:\Temp\testfile.txt',
        [string]$NodeName = 'Windows10'
       )

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    node $NodeName
    {

        File TestFile
        {
            Ensure          = 'Present'
            DestinationPath = $DestinationPath
            Type            = 'File'
            Contents        = ''
        }
<#
        Log TestFileLog
        {
            Message   = 'The Test File was created Successfully'
            DependsOn = '[File]TestFile]'
        }
#>
    }
}

Set-Location $env:TEMP

CreateTestFile

Test-DscConfiguration

Start-DscConfiguration -ComputerName testlabcl02 -Path c:\Mof