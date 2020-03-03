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
        $ScapToDcmPath = "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\Microsoft.Sces.ScapToDcm.exe",
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
$windows10Scap = "$ENV:SystemDrive\Temp\U_MS_Windows_10_V1R16_STIG_SCAP_1-2_Benchmark\U_MS_Windows_10_V1R16_STIG_SCAP_1-2_Benchmark.xml"
$windows10Stig = "scap_mil.disa.stig_datastream_U_MS_Windows_10_V1R16_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_10_STIG"

#Server 2016 SCAP xml & Stig xccdf
$server2016Scap = "$ENV:SystemDrive\Temp\U_MS_Windows_Server_2016_V1R12_STIG_SCAP_1-2_Benchmark\U_MS_Windows_Server_2016_V1R12_STIG_SCAP_1-2_Benchmark.xml"
$server2016Stig = "scap_mil.disa.stig_datastream_U_MS_Windows_Server_2016_V1R12_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_Server_2016_STIG"

#Sever 2019 SCAP xml & Stig xccdf
$server2019Scap = "$ENV:SystemDrive\Temp\U_MS_Windows_Server_2019_V1R2_STIG_SCAP_1-2_Benchmark\U_MS_Windows_Server_2019_V1R2_STIG_SCAP_1-2_Benchmark.xml"
$server2019Stig = "scap_mil.disa.stig_datastream_U_MS_Windows_Server_2019_V1R2_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_Server_2019_STIG"

#Os folder
$windows10Folder = "$ENV:SystemDrive\Temp\SCAP2Convert\Windows10"
$server2016Folder = "$ENV:SystemDrive\Temp\SCAP2Convert\Server2016"
$server2019Folder = "$ENV:SystemDrive\Temp\SCAP2Convert\Server2019"

#Log folder
$logFolder = "$ENV:SystemDrive\Temp\SCAP2DCM_Logs"

#Windows 10 Scap2Cab
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\CAT1" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_CAT_I_Only" -LogFile "$logFolder\SCAP2DCM_Windows10_CAT_I_Only.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\SlowRules" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_Disable_Slow_Rules" -LogFile "$logFolder\SCAP2DCM_Windows10_Disable_Slow_Rules.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\Classified" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-3_Classified" -LogFile "$logFolder\SCAP2DCM_Windows10_MAC-3_Classified.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\Sensitive" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-3_Sensitive" -LogFile "$logFolder\SCAP2DCM_Windows10_MAC-3_Sensitive.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\Public" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-3_Public" -LogFile "$logFolder\SCAP2DCM_Windows10_MAC-3_Public.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\Classified" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-2_Classified" -LogFile "$logFolder\SCAP2DCM_Windows10_MAC-2_Classified.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\Sensitive" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-2_Sensitive" -LogFile "$logFolder\SCAP2DCM_Windows10_MAC-2_Sensitive.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\Public" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-2_Public" -LogFile "$logFolder\SCAP2DCM_Windows10_MAC-2_Public.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\Classified" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-1_Classified" -LogFile "$logFolder\SCAP2DCM_Windows10_MAC-1_Classified.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\Sensitive" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-1_Sensitive" -LogFile "$logFolder\SCAP2DCM_Windows10_MAC-1_Sensitive.log"
Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\Public" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_MAC-1_Public" -LogFile "$logFolder\SCAP2DCM_Windows10_MAC-1_Public.log"

#Server2016 Scap2Cab
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\CAT1" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_CAT_I_Only" -LogFile "$logFolder\SCAP2DCM_Server2016_CAT_I_Only.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\SlowRules" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_Disable_Slow_Rules" -LogFile "$logFolder\SCAP2DCM_Server2016_Disable_Slow_Rules.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\Classified" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-3_Classified" -LogFile "$logFolder\SCAP2DCM_Server2016_MAC-3_Classified.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\Sensitive" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-3_Sensitive" -LogFile "$logFolder\SCAP2DCM_Server2016_MAC-3_Sensitive.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\Public" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-3_Public" -LogFile "$logFolder\SCAP2DCM_Server2016_MAC-3_Public.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\Classified" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-2_Classified" -LogFile "$logFolder\SCAP2DCM_Server2016_MAC-2_Classified.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\Sensitive" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-2_Sensitive" -LogFile "$logFolder\SCAP2DCM_Server2016_MAC-2_Sensitive.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\Public" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-2_Public" -LogFile "$logFolder\SCAP2DCM_Server2016_MAC-2_Public.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\Classified" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-1_Classified" -LogFile "$logFolder\SCAP2DCM_Server2016_MAC-1_Classified.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\Sensitive" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-1_Sensitive" -LogFile "$logFolder\SCAP2DCM_Server2016_MAC-1_Sensitive.log"
Convert-Scap2Cab  -ScapXml $Server2016Scap -OutputFile "$server2016Folder\Public" -Select "$server2016Stig/xccdf_mil.disa.stig_profile_MAC-1_Public" -LogFile "$logFolder\SCAP2DCM_Server2016_MAC-1_Public.log"

#Sever2019 Scap2Cab
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\CAT1" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_CAT_I_Only" -LogFile "$logFolder\SCAP2DCM_Server2019_CAT_I_Only.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\SlowRules" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_Disable_Slow_Rules" -LogFile "$logFolder\SCAP2DCM_Server2019_Disable_Slow_Rules.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\Classified" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-3_Classified" -LogFile "$logFolder\SCAP2DCM_Server2019_MAC-3_Classified.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\Sensitive" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-3_Sensitive" -LogFile "$logFolder\SCAP2DCM_Server2019_MAC-3_Sensitive.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\Public" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-3_Public" -LogFile "$logFolder\SCAP2DCM_Server2019_MAC-3_Public.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\Classified" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-2_Classified" -LogFile "$logFolder\SCAP2DCM_Server2019_MAC-2_Classified.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\Sensitive" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-2_Sensitive" -LogFile "$logFolder\SCAP2DCM_Server2019_MAC-2_Sensitive.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\Public" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-2_Public" -LogFile "$logFolder\SCAP2DCM_Server2019_MAC-2_Public.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\Classified" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-1_Classified" -LogFile "$logFolder\SCAP2DCM_Server2019_MAC-1_Classified.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\Sensitive" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-1_Sensitive" -LogFile "$logFolder\SCAP2DCM_Server2019_MAC-1_Sensitive.log"
Convert-Scap2Cab  -ScapXml $server2019Scap -OutputFile "$server2019Folder\Public" -Select "$server2019Stig/xccdf_mil.disa.stig_profile_MAC-1_Public" -LogFile "$logFolder\SCAP2DCM_Server2019_MAC-1_Public.log"
