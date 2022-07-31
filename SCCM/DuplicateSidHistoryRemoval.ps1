<#
.SYNOPSIS
       This script removes the previous conflicting duplicate profile SID from registry.

.DISCRIPTION
       The script imports a csv of the previous user accounts sidHistory and matches it against the profile SID
       in the registry and removes it. This script should ONLY be used to remediate the duplicate profile issue for the
       the Windows 10 20H2 upgrade in place. The script also logs the sid that was removed.

.NOTES
       This script was created Clive Northey. Microsoft Corperation

.EXAMPLE
       .\sidHistoryRemoval.ps1
#>

Param(
    [Parameter()]
    [string]
    $RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList',

    [Parameter()]
    [string]
    $LogFilePath = "$ENV:Windir\Temp\removedSID.txt"
)

$Path = $MyInvocation.MyCommand.Path | Split-Path -Parent

$sourceSids = Import-Csv -Path "$Path\userSIDHistory.csv"

$targetSids = (Get-Item -Path "$RegPath\*").Name
$targetSids = Split-Path $targetSids -Leaf

$matchSids = $sourceSids.SID | Where-Object -FilterScript { $_ -in $targetSids }

if ($matchSids)
{
    forEach ($sid in $matchSids)
    {
        Remove-Item -Path "$RegPath\$sid" -Force
        $logmessage = "Sid Profile [$sid] was removed from Registry."
        $logmessage + " - " + (Get-Date).ToString() >> $LogFilePath
    }
}
else
{
    $logmessage = "Sid Profiles did not match, No SIDs removed."
    $logmessage + " - " + (Get-Date).ToString() >> $LogFilePath
}
