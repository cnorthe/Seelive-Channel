<#
    .DISCLAIMER
 
    This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.  
    THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
    INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant You 
    a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of 
    the Sample Code, provided that You agree: (i) to not use Our name, logo, or trademarks to market Your software product in which 
    the Sample Code is embedded; (ii) to include a valid copyright notice on Your software product in which the Sample Code is 
    embedded; and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, 
    including attorneys’ fees, that arise or result from the use or distribution of the Sample Code.

    .DESCRIPTION
    Reinstall the SCCM client on a single computer.  Alternative if there are issues with Client Push.  Creates a local log file
    in the directory where the script is initiated.

    .REQUIREMENTS
    Account used must have administrative access to the remote computers

    .PARAMETER
    Computer
        - Computer name of system

    ClientPath
        - Location where CCMSetup files exist

    SiteCode
        - Site code of SCCM Primary Site

    MP
        - Management point to assign

    Feel free to add any additional switches or parameters as needed
   
    .REFERENCES
    https://support.microsoft.com/en-us/help/4471061/client-pc-being-imaged-steals-configuration-manager-guid
             
    .EXAMPLE OF SCRIPT
    .\Reinstall-SingleSCCMClient.ps1 -Computer PC1 -ClientPath \\sccmpri\source\client -SiteCode PRI -MP sccmpri.contoso.com

    .NOTES
    Author:           Brandon McMillan (MSFT)
    Acknowledgments:  Seth Akin (MSFT), Tracy Lynn (MSFT)
    Updated:          2019.04.18
#>

param(
[parameter(Mandatory=$True)]
[ValidateNotNullorEmpty()]
$Computer,
[Parameter(Mandatory=$True)] 
[ValidateNotNullorEmpty()]
$ClientPath,
[Parameter(Mandatory=$True)] 
[ValidateNotNullorEmpty()]
$SiteCode,
[Parameter(Mandatory=$True)] 
[ValidateNotNullorEmpty()]
$MP
)

# Calling variables
$p = New-Object System.Diagnostics.Process
$ErrorActionPreference = "SilentlyContinue"

# Setting Log File
$LogPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$LogFile = "$PSScriptRoot\SCCMClient_Reinstall.log"

If (Test-Path -Path $LogFile) {
    Write-Host "$LogFile exists.  Removing previous log file..." -ForegroundColor Cyan
    # Removing previous archived log file
    Remove-Item $LogFile -Force
}
else {
    Write-Host "$LogFile does not exist.  Continuing..." -ForegroundColor Green
}

Function Write-Log {
    Param ([string]$logMsg)
    [string]$logMessage = [System.String]::Format("[$(Get-Date)] - {0}", $logMsg) 
    Add-Content -Path $LogFile -Value $logMessage
} 

Write-Host "Attempting to reinstall SCCM Client on $Computer..."
Write-Log "Attempting to reinstall SCCM Client on $Computer..."
Write-Host "--------------------------------------------------"

# Test Connectivity and WinRM Service
Try {
    If (test-connection $Computer -quiet) {
        Write-Host "$Computer is active..."
        Write-Log "$Computer is active..."
        If (!(Test-WSMan -ComputerName $Computer)) {
            Write-Host "Starting WinRM Service on $Computer..." -ForegroundColor Cyan
            Get-Service -Name WinRM -ComputerName $Computer | Start-Service
            Write-Log "WinRM service started on $Computer..."
        }
        Else {
            Write-Host "WinRM Service is already started on $Computer.  Continuing..."
            Write-Log "WinRM Service is already started on $Computer.  Continuing..."
        }
    }
    Else {
        Write-Host "Cannot connect to $Computer.  Please verify if the client name is correct, online, or if there are issues with the Firewall." -ForegroundColor Red
        Write-Log "ERROR Cannot connect to $Computer.  Please verify if the client name is correct, online, or if there are issues with the Firewall."
        Exit $p.ExitCode
    }
}
catch {
    Write-Host "Cannot start WinRM service on $Computer.  Please verify if there are any issues with the client." -ForegroundColor Red
    Write-Log "ERROR Cannot start WinRM service on $Computer.  Please verify if there are any issues with the client."
    Exit $p.ExitCode
}

