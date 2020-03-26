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
$windows10Folder = 'CI - Windows 10'
$server2016Folder ='CI - Server 2016'
$server2019Folder ='CI - Server 2019'
$cat1 = 'CAT1'
$classified = 'Classified'
$public = 'Public'
$sensitive = 'Sensitive'
$slowRules = 'SlowRules'

#Configuration item catagory path
$CIWin10Path = "$configurationItemPath\$configurationItemFolder\$windows10Folder"
$CIServer2016Path = "$configurationItemPath\$configurationItemFolder\$server2016Folder"
$CIServer2019Path = "$configurationItemPath\$configurationItemFolder\$server2019Folder"

#Configuration baseline catagory path
$CBWin10Path = "$configurationBaselinePath\$configurationBaselineFolder\$windows10Folder"
$CBServer2016Path = "$configurationBaselinePath\$configurationBaselineFolder\$server2016Folder"
$CBServer2019Path = "$configurationBaselinePath\$configurationBaselineFolder\$server2019Folder"

#Configuration Collections
$win10collectionName = "CI - All Windows 10 Clients"
$server2016collectionName = "CI - All Server 2016 Clients"
$server2019collectionName = "CI - All Server 2019 Clients"
$win10queryExpression = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Workstation 10.0%' and SMS_R_System.Client = '1'"
$server2016queryExpression = "select SMS_R_System.ResourceId, SMS_R_System.ResourceType, SMS_R_System.Name, SMS_R_System.SMSUniqueIdentifier, SMS_R_System.ResourceDomainORWorkgroup, SMS_R_System.Client from  SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_R_System.OperatingSystemNameandVersion like '%Server 10.0%' and SMS_G_System_OPERATING_SYSTEM.Caption like '%Server 2016%' and SMS_R_System.Client = '1'"
$server2019queryExpression = "select SMS_R_System.ResourceId, SMS_R_System.ResourceType, SMS_R_System.Name, SMS_R_System.SMSUniqueIdentifier, SMS_R_System.ResourceDomainORWorkgroup, SMS_R_System.Client from  SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_R_System.OperatingSystemNameandVersion like '%Server 10.0%' and SMS_G_System_OPERATING_SYSTEM.Caption like '%Server 2019%' and SMS_R_System.Client = '1'"
$win10ruleName = $win10collectionName
$win10comment = $win10collectionName
$server2016ruleName = $server2016collectionName
$server2016comment = $server2016collectionName
$server2019ruleName = $server2019collectionName
$server2019comment = $server2019collectionName

#Location for SCAP CAB Benchmarks
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
$server2016Baseline = 'Windows Server 2016*'
$server2019Baseline = 'Windows Server 2019*'

#Configuration InputObjects
$CIInputObjects = (Get-CMConfigurationItem -Name $stigConfigurationItems -Fast)
$win10CBInputObjects = (Get-CMBaseline -Name $win10Baselines)
$server2016CBInputObjects = (Get-CMBaseline -Name $server2016Baseline)
$server2019CBInputObjects = (Get-CMBaseline -Name $server2019Baseline)
$win10CollectionInputObjects = (Get-CMCollection -Name $win10collectionName)
$server2016CollectionInputObjects = (Get-CMCollection -Name $server2016collectionName)
$server2019CollectionInputObjects = (Get-CMCollection -Name $server2019collectionName)


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

#Create Configuration Item Folders
New-ConfigurationFolder -Name $configurationItemFolder -Path $configurationItemPath
New-ConfigurationFolder -Name $windows10Folder -Path "$configurationItemPath\$configurationItemFolder"
New-ConfigurationFolder -Name $server2016Folder -Path "$configurationItemPath\$configurationItemFolder"
New-ConfigurationFolder -Name $server2019Folder -Path "$configurationItemPath\$configurationItemFolder"

#Create Configuration Baseline Folders
New-ConfigurationFolder -Name $configurationBaselineFolder -Path $configurationBaselinePath
New-ConfigurationFolder -Name $windows10Folder -Path "$configurationBaselinePath\$configurationBaselineFolder"
New-ConfigurationFolder -Name $server2016Folder -Path "$configurationBaselinePath\$configurationBaselineFolder"
New-ConfigurationFolder -Name $server2019Folder -Path "$configurationBaselinePath\$configurationBaselineFolder"

#Create Disa Classification Folders
New-ConfigurationFolder -Name $cat1 -Path $CIWin10Path
New-ConfigurationFolder -Name $classified -Path $CIWin10Path
New-ConfigurationFolder -Name $public -Path $CIWin10Path
New-ConfigurationFolder -Name $sensitive -Path $CIWin10Path
New-ConfigurationFolder -Name $slowRules -Path $CIWin10Path

New-ConfigurationFolder -Name $cat1 -Path $CIServer2016Path
New-ConfigurationFolder -Name $classified -Path $CIServer2016Path
New-ConfigurationFolder -Name $public -Path $CIServer2016Path
New-ConfigurationFolder -Name $sensitive -Path $CIServer2016Path
New-ConfigurationFolder -Name $slowRules -Path $CIServer2016Path

New-ConfigurationFolder -Name $cat1 -Path $CIServer2019Path
New-ConfigurationFolder -Name $classified -Path $CIServer2019Path
New-ConfigurationFolder -Name $public -Path $CIServer2019Path
New-ConfigurationFolder -Name $sensitive -Path $CIServer2019Path
New-ConfigurationFolder -Name $slowRules -Path $CIServer2019Path

New-ConfigurationFolder -Name $cat1 -Path $CBWin10Path
New-ConfigurationFolder -Name $classified -Path $CBWin10Path
New-ConfigurationFolder -Name $public -Path $CBWin10Path
New-ConfigurationFolder -Name $sensitive -Path $CBWin10Path
New-ConfigurationFolder -Name $slowRules -Path $CBWin10Path

New-ConfigurationFolder -Name $cat1 -Path $CBServer2016Path
New-ConfigurationFolder -Name $classified -Path $CBServer2016Path
New-ConfigurationFolder -Name $public -Path $CBServer2016Path
New-ConfigurationFolder -Name $sensitive -Path $CBServer2016Path
New-ConfigurationFolder -Name $slowRules -Path $CBServer2016Path

New-ConfigurationFolder -Name $cat1 -Path $CBServer2019Path
New-ConfigurationFolder -Name $classified -Path $CBServer2019Path
New-ConfigurationFolder -Name $public -Path $CBServer2019Path
New-ConfigurationFolder -Name $sensitive -Path $CBServer2019Path
New-ConfigurationFolder -Name $slowRules -Path $CBServer2019Path

#Create Configuration Collections
New-ConfigurationCollection -CollectionName $win10collectionName -Comment $win10comment -LimitingCollectionName 'All Systems' -QueryExpression $win10queryExpression -RuleName $win10ruleName
New-ConfigurationCollection -CollectionName $server2016collectionName -Comment $server2016comment -LimitingCollectionName 'All Systems' -QueryExpression $server2016queryExpression -RuleName $server2016ruleName
New-ConfigurationCollection -CollectionName $server2019collectionName -Comment $server2019comment -LimitingCollectionName 'All Systems' -QueryExpression $server2019queryExpression -RuleName $server2019ruleName

#Move Configuration Collections
Move-ConfigurationCollection -Name $win10collectionName -FolderPath "$deviceCollectionPath\$configurationCollectionFolder\$windows10Folder" -InputObject $win10CollectionInputObjects
Move-ConfigurationCollection -Name $server2016collectionName -FolderPath "$deviceCollectionPath\$configurationCollectionFolder\$server2016Folder" -InputObject $server2016CollectionInputObjects
Move-ConfigurationCollection -Name $server2019collectionName -FolderPath "$deviceCollectionPath\$configurationCollectionFolder\$server2019Folder" -InputObject $server2019CollectionInputObjects


#Import Scap Baseline
#Process and deploy Windows 10 CAT1 stig data
Import-SCAPBaseline -Path "$win10ImportFolder\$cat1"
Move-ConfigurationItem -Name $stigConfigurationItems -FolderPath "$CIWin10Path\$cat1" -InputObject $CIInputObjects
Move-ConfigurationBaseline -Name $win10Baselines -FolderPath "$CBWin10Path\$cat1"-InputObject $win10CBInputObjects

    foreach ($win10Baseline in $win10Baselines)
    {
        New-ConfigurationDeployment -BaselineName $win10Baseline.LocalizedDisplayName -CollectionName $win10collectionName -ParameterValue 90 -PostponeDateTime 2019/03/01    
        Write-Verbose -Verbose "Creating $($win10Baseline.LocalizedDisplayName) Baseline Deployment."
    }
