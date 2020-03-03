function Install-MSIFile 
{

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

function Uninstall-MSIFile
{

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


<#
.Synopsis
   Converts Security Content Automation Protocol (SCAP) content to (DCM) .cab extenstion.
.DESCRIPTION
   SCCM extensions for SCAP converts Security Content Automation Protocol (SCAP) content for use by desired configuration
   management (DCM) and DCM reports into SCAP reporting format.
.EXAMPLE
   Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\CAT1" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_CAT_I_Only" -LogFile "$logFolder\SCAP2DCM_Windows10_CAT_I_Only.log"
#>
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

<#
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
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\CAT1' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_CAT_I_Only" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_CAT_I_Only.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\SlowRules' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_Disable_Slow_Rules" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_Disable_Slow_Rules.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\Classified' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-3_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_MAC-3_Classified.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\Sensitive' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-3_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_MAC-3_Sensitive.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\Public' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-3_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_MAC-3_Public.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\Classified' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-2_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_MAC-2_Classified.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\Sensitive' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-2_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_MAC-2_Sensitive.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\Public' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-2_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_MAC-2_Public.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\Classified' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-1_Classified" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_MAC-1_Classified.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\Sensitive' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-1_Sensitive" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_MAC-1_Sensitive.log'
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile 'C:\Temp\SCAP2Convert\Windows10\Public' -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-1_Public" -LogFile 'C:\Temp\SCAP2DCM_Logs\SCAP2DCM_Windows10_MAC-1_Public.log'

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
#>
function Import-SCCMPoSHModule
{
    #Load Configuration Manager PowerShell Module
    Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

    #Get SiteCode
    $SiteCode = Get-PSDrive -PSProvider CMSITE
    Set-location $SiteCode":"
}

<#
.Synopsis
   Creates folders and Collections in System Center Configuration Manager
.DESCRIPTION
   Creates Configuration Item folders and Collections in System Center Configuration Manager
.EXAMPLE
   New-ConfigurationFolders
#>
function New-ConfigurationFolders
{

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

<#
.Synopsis
   Import Scap configuration items and baselines in System Center Configuration Manager
.DESCRIPTION
   This function imports Scap configuration items and baselines in System Center
   Configuration Manager
.EXAMPLE
    $ImportFolder = 'C:\temp\SCAP2Convert'
    Import-SCAPBaseline -Path "$ImportFolder\Windows10"
    Import-SCAPBaseline -Path "$ImportFolder\Server2016"
    Import-SCAPBaseline -Path "$ImportFolder\Server2019"
#>
function Import-ScapBaseline
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    $files = Get-ChildItem -Path $Path -File -Recurse -Include *.Cab

    foreach ($file in $files)
    {
        Import-CMBaseline -FileName $file.FullName -Force
        Write-Verbose -Verbose "$($file.Name) SCAP Baselines and Configuration Items imported successfully."
    }
}

<#
#Location for SCAP CAB Benchmarks
$ImportFolder = 'C:\temp\SCAP2Convert'

Import-SCAPBaseline -Path "$ImportFolder\Windows10"
Import-SCAPBaseline -Path "$ImportFolder\Server2016"
Import-SCAPBaseline -Path "$ImportFolder\Server2019"
#>

