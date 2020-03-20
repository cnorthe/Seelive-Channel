<#     
============================================================================================
        Script: Module-Header.ps1
        Version: 1.0.0.0
    ---------------------------------------------------------
    .DESCRIPTION
    This file is included at the beginning of all module scripts
    
    ---------------------------------------------------------
    History:
    Ver               Modifications
    ---------------------------------------------------------
    1.0.0.0             
    
============================================================================================
#>

$ModulesPath = "${BaselineRoot}\Modules"
$IncludePath = "${BaselineRoot}\Include"

# Check that current user is an admin
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if(-not $myWindowsPrincipal.IsInRole($adminRole)) {
    Write-Error "This script must be run as an admin" -ErrorAction Stop
    Exit
}

$Date = Get-Date
$Timestamp = Get-Date -Date $Date -Format "yyyyMMddTHHmmss"

$BaselineConfigFolder = "BaselineConfigurations"
$CurrentConfigFolder = "AuditConfigurations"
$BaselineArchiveFolder = "BaselineArchives"
$ReportsFolder = "Reports"
$BaselineConfigPath = "${BaselineRoot}\${BaselineConfigFolder}"
$CurrentConfigPath = "${BaselineRoot}\${CurrentConfigFolder}"
$BaselineArchivesPath = "${BaselineRoot}\${BaselineArchiveFolder}"
$ReportsPath = "${BaselineRoot}\${ReportsFolder}"

. "${IncludePath}\Baseline-Functions.ps1"

Create-Baseline-Directories