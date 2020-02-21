function Convert-Scap2Cab
 {
    param
    (
        [Parameter()]
        [String]
        $ScapToDcmPath = 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\Microsoft.Sces.ScapToDcm.exe',
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
$windows10Scap = 'C:\Temp\U_MS_Windows_10_V1R16_STIG_SCAP_1-2_Benchmark\U_MS_Windows_10_V1R16_STIG_SCAP_1-2_Benchmark.xml'
$windows10Stig = 'scap_mil.disa.stig_datastream_U_MS_Windows_10_V1R16_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_10_STIG'

#Server 2016 SCAP xml & Stig xccdf
$server2016Scap = 'C:\Temp\U_MS_Windows_Server_2016_V1R12_STIG_SCAP_1-2_Benchmark\U_MS_Windows_Server_2016_V1R12_STIG_SCAP_1-2_Benchmark.xml'
$server2016Stig = 'scap_mil.disa.stig_datastream_U_MS_Windows_Server_2016_V1R12_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_Server_2016_STIG'

#Sever 2019 SCAP xml & Stig xccdf
$server2019Scap = 'C:\Temp\U_MS_Windows_Server_2019_V1R2_STIG_SCAP_1-2_Benchmark\U_MS_Windows_Server_2019_V1R2_STIG_SCAP_1-2_Benchmark.xml'
$server2019Stig = 'scap_mil.disa.stig_datastream_U_MS_Windows_Server_2019_V1R2_STIG_SCAP_1-2_Benchmark/xccdf_mil.disa.stig_benchmark_Windows_Server_2019_STIG'

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
