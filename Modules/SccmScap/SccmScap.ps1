#Import Configuration Manager Module
Import-SCCMPoSHModule

#Storing variables
#Windows 10 SCAP xml & Stig xccdf
$windows10Scap = 'C:\Temp\U_MS_Windows_10_V1R15_STIG_SCAP_1-2_Benchmark\U_MS_Windows_10_V1R15_STIG_SCAP_1-2_Benchmark.xml'
$windows10Stig = 'scap_mil.disa.stig_datastream_U_MS_Windows_10_V1R15_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_10_STIG'

#Server 2016 SCAP xml & Stig xccdf
$server2016Scap = 'C:\Temp\U_MS_Windows_Server_2016_V1R10_STIG_SCAP_1-2_Benchmark\U_MS_Windows_Server_2016_V1R10_STIG_SCAP_1-2_Benchmark.xml'
$server2016Stig = 'scap_mil.disa.stig_datastream_U_MS_Windows_Server_2016_V1R10_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_Server_2016_STIG'

#Sever 2019 SCAP xml & Stig xccdf
$server2019Scap = 'C:\Temp\U_MS_Windows_Server_2019_V1R10_STIG_SCAP_1-2_Benchmark\U_MS_Windows_Server_2019_V1R10_STIG_SCAP_1-2_Benchmark.xml'
$server2019Stig = 'scap_mil.disa.stig_datastream_U_MS_Windows_Server_2019_V1R10_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_Server_2019_STIG'

#Folder Path
$deviceCollectionPath = $SiteCode.Name+":\DeviceCollection"
$configurationItemPath = $SiteCode.Name+":\ConfigurationItem"
$configurationBaselinePath = $SiteCode.Name+":\ConfigurationBaseline"

#Folder Name
$configurationCollectionFolder = 'Configuration Collections'
$configurationItemFolder = 'Configuration Items'
$configurationBaselineFolder = 'Configuration Baselines'
$disaStigItemsFolder = 'Disa Stig Items'
$windows10Folder = 'CI - Windows 10'
$server2016Folder ='CI - Server 2016'
$server2019Folder ='CI - Server 2019'
$cat1 = 'CAT1'
$classified = 'Classified'
$public = 'Public'
$sensitive = 'Sensitive'
$slowRules = 'SlowRules'

#Configuration item catagory path
$disaStigItemsPath = "$configurationItemPath\$configurationItemFolder\$disaStigItemsFolder"
#$CIServer2016Path = "$configurationItemPath\$configurationItemFolder\$server2016Folder"
#$CIServer2019Path = "$configurationItemPath\$configurationItemFolder\$server2019Folder"

#Configuration baseline catagory path
$CBWin10Path = "$configurationBaselinePath\$configurationBaselineFolder\$windows10Folder"
$CBServer2016Path = "$configurationBaselinePath\$configurationBaselineFolder\$server2016Folder"
$CBServer2019Path = "$configurationBaselinePath\$configurationBaselineFolder\$server2019Folder"

#Configuration Collections
$win10CollectionName = "CI - All Windows 10 Clients"
$server2016CollectionName = "CI - All Server 2016 Clients"
$server2019CollectionName = "CI - All Server 2019 Clients"
$limitingCollectionName = 'All Systems'
$win10QueryExpression = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Workstation 10.0%' and SMS_R_System.Client = '1'"
$server2016QueryExpression = "select SMS_R_System.ResourceId, SMS_R_System.ResourceType, SMS_R_System.Name, SMS_R_System.SMSUniqueIdentifier, SMS_R_System.ResourceDomainORWorkgroup, SMS_R_System.Client from  SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_R_System.OperatingSystemNameandVersion like '%Server 10.0%' and SMS_G_System_OPERATING_SYSTEM.Caption like '%Server 2016%' and SMS_R_System.Client = '1'"
$server2019QueryExpression = "select SMS_R_System.ResourceId, SMS_R_System.ResourceType, SMS_R_System.Name, SMS_R_System.SMSUniqueIdentifier, SMS_R_System.ResourceDomainORWorkgroup, SMS_R_System.Client from  SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_R_System.OperatingSystemNameandVersion like '%Server 10.0%' and SMS_G_System_OPERATING_SYSTEM.Caption like '%Server 2019%' and SMS_R_System.Client = '1'"
$win10RuleName = $win10CollectionName
$win10Comment = $win10CollectionName
$server2016RuleName = $server2016CollectionName
$server2016Comment = $server2016CollectionName
$server2019RuleName = $server2019CollectionName
$server2019Comment = $server2019CollectionName

#Location for SCAP CAB Benchmarks
$scapImportFolder = 'C:\temp\SCAP2Convert'
$win10ImportFolder = 'C:\temp\SCAP2Convert\Windows10'
$server2016ImportFolder = 'C:\temp\SCAP2Convert\Server2016'
$server2019ImportFolder = 'C:\temp\SCAP2Convert\Server2019'

#Location for Log files
$logs = 'C:\Temp\SCAP2DCM_Logs'

#Disa Stig Profile
$stigProfileCat1 = 'xccdf_mil.disa.stig_profile_CAT_I_Only'
$stigProfileSlowRules = 'xccdf_mil.disa.stig_profile_Disable_Slow_Rules'
$stigProfileMac3Classified = 'xccdf_mil.disa.stig_profile_MAC-3_Classified'
$stigProfileMac3Sensitive = 'xccdf_mil.disa.stig_profile_MAC-3_Sensitive'
$stigProfileMac3Public = 'xccdf_mil.disa.stig_profile_MAC-3_Public'
$stigProfileMac2Classified = 'xccdf_mil.disa.stig_profile_MAC-2_Classified'
$stigProfileMac2Sensitive = 'xccdf_mil.disa.stig_profile_MAC-2_Sensitive'
$stigProfileMac2Public = 'xccdf_mil.disa.stig_profile_MAC-2_Public'
$stigProfileMac1Classified = 'xccdf_mil.disa.stig_profile_MAC-1_Classified'
$stigProfileMac1Sensitive = 'xccdf_mil.disa.stig_profile_MAC-1_Sensitive'
$stigProfileMac1Public = 'xccdf_mil.disa.stig_profile_MAC-1_Public'

#Stig configuration items and baselines data
$stigConfigurationItems = 'oval.mil.disa*'
$win10Baselines = 'Windows 10*'
$server2016Baselines = 'Windows Server 2016*'
$server2019Baselines = 'Windows Server 2019*'

#Configuration InputObjects
$CIInputObjects = (Get-CMConfigurationItem -Name $stigConfigurationItems -Fast)
$win10CBInputObjects = (Get-CMBaseline -Name $win10Baselines)
$server2016CBInputObjects = (Get-CMBaseline -Name $server2016Baselines)
$server2019CBInputObjects = (Get-CMBaseline -Name $server2019Baselines)
$win10CollectionInputObjects = (Get-CMCollection -Name $win10CollectionName)
$server2016CollectionInputObjects = (Get-CMCollection -Name $server2016CollectionName)
$server2019CollectionInputObjects = (Get-CMCollection -Name $server2019CollectionName)

#Deployment postpone date & time
[int]$postponeDateTime = 2020/03/01


#Start Workflow Process
#Convert Windows 10 Scap Benchmarks to Cabs
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$cat1" -Select "$windows10Stig/$stigProfileCat1" -LogFile "$logs\Windows10_CAT_I_Only.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$slowRules" -Select "$windows10Stig/$stigProfileSlowRules" -LogFile "$logs\Windows10_Disable_Slow_Rules.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$classified" -Select "$windows10Stig/$stigProfileMac3Classified" -LogFile "$logs\Windows10_MAC-3_Classified.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$sensitive" -Select "$windows10Stig/$stigProfileMac3Sensitive" -LogFile "$logs\Windows10_MAC-3_Sensitive.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$public" -Select "$windows10Stig/$stigProfileMac3Public" -LogFile "$logs\Windows10_MAC-3_Public.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$classified" -Select "$windows10Stig/$stigProfileMac2Classified" -LogFile "$logs\Windows10_MAC-2_Classified.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$sensitive" -Select "$windows10Stig/$stigProfileMac2Sensitive" -LogFile "$logs\Windows10_MAC-2_Sensitive.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$public" -Select "$windows10Stig/$stigProfileMac2Public" -LogFile "$logs\Windows10_MAC-2_Public.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$classified" -Select "$windows10Stig/$stigProfileMac1Classified" -LogFile "$logs\Windows10_MAC-1_Classified.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$sensitive" -Select "$windows10Stig/$stigProfileMac1Sensitive" -LogFile "$logs\Windows10_MAC-1_Sensitive.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$win10ImportFolder\$public" -Select "$windows10Stig/$stigProfileMac1Public" -LogFile "$logs\Windows10_MAC-1_Public.log"

#Convert Server 2016 Scap Benchmarks to Cabs
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$cat1" -Select "$server2016Stig/$stigProfileCat1" -LogFile "$logs\Server2016_CAT_I_Only.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$slowRules" -Select "$server2016Stig/$stigProfileSlowRules" -LogFile "$logs\Server2016_Disable_Slow_Rules.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$classified" -Select "$server2016Stig/$stigProfileMac3Classified" -LogFile "$logs\Server2016_MAC-3_Classified.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$sensitive" -Select "$server2016Stig/$stigProfileMac3Sensitive" -LogFile "$logs\Server2016_MAC-3_Sensitive.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$public" -Select "$server2016Stig/$stigProfileMac3Public" -LogFile "$logs\Server2016_MAC-3_Public.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$classified" -Select "$server2016Stig/$stigProfileMac2Classified" -LogFile "$logs\Server2016_MAC-2_Classified.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$sensitive" -Select "$server2016Stig/$stigProfileMac2Sensitive" -LogFile "$logs\Server2016_MAC-2_Sensitive.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$public" -Select "$server2016Stig/$stigProfileMac2Public" -LogFile "$logs\Server2016_MAC-2_Public.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$classified" -Select "$server2016Stig/$stigProfileMac1Classified" -LogFile "$logs\Server2016_MAC-1_Classified.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$sensitive" -Select "$server2016Stig/$stigProfileMac1Sensitive" -LogFile "$logs\Server2016_MAC-1_Sensitive.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016ImportFolder\$public" -Select "$server2016Stig/$stigProfileMac1Public" -LogFile "$logs\Server2016_MAC-1_Public.log"

#Convert Server 2019 Scap Benchmarks to Cabs
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$cat1" -Select "$server2019Stig/$stigProfileCat1" -LogFile "$logs\Server2019_CAT_I_Only.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$slowRules" -Select "$server2019Stig/$stigProfileSlowRules" -LogFile "$logs\Server2019_Disable_Slow_Rules.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$classified" -Select "$server2019Stig/$stigProfileMac3Classified" -LogFile "$logs\Server2019_MAC-3_Classified.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$sensitive" -Select "$server2019Stig/$stigProfileMac3Sensitive" -LogFile "$logs\Server2019_MAC-3_Sensitive.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$public" -Select "$server2019Stig/$stigProfileMac3Public" -LogFile "$logs\Server2019_MAC-3_Public.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$classified" -Select "$server2019Stig/$stigProfileMac2Classified" -LogFile "$logs\Server2019_MAC-2_Classified.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$sensitive" -Select "$server2019Stig/$stigProfileMac2Sensitive" -LogFile "$logs\Server2019_MAC-2_Sensitive.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$public" -Select "$server2019Stig/$stigProfileMac2Public" -LogFile "$logs\Server2019_MAC-2_Public.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$classified" -Select "$server2019Stig/$stigProfileMac1Classified" -LogFile "$logs\Server2019_MAC-1_Classified.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$sensitive" -Select "$server2019Stig/$stigProfileMac1Sensitive" -LogFile "$logs\Server2019_MAC-1_Sensitive.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019ImportFolder\$public" -Select "$server2019Stig/$stigProfileMac1Public" -LogFile "$logs\Server2019_MAC-1_Public.log"

#Create Configuration Collection Folders
New-ConfigurationFolder -Name $configurationCollectionFolder -Path $deviceCollectionPath
New-ConfigurationFolder -Name $windows10Folder -Path "$deviceCollectionPath\$configurationCollectionFolder"
New-ConfigurationFolder -Name $server2016Folder -Path "$deviceCollectionPath\$configurationCollectionFolder"
New-ConfigurationFolder -Name $server2019Folder -Path "$deviceCollectionPath\$configurationCollectionFolder"

#Create Configuration Collections
New-ConfigurationCollection -CollectionName $win10CollectionName -Comment $win10Comment -LimitingCollectionName $limitingCollectionName -QueryExpression $win10QueryExpression -RuleName $win10RuleName
New-ConfigurationCollection -CollectionName $server2016CollectionName -Comment $server2016Comment -LimitingCollectionName $limitingCollectionName -QueryExpression $server2016QueryExpression -RuleName $server2016RuleName
New-ConfigurationCollection -CollectionName $server2019CollectionName -Comment $server2019Comment -LimitingCollectionName $limitingCollectionName -QueryExpression $server2019QueryExpression -RuleName $server2019RuleName

#Move Configuration Collections
Move-ConfigurationCollection -Name $win10CollectionName -FolderPath "$deviceCollectionPath\$configurationCollectionFolder\$windows10Folder" -InputObject $win10CollectionInputObjects
Move-ConfigurationCollection -Name $server2016CollectionName -FolderPath "$deviceCollectionPath\$configurationCollectionFolder\$server2016Folder" -InputObject $server2016CollectionInputObjects
Move-ConfigurationCollection -Name $server2019CollectionName -FolderPath "$deviceCollectionPath\$configurationCollectionFolder\$server2019Folder" -InputObject $server2019CollectionInputObjects

#Create Configuration Item Folders
New-ConfigurationFolder -Name $configurationItemFolder -Path $configurationItemPath
New-ConfigurationFolder -Name $disaStigItemsFolder -Path "$configurationItemPath\$configurationItemFolder"

#Create Configuration Baseline Folders
New-ConfigurationFolder -Name $configurationBaselineFolder -Path $configurationBaselinePath
New-ConfigurationFolder -Name $windows10Folder -Path "$configurationBaselinePath\$configurationBaselineFolder"
New-ConfigurationFolder -Name $server2016Folder -Path "$configurationBaselinePath\$configurationBaselineFolder"
New-ConfigurationFolder -Name $server2019Folder -Path "$configurationBaselinePath\$configurationBaselineFolder"


#Import Scap Baseline
#Import and move stig data in SCCM
Import-SCAPBaseline -Path $scapImportFolder
Move-ConfigurationItem -Name $stigConfigurationItems -FolderPath $disaStigItemsPath -InputObject $CIInputObjects

#Move Configuration Baselines and deploy
Move-ConfigurationBaseline -Name $win10Baselines -FolderPath $CBWin10Path -InputObject $win10CBInputObjects
New-ConfigurationDeployment -Name $win10Baselines -CollectionName $win10CollectionName -PostponeDateTime $postponeDateTime
Move-ConfigurationBaseline -Name $server2016Baselines -FolderPath $CBServer2016Path -InputObject $server2016CBInputObjects
New-ConfigurationDeployment -Name $server2016Baselines -CollectionName $server2016CollectionName -PostponeDateTime $postponeDateTime
Move-ConfigurationBaseline -Name $server2019Baselines -FolderPath $CBServer2019Path -InputObject $server2019CBInputObjects
New-ConfigurationDeployment -Name $server2019Baselines -CollectionName $server2019CollectionName -PostponeDateTime $postponeDateTime

#Create Configuration Subscriptions

#path to reports
$rsItem1 = '/ConfigMgr_PS1/Compliance and Settings Management/Summary compliance by configuration baseline'
$rsitem2 = '/ConfigMgr_PS1/Compliance and Settings Management/Summary compliance of a configuration baseline for a collection'

#report parameter values
$values = @{
    name = 'Windows 10 Security Technical Implementation Guide[CAT I Only]'
    collid = 'PS100023'
}

$fileSharePath = 'c:\temp\CMReports'
$fileName = 'MyReport'
$description = 'Daily to folder'
$csvFormat = 'CSV'
$fileShare = 'FileShare'

#create new fileshare subscription
New-RsSubscription -RsItem $rsitem2 -Description $description -RenderFormat $csvFormat -Schedule (New-RsScheduleXML -Daily 1) -DeliveryMethod $fileShare -FileSharePath $fileSharePath -FileName $fileName -FileWriteMode Overwrite -Parameters $values
