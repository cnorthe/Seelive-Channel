<#
.Synopsis
   Creates folders and Collections in System Center Configuration Manager
.DESCRIPTION
   Creates Configuration Item folders and Collections in System Center Configuration Manager
.EXAMPLE
   New-ConfigurationFolders
#>
function New-ConfigurationFolders {

    #Create Configuration Collections, Items, Baseline Folders
    New-Item -Name 'Configuration Items' -Path $($SiteCode.Name+":\DeviceCollection")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\DeviceCollection\Configuration Items")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\DeviceCollection\Configuration Items")
    New-Item -Name 'Configuration Items' -Path $($SiteCode.Name+":\ConfigurationItem")
    New-Item -Name 'CI - Workstation Collections' -Path  $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'Configuration Baselines' -Path $($SiteCode.Name+":\ConfigurationBaseline")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")

    New-Item -Name 'DISA STIGs' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\DISA STIGs")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\DISA STIGs")
    New-Item -Name 'GPOs' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'Active Directory OU' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CPU' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\CPU")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\CPU")
    New-Item -Name 'Installed Software' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Installed Software")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Installed Software")
    New-Item -Name 'IP Addresses' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'Logical Disks' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Logical Disks")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Logical Disks")
    New-Item -Name 'Memory' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Memory")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Memory")
    New-Item -Name 'Physical Drives' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Physical Drives")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Physical Drives")
    New-Item -Name 'Windows Services' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Windows Services")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Windows Services")
    New-Item -Name 'Windows Features' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Windows Features")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items\Windows Features")
    New-Item -Name 'Active Directory Groups' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'Active Directory Service Accounts' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'DNS Entries' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'Exchange Configuration' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'VMWare Configuration' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'Backup Configuration' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'Switches' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'Routers' -Path $($SiteCode.Name+":\ConfigurationItem\Configuration Items")

    New-Item -Name 'DISA STIGs' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\DISA STIGs")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\DISA STIGs")
    New-Item -Name 'GPOs' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'Active Directory OU' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CPU' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\CPU")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\CPU")
    New-Item -Name 'Installed Software' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Installed Software")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Installed Software")
    New-Item -Name 'IP Addresses' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'Logical Disks' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Logical Disks")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Logical Disks")
    New-Item -Name 'Memory' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Memory")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Memory")
    New-Item -Name 'Physical Drives' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Physical Drives")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Physical Drives")
    New-Item -Name 'Windows Services' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Windows Services")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Windows Services")
    New-Item -Name 'Windows Features' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CI - Workstation Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Windows Features")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines\Windows Features")
    New-Item -Name 'Active Directory Groups' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'Active Directory Service Accounts' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'DNS Entries' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'Exchange Configuration' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'VMWare Configuration' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'Backup Configuration' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'Switches' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'Routers' -Path $($SiteCode.Name+":\ConfigurationBaseline\Configuration Baselines")

    #Create Collections
    #List of Collections Query
    $Collection1 = @{Name = "CI - All Windows 10 Clients"; Query = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Workstation 10.0%' and SMS_R_System.Client = '1'"}
    $Collection2 = @{Name = "CI - All Server 2016 Clients"; Query = "select SMS_R_System.ResourceId, SMS_R_System.ResourceType, SMS_R_System.Name, SMS_R_System.SMSUniqueIdentifier, SMS_R_System.ResourceDomainORWorkgroup, SMS_R_System.Client from  SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_R_System.OperatingSystemNameandVersion like '%Server 10.0%' and SMS_G_System_OPERATING_SYSTEM.Caption like '%Server 2016%' and SMS_R_System.Client = '1'"}
    $Collection3 = @{Name = "CI - All Server 2019 Clients"; Query = "select SMS_R_System.ResourceId, SMS_R_System.ResourceType, SMS_R_System.Name, SMS_R_System.SMSUniqueIdentifier, SMS_R_System.ResourceDomainORWorkgroup, SMS_R_System.Client from  SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_R_System.OperatingSystemNameandVersion like '%Server 10.0%' and SMS_G_System_OPERATING_SYSTEM.Caption like '%Server 2019%' and SMS_R_System.Client = '1'"}

    #Define possible limiting collections
    $LimitingCollectionAll = "All Systems"
    #$LimitingCollectionAllWork = "All Workstations"
    #$LimitingCollectionAllWorkAdmin = "All Workstations - Admin"
    #$LimitingCollectionAllServer = "All Servers"

    #Refresh Schedule
    $Schedule = New-CMSchedule –RecurInterval Days –RecurCount 2

    #Create Collection
    #try{
    New-CMDeviceCollection -Name $Collection1.Name -Comment "CI - All Windows 10 Clients" -LimitingCollectionName $LimitingCollectionAll -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
    Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection1.Name -QueryExpression $Collection1.Query -RuleName $Collection1.Name
    Write-host *** Collection $Collection1.Name created ***

    New-CMDeviceCollection -Name $Collection2.Name -Comment "CI - All Server 2016 Clients" -LimitingCollectionName $LimitingCollectionAll -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
    Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection2.Name -QueryExpression $Collection2.Query -RuleName $Collection2.Name
    Write-host *** Collection $Collection2.Name created ***

    New-CMDeviceCollection -Name $Collection3.Name -Comment "CI - All Server 2019 Clients" -LimitingCollectionName $LimitingCollectionAll -RefreshSchedule $Schedule -RefreshType 2 | Out-Null
    Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Collection3.Name -QueryExpression $Collection3.Query -RuleName $Collection3.Name
    Write-host *** Collection $Collection3.Name created ***

    #Move the collections to the right folder
    #CI - Workstation Collections
    $FolderPath = $SiteCode.Name+":\DeviceCollection\Configuration Items\CI - Workstation Collections"
    Move-CMObject -FolderPath $FolderPath -InputObject (Get-CMDeviceCollection -Name $Collection1.Name)

    #CI - Server Collections
    $FolderPath = $SiteCode.Name+":\DeviceCollection\Configuration Items\CI - Server Collections"
    Move-CMObject -FolderPath $FolderPath -InputObject (Get-CMDeviceCollection -Name $Collection2.Name)
    Move-CMObject -FolderPath $FolderPath -InputObject (Get-CMDeviceCollection -Name $Collection3.Name)
}