<#
.SYNOPSIS
	This scripts detects and enable Windows Defedner Application Guard feature on Windows 10/11 computer systems
.DISCRIPTION
	This scripts detects and enable Windows Defedner Application Guard feature on Windows 10/11 computer systems
.NOTES
	This Script created by Clive Northey. Microsoft Corp. 3/15/2023
#>

$MDAGCheck = Get-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard

If($MDAGCheck.State -eq "Enabled"){
    $Compliance = 'Yes'
}
else{
    $Compliance = 'No'
}
$Compliance

#Remediation script
Enable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard -NoRestart

#Disable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard -NoRestart
