$GPOBackups = gci C:\Resources\U_STIG_GPO_Package_July_2020\*\bkupinfo.xml -Recurse | Select-Object Name,FullName
$domain = "contoso.com"
foreach($gpobackup in $GPOBackups)
{
[xml]$xml = gc $gpobackup.FullName
$GPOName = $xml.BackupInst.GPODisplayName | Select-Object -expand "#cdata-section"
$GPOPath = $gpobackup.FullName
$GPOID = $xml.BackupInst.ID | Select-Object -expand "#cdata-section"
$GPOParent = $gpobackup.FullName | Split-Path -Parent | Split-Path -Parent

 $GPOName
$GPOID
$gpo = New-GPO -Name $GPOName -Domain $domain
Import-GPO -TargetName $gpo.DisplayName -Domain $domain -Path $GPOParent -BackupId $GPOId
}