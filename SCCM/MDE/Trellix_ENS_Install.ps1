<#
.SYNOPSIS
This script installs Trellix Endpoint Security Standalone Client 10.7.0.1390.13
.DISCRIPTION
This script installs Trellix Endpoint Security Standalone Client 10.7.0.1390.13
.NOTES
This Script created by Clive Northey. Microsoft Corp. 3/18/2023
 
.EXAMPLE
.\install.ps1
#>
$workingDir = $MyInvocation.MyCommand.Path | Split-Path -Parent
$InstallArgs = "ADDLOCAL=`"tp,fw`" /l`"$($env:WinDIR)\Temp\Endpoint_Security_10.7.0.1390.13\`" /qn"
Start-Process -FilePath "$workingDir\SetupEP.exe" -ArgumentList $InstallArgs -NoNewWindow -Wait
