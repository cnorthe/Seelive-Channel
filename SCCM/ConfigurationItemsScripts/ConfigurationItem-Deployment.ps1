<#
************************************************************************************************************************
 
Created:    2020-05-07
Version:    1.0
---------------------------------------------------------
.DESCRIPTION
    This script creates a reoccuring Configuration Item & Baseline to execute the SystemBaseline script in SCCM.
---------------------------------------------------------

Author - Clive Northey
 
************************************************************************************************************************
#>

Param(
    [string]$CIName = 'Install SystemBaseline',
    [string]$CIDescription = 'SCCM Configuration Item to setup & execute SystemBaseline',
    [string]$DiscoveryScriptFilePath = 'C:\Temp\Test.ps1',
    [string]$CIRuleNameDescription = 'Set configuration rule value to true',
    [string]$CBDescription = 'SCCM Configuration Baseline to setup & execute SystemBaseline',
    [string]$CollectionName = 'DomainController',
    [string]$RecurInterval = 'hour', #days, minutes, hour
    [int]$RecurCount = '2',
    [int]$ParameterValue = 90
    )

#Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

#create the Configuration Item
$ciObject = New-CMConfigurationItem -Name $CIName -CreationType WindowsOS -Description $CIDescription

#Create the settings by using Powershell script
Add-CMComplianceSettingScript -InputObject $ciObject -Name $ciObject.LocalizedDisplayName -DataType Boolean -DiscoveryScriptLanguage PowerShell -DiscoveryScriptFile $DiscoveryScriptFilePath -IsPerUser -NoRule | Out-Null

#Create the settings rule
$ciSetting = $ciObject | Get-CMComplianceSetting -SettingName $ciObject.LocalizedDisplayName
$ciRule = $ciSetting | New-CMComplianceRuleValue -ExpressionOperator IsEquals -RuleName $ciObject.LocalizedDisplayName -ExpectedValue 'True' -NoncomplianceSeverity None -RuleDescription $CIRuleNameDescription 
Add-CMComplianceSettingRule -InputObject $ciObject -Rule $ciRule | Out-Null

#Create Baseline & adding CI
New-CMBaseline -Name $CIName -Description $CIDescription -Verbose | Out-Null
Set-CMBaseline -Name $CIName -AddOSConfigurationItem $ciObject.CI_ID -Verbose

#Create Baseline schedule
$baselineSchedule = New-CMSchedule -RecurInterval $RecurInterval -RecurCount $RecurCount

#Deploy the baseline to the target collection
New-CMBaselineDeployment -CollectionName $CollectionName -Name $CIName -Schedule $baselineSchedule -GenerateAlert $True -MonitoredByScom $True -ParameterValue $ParameterValue -PostponeDateTime 2020/03/01 | Out-Null
