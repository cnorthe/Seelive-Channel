function Install-MSIFile {

    [CmdletBinding()]
    Param(
        [parameter(mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateNotNullorEmpty()]
        [string]$msiFile,

        [parameter()]
        [ValidateNotNullorEmpty()]
        [string]$targetDir
    )
    if (!(Test-Path $msiFile)) {
        throw "Path to the MSI File $($msiFile) is invalid. Please supply a valid MSI file"
    }
    $arguments = @(
        "/i"
        "`"$msiFile`""
        "/qn"
        "/norestart"
    )
    if ($targetDir) {
        if (!(Test-Path $targetDir)) {
            throw "Path to the Installation Directory $($targetDir) is invalid. Please supply a valid installation directory"
        }
        $arguments += "INSTALLDIR=`"$targetDir`""
    }
    Write-Verbose "Installing $msiFile....."
    $process = Start-Process -FilePath msiexec.exe -ArgumentList $arguments -Wait -PassThru
    if ($process.ExitCode -eq 0) {
        Write-Verbose "$msiFile has been successfully installed"
    }
    else {
        Write-Verbose "installer exit code  $($process.ExitCode) for file  $($msifile)"
    }
}
'C:\Temp\ConfigMgrSCAPExtension\ConfigMgrExtensionsForSCAP.msi' | Install-MSIFile -Verbose

function Uninstall-MSIFile {

    [CmdletBinding()]
    Param(
        [parameter(mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [ValidateNotNullorEmpty()]
        [string]$msiFile
    )
    if (!(Test-Path $msiFile)) {
        throw "Path to the MSI File $($msiFile) is invalid. Please supply a valid MSI file"
    }
    $arguments = @(
        "/x"
        "`"$msiFile`""
        "/qn"
        "/norestart"
    )
    Write-Verbose "Uninstalling $msiFile....."
    $process = Start-Process -FilePath msiexec.exe -ArgumentList $arguments -Wait -PassThru
    if ($process.ExitCode -eq 0) {
        Write-Verbose "$msiFile has been successfully uninstalled"
    }
    else {
        Write-Error "installer exit code  $($process.ExitCode) for file  $($msifile)"
    }
}
'C:\Temp\ConfigMgrSCAPExtension\ConfigMgrExtensionsForSCAP.msi' | Uninstall-MSIFile -Verbose

function Convert-Scap2Cab
 {
    param
    (
        [Parameter()]
        [String]
        $ScapToDcmPath = 'F:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\Microsoft.Sces.ScapToDcm.exe',
        [Parameter(Mandatory = $true)]
        [String]
        $ScapXml,
        [Parameter(Mandatory = $true)]
        [String]
        $OutputFile,
        [Parameter(Mandatory = $true)]
        [String]
        $Select,
        [Parameter()]
        [String]
        $MaxCi = 500,
        [Parameter(Mandatory = $true)]
        [String]
        $LogFile
    )
    & $ScapToDcmPath -Scap $ScapXml -Out $OutPutFile -Select $Select -MaxCi $MaxCi -Log $LogFile
 }

#Windows 10 SCAP xml & Stig xccdf
$windows10Scap = 'C:\Temp\U_MS_Windows_10_V1R15_STIG_SCAP_1-2_Benchmark\U_MS_Windows_10_V1R15_STIG_SCAP_1-2_Benchmark.xml'
$windows10Stig = 'scap_mil.disa.stig_datastream_U_MS_Windows_10_V1R15_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_10_STIG'

#Server 2016 SCAP xml & Stig xccdf
$server2016Scap = 'C:\Temp\U_MS_Windows_Server_2016_V1R10_STIG_SCAP_1-2_Benchmark\U_MS_Windows_Server_2016_V1R10_STIG_SCAP_1-2_Benchmark.xml'
$server2016Stig = 'scap_mil.disa.stig_datastream_U_MS_Windows_Server_2016_V1R10_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_Server_2016_STIG'

#Sever 2019 SCAP xml & Stig xccdf
$server2019Scap = 'C:\Temp\U_MS_Windows_Server_2019_V1R10_STIG_SCAP_1-2_Benchmark\U_MS_Windows_Server_2019_V1R10_STIG_SCAP_1-2_Benchmark.xml'
$server2019Stig = 'scap_mil.disa.stig_datastream_U_MS_Windows_Server_2019_V1R10_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_Server_2019_STIG'

#Windows 10 Scap2Cab
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\CAT1' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_CAT_I_Only" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_CAT_I_Only.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\SlowRules' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_Disable_Slow_Rules" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_Disable_Slow_Rules.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\Classified' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-3_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_MAC-3_Classified.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\Sensitive' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-3_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_MAC-3_Sensitive.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\Public' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-3_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_MAC-3_Public.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\Classified' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-2_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_MAC-2_Classified.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\Sensitive' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-2_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_MAC-2_Sensitive.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\Public' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-2_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_MAC-2_Public.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\Classified' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-1_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_MAC-1_Classified.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\Sensitive' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-1_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_MAC-1_Sensitive.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\WIN10\Public' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-1_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Win10_MAC-1_Public.log'

#Server2016 Scap2Cab
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\CAT1' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_CAT_I_Only" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_CAT_I_Only.log'
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\SlowRules' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_Disable_Slow_Rules" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_Disable_Slow_Rules.log'
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\Classified' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-3_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_MAC-3_Classified.log'
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\Sensitive' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-3_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_MAC-3_Sensitive.log'
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\Public' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-3_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_MAC-3_Public.log'
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\Classified' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-2_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_MAC-2_Classified.log'
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\Sensitive' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-2_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_MAC-2_Sensitive.log'
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\Public' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-2_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_MAC-2_Public.log'
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\Classified' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-1_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_MAC-1_Classified.log'
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\Sensitive' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-1_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_MAC-1_Sensitive.log'
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2016\Public' -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-1_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2016_MAC-1_Public.log'

#Sever2019 Scap2Cab
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\CAT1' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_CAT_I_Only" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_CAT_I_Only.log'
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\SlowRules' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_Disable_Slow_Rules" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_Disable_Slow_Rules.log'
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\Classified' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-3_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_MAC-3_Classified.log'
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\Sensitive' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-3_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_MAC-3_Sensitive.log'
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\Public' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-3_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_MAC-3_Public.log'
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\Classified' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-2_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_MAC-2_Classified.log'
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\Sensitive' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-2_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_MAC-2_Sensitive.log'
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\Public' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-2_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_MAC-2_Public.log'
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\Classified' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-1_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_MAC-1_Classified.log'
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\Sensitive' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-1_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_MAC-1_Sensitive.log'
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile 'C:\Temp\SCAP2Convert\Server2019\Public' -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-1_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Server2019_MAC-1_Public.log'

function New-SCAPFoldersAndCollections {

    #Load Configuration Manager PowerShell Module
    Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

    #Get SiteCode
    $SiteCode = Get-PSDrive -PSProvider CMSITE
    Set-location $SiteCode":"

    #Create Configuration Settings, Configuration Item, and Configuration Baseline Folders
    New-Item -NAme 'Compliance Settings' -Path $($SiteCode.Name+":\DeviceCollection")
    New-Item -NAme 'CS - Workstation Collections' -Path $($SiteCode.name+":\DeviceCollection\Compliance Settings")
    New-Item -NAme 'CS - Server Collections' -Path $($SiteCode.name+":\DeviceCollection\Compliance Settings")
    New-Item -Name 'Configuration Items' -Path $($SiteCode.Name+":\ConfigurationItem")
    New-Item -Name 'CI - Workstation Collections' -Path  $($SiteCode.name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'CI - Server Collections' -Path $($SiteCode.name+":\ConfigurationItem\Configuration Items")
    New-Item -Name 'Configuration Baselines' -Path $($SiteCode.Name+":\ConfigurationBaseline")
    New-Item -Name 'CB - Workstation Collections' -Path $($SiteCode.name+":\ConfigurationBaseline\Configuration Baselines")
    New-Item -Name 'CB - Server Collections' -Path $($SiteCode.name+":\ConfigurationBaseline\Configuration Baselines")

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

}