# Remove Previous ConfigMgr Client
Try {
    Write-Host "Checking for previous SCCM Client on $Computer..." -ForegroundColor Cyan
    Write-Log "Checking for previous SCCM Client on $Computer..."
    If(Get-WmiObject -Namespace root\ccm -Class SMS_Client -ComputerName $Computer) {
        Write-Host "SCCM Client detected on $Computer...uninstalling." -ForegroundColor Green
        Write-Log "SCCM Client detected on $Computer...uninstalling."
        Invoke-Command -ComputerName $Computer -ScriptBlock {cmd.exe /C 'C:\windows\ccmsetup\ccmsetup.exe /uninstall'}
        Write-Log "SCCM Client uninstalled..."
        Invoke-Command -ComputerName $Computer -ScriptBlock {Remove-Item c:\Windows\SMSCFG.ini -Force}
        Write-Log "C:\Windows\SMSCFG.ini file removed successfully..."
        Invoke-Command -ComputerName $Computer -ScriptBlock {cmd.exe /C 'certutil.exe -delstore SMS SMS'}
        Write-Log "SMS Cert removed successfully..."
        Invoke-Command -ComputerName $Computer -ScriptBlock {Remove-Item c:\Windows\CCM -Force -Recurse}
        Write-Log "C:\Windows\CCM folder removed successfully..."
        Invoke-Command -ComputerName $Computer -ScriptBlock {Remove-Item c:\Windows\Ccmsetup -Force -Recurse}
        Write-Log "C:\Windows\CCMsetup folder removed successfully..."
        Invoke-Command -ComputerName $Computer -ScriptBlock {Remove-Item HKLM:\Software\Microsoft\CCM -Force -Recurse}
        Invoke-Command -ComputerName $Computer -ScriptBlock {Remove-Item HKLM:\Software\Microsoft\CCMSetup -Force -Recurse}
        Invoke-Command -ComputerName $Computer -ScriptBlock {Remove-Item HKLM:\Software\Microsoft\SMS -Force -Recurse}
        Write-Log "Residual CCM/CCMSetup/SMS registry entries removed successfully..."
    }
    else {
       Write-Host "No SCCM client detected on $Computer.  Continuing..." -ForegroundColor Cyan
       Write-Log "No SCCM client detected on $Computer.  Continuing..."
    }
}
catch {
    Write-Host "Cannot uninstall SCCM Client. Please verify the configurations on the system and try again." -ForegroundColor Red
    Write-Log "ERROR Cannot uninstall SCCM Client. Please verify the configurations on the system and try again."
    Get-Service -Name WinRM -ComputerName $Computer | Stop-Service -Force
    Exit $p.ExitCode
}

# Kick off ConfigMgr Client Install
Try {
    Write-Host "Installing SCCM Client on $Computer." -ForegroundColor Cyan
    Write-Log "Installing SCCM Client on $Computer."
    Invoke-Command -ComputerName $Computer -ScriptBlock {New-Item -Path C:\SCCMClient -ItemType Directory -Force}
    Write-Log "Staging $ClientPath source files..."
    Copy-Item -Path $ClientPath\* -Destination "\\$Computer\C$\SCCMClient" -Recurse
    Write-Log "Copied over $ClientPath source files successfully to $Computer..."
    Invoke-Command -ComputerName $Computer -ScriptBlock {cmd.exe /C 'C:\SCCMClient\ccmsetup.exe SMSSITECODE=AUTO SMSCACHESIZE=10000 CCMLOGMAXSIZE=5242880 CCMLOGMAXHISTORY=3'}
    Write-Log "Installing new SCCM Client..."
    Invoke-Command -ComputerName $Computer -ScriptBlock {Wait-Process -ProcessName ccmsetup}
    Write-Log "Waiting for SCCM Client to complete..."
    Write-Log "Installed new SCCM Client successfully..."
    Invoke-Command -ComputerName $Computer -ScriptBlock {(New-Object –ComObject 'Microsoft.SMS.Client').SetAssignedSite($SiteCode)}
    Write-Log "Set Assigned Site to $SiteCode..."
    Invoke-Command -ComputerName $Computer -ScriptBlock {(New-Object –ComObject 'Microsoft.SMS.Client').SetCurrentManagementPoint($MP)}
    Write-Log "Set Current Management Point to $MP..."
    Start-Sleep -s 5
    Get-Service -Name Ccmexec -ComputerName $Computer | Restart-Service
    Write-Log "Restarting Ccmexec service..."
    Start-Sleep -s 10
    Invoke-WmiMethod -ComputerName $Computer -Namespace root\CCM -Class SMS_Client -Name SetClientProvisioningMode -ArgumentList $false
    Invoke-WMIMethod -ComputerName $Computer -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule “{00000000-0000-0000-0000-000000000022}”
    Write-Log "Triggered Machine Policy Retrieval on $Computer..."
    Write-Host "SCCM Client Reinstall Complete on $Computer." -ForegroundColor Green
    Invoke-Command -ComputerName $Computer -ScriptBlock {Remove-Item -Path c:\SCCMClient -Force -Recurse}
    Write-Log "Removed SCCMClient source files successfully..."
    Write-Log "SCCM Client Reinstall Complete on $Computer..."
}
catch {
    Write-Host "SCCM Installation failed on $Computer.  Please review the CCMSetup and CCM logs folder for further information and health validation." -ForegroundColor Red
    Write-Log "ERROR SCCM Installation failed on $Computer.  Please review the CCMSetup and CCM logs folder for further information and health validation."
    Get-Service -Name WinRM -ComputerName $Computer | Stop-Service -Force
    Exit $p.ExitCode
}

# Stopping WinRM Service
Get-Service -Name WinRM -ComputerName $Computer | Stop-Service -Force

Write-Log "--------------------------------------------------"
Write-Host "--------------------------------------------------"

Exit $p.ExitCode