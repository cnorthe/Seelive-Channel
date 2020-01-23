#############################################################################
# Edited by: John Rayborn
#
# Version : 1.1
# Created : 15 JAN 2018
# Modified : 9 DEC 2019
#
# Purpose : This script create a structure of folders to classify collections based on the purpose and define a naming convention. Basic collections are also created at the same time
# Blog post related : https://www.systemcenterdudes.com/powershell-script-create-set-maintenance-collections
# Script author: Jonathan Lefebvre-Globensky
# Website : www.SystemCenterDudes.com
#
#############################################################################

#Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

#Create Default Folders
new-item -NAme 'Compliance Settings' -Path $($SiteCode.Name+":\DeviceCollection")
new-item -NAme 'CS - Workstation Collections' -Path $($SiteCode.name+":\DeviceCollection\Compliance Settings")
new-item -NAme 'CS - Server Collections' -Path $($SiteCode.name+":\DeviceCollection\Compliance Settings")


#Create Collections
#List of Collections Query
$Collection1 = @{Name = "CS - All Windows 10 Clients"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Workstation 10.0%' and SMS_R_System.Client = '1'"}
$Collection2 = @{Name = "CS - All Server 2016 Clients"; Query = "select SMS_R_System.ResourceId, SMS_R_System.ResourceType, SMS_R_System.Name, SMS_R_System.SMSUniqueIdentifier, SMS_R_System.ResourceDomainORWorkgroup, SMS_R_System.Client from  SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_R_System.OperatingSystemNameandVersion like '%Server 10.0%' and SMS_G_System_OPERATING_SYSTEM.Caption like '%Server 2016%' and SMS_R_System.Client = '1'"}
$Collection3 = @{Name = "CS - All Server 2019 Clients"; Query = "select SMS_R_System.ResourceId, SMS_R_System.ResourceType, SMS_R_System.Name, SMS_R_System.SMSUniqueIdentifier, SMS_R_System.ResourceDomainORWorkgroup, SMS_R_System.Client from  SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_R_System.OperatingSystemNameandVersion like '%Server 10.0%' and SMS_G_System_OPERATING_SYSTEM.Caption like '%Server 2019%' and SMS_R_System.Client = '1'"}

#Define possible limiting collections
$LimitingCollectionAll = "All Systems"
$LimitingCollectionAllWork = "All Workstations"
$LimitingCollectionAllWorkAdmin = "All Workstations - Admin"
$LimitingCollectionAllServer = "All Servers"

#Refresh Schedule
$Schedule = New-CMSchedule –RecurInterval Days –RecurCount 2

#Create Collection
#try{
New-CMDeviceCollection -Name $Collection1.Name -Comment "CS - All Windows 10 Clients" -LimitingCollectionName $LimitingCollectionAll -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection1.Name -QueryExpression $Collection1.Query -RuleName $Collection1.Name
Write-host *** Collection $Collection1.Name created ***

New-CMDeviceCollection -Name $Collection2.Name -Comment "CS - All Server 2016 Clients" -LimitingCollectionName $LimitingCollectionAll -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection2.Name -QueryExpression $Collection2.Query -RuleName $Collection2.Name
Write-host *** Collection $Collection2.Name created ***

New-CMDeviceCollection -Name $Collection3.Name -Comment "CS - All Server 2019 Clients" -LimitingCollectionName $LimitingCollectionAll -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection3.Name -QueryExpression $Collection3.Query -RuleName $Collection3.Name
Write-host *** Collection $Collection3.Name created ***

#Move the collections to the right folder
#CS - Workstation Collections
$FolderPath = $SiteCode.name+":\DeviceCollection\Compliance Settings\CS - Workstation Collections"
Move-CMObject -FolderPath $FolderPath -InputObject (Get-CMDeviceCollection -Name $Collection1.Name)


#CS - Server Collections
$FolderPath = $SiteCode.name+":\DeviceCollection\Compliance Settings\CS - Server Collections"
Move-CMObject -FolderPath $FolderPath -InputObject (Get-CMDeviceCollection -Name $Collection2.Name)
Move-CMObject -FolderPath $FolderPath -InputObject (Get-CMDeviceCollection -Name $Collection3.Name)






