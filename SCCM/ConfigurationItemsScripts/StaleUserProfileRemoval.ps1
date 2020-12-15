$SystemProfileRetention = 180
$LogFile = "$env:windir\temp\ProfileCleanUp.log"
$TodaysDate = (Get-Date)
$Profiles = Get-CimInstance -ClassName Win32_UserProfile | Where-Object{$_.Special -eq $false} | Where-Object {$_.LastUseTIme -lt (Get-Date).AddDays(0-$SystemProfileRetention)}

if ((Test-Path "\\mcdsus.mcds.usmc.mil\NETLOGON") -and $Profiles)
{
   "$TodaysDate Starting Profile Cleanup with a retention rate of $SystemProfileRetention days" | Out-File $LogFile -Append
    ForEach ($Profile in $Profiles)
    {
        $ProfileUser = $Profile.LocalPath.ToString()
        $ProfileUser = $ProfileUser.SubString($ProfileUser.LastIndexOf('\') + 1,($ProfileUser.Length - $ProfileUser.LastIndexOf('\') - 1))
        $strSID = $Profile.SID
        Try
        {
            $uSID = [ADSI]"LDAP://<SID=$strSID>"
        }
        Catch
        {
            $uSID=$null
        }
        If ($null -eq $uSID.distinguishedName)
        {
            "$TodaysDate User profile $ProfileUser SID does not exist in Active Directory profile will be deleted." | Out-File $LogFile -Append
            Get-CimInstance -ClassName Win32_UserProfile | Where-Object{$_.LocalPath -eq $Profile.LocalPath} | Remove-CimInstance
            Write-Output $false
        }

        ElseIf ($uSID.distinguishedName -match "OU=Service Accounts")
        {
            "$TodaysDate User profile $ProfileUser SID was found in a Service Account OU profile will be retained." | Out-File $LogFile -Append
            Write-Output $true
        }
        Else
        {
            "$TodaysDate User profile $ProfileUser is obsolete profile will be deleted." | Out-File $LogFile -Append
            Get-CimInstance -ClassName Win32_UserProfile | Where-Object{$_.LocalPath -eq $Profile.LocalPath} | Remove-CimInstance
            Write-Output $false
        }
    }
}
        Else
        {
            "$TodaysDate Unable to find domain profile cleanup will be skipped today" | Out-File $LogFile -Append
            Write-Output $true
        }
