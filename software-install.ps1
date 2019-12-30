#This script will install any .EXE software update on mulitple computters

#This is the file that contains the list of computers you want the folders and files to. 
$Computers = Get-Content -Path "C:\Scripts\Computers.txt"

#This is source directory you want to copy to the list of computers.
$Source = "\\labps01\SMS_PS1\Tools\ConsoleSetup"

#This is the destination computer where the source will be copied to.
$Destination = "$env:WINDIR\Temp"

#This will test the source on the destination computers.
$testPath = "$env:WINDIR\Temp\ConsoleSetup\ConsoleSetup.exe"

forEach ($Computer in $Computers) {
    if (Test-Connection -ComputerName $Computer -Quiet) {
        Copy-Item -Path $Source -Destination "\\$Computer\$Destination" -Recurse -Force

    if (Test-Path -Path $testPath) {
        Invoke-Command -ComputerName $Computer -ScriptBlock {
            powershell.exe C:\Windows\Temp\ConsoleSetup\ConsoleSetup.exe /q TargetDir="C:\Program Files\ConfigMgr" EnableSQM=0 DefaultSiteServerName=labps01.Contoso.com
                }
            Write-Host -ForegroundColor Green "$Installation Successful on $Computer"
        }
    } 
    else {
        Write-Host -ForegroundColor Yellow "Computer is NOT Online, Install Failed"
    }
}