filename = ".\ExportedGroups.csv"
Get-ADGroup -Filter '*' | select-object * | where-object {$_.distinguishedname -like "*,OU=Container,*"} |Export-Csv -Path $filename
