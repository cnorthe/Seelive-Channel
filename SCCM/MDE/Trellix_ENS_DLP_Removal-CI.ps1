<#
.SYNOPSIS
This scripts checks McAfee/Trellix products removed from computer systems
.DISCRIPTION
This scripts checks McAfee/Trellix products removed from computer systems
.NOTES
This Script created by Clive Northey. Microsoft Corp. 1/5/2023
#>

$trellixENSDLPServices = Get-Service -Name 'mfefire','mfemms','mfevtp','McAfeeDLPAgentService' -ErrorAction SilentlyContinue

if ($null -eq $trellixENSDLPServices){

    $Compliance = 'Yes'
}
else
{
    $Compliance = 'No'
}
$Compliance