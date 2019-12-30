#This script will install any CCMSetup.EXE software on mulitple computters

#list of Computers to receive client
$Computers = Get-Content -Path 'C:\temp\Computers.txt'

#This is the location where the CCM Client Software is located
$Source = "\\testlabcl01\SoftwareLib\Client"

#This is the destination computer where the source will be copied to.
$Destination = "c$\Windows\Temp"

forEach ($Computer in $Computers) {
    if (Test-Connection -ComputerName $Computer -Quiet) {
        Copy-Item -Path $Source -Destination \\$Computer\$Destination -Recurse -Force

        #This will test the source on the destination computers.
        $testPath = "\\$Computer\$Destination\Client\CCMsetup.exe"

    if (Test-Path -Path $testPath) {
        Invoke-Command -ComputerName $Computer -ScriptBlock {
            powershell.exe c:\windows\temp\Client\CCMsetup.exe /mp:testlabdpmp01.contoso.com /logon SMSSITECODE=AUTO
                }
            Write-Host -ForegroundColor Green "SCCM Client is Installing on $Computer"
        }
    } 
    else {
        Write-Host -ForegroundColor Yellow "$Computer is NOT Online, Install Failed"
    }
}