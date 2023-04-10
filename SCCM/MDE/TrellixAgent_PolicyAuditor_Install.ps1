<#
.SYNOPSIS
This script installs Trellix Agent 5.7.8.262 and McAfee Policy Auditor 6.5.4.371
.DISCRIPTION
This script installs Trellix Agent 5.7.8.262 and McAfee Policy Auditor 6.5.4.371
.NOTES
This Script created by Clive Northey. Microsoft Corp. 1/30/2023
.EXAMPLE
.\install.ps1
#>
$workingDir = $MyInvocation.MyCommand.Path | Split-Path -Parent
$TrellixInstallArgs = '/Install=Agent /Silent'
Start-Process -FilePath "$workingDir\FramePkg.exe" -ArgumentList $TrellixInstallArgs -NoNewWindow -Wait
$PolicyAuditorInstallArgs = '/s'
Start-Process -FilePath "$workingDir\Setup.exe" -ArgumentList $PolicyAuditorInstallArgs -NoNewWindow -Wait
