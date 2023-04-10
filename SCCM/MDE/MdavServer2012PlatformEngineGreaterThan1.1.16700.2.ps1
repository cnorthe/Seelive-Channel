#Created by Clive Northey Microsoft Corp. MCS
#Date created 11/28/2022
#Notes: this script only works on Windows 10/11 and Server 2016, 2019, 2022


$requiredPlatformVersion = '1.1.16700.2'
$registrykey = Get-ItemPropertyValue -Path Registry::'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender' -Name InstallLocation
$platformEngineVersion = Split-path $registrykey -Leaf
$platformEngineVersion = $platformEngineVersion -split('-0')
[string]$platformEngineVersion -ge $requiredPlatformVersion

