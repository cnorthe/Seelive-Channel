<#
.SYNOPSIS
This script installs McAfee (Trellix) Endpoint Product Removal 22.11.0.15 except MA and PA
.DISCRIPTION
This script installs McAfee (Trellix) Endpoint Product Removal 22.11.0.15 except MA and PA
.NOTES
This Script created by Clive Northey. Microsoft Corp. 1/11/2022
This Program will Expire on 12/5/2022
.EXAMPLE
.\install-PA.ps1
#>
$workingDir = $MyInvocation.MyCommand.Path | Split-Path -Parent
$InstallArgs = '--accepteula','--DLP','--ENS','--DELETEFRPKEYS','--NOTELEMETRY','--NOREBOOT'
Start-Process -FilePath "$workingDir\McAfeeEndpointProductRemoval_22.11.0.15.exe" -ArgumentList $InstallArgs -NoNewWindow -Wait
 
#SCCM Program Install
#PowerShell.exe -WindowStyle Hidden -ExecutionPolicy ByPass -File "install-PA.ps1"
