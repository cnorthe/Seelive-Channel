<#
    .Synopsis
       Creates a new SCCM configuration item & baseline deployment.

    .DESCRIPTION
       This function creates a new SCCM configuration item & baseline compliance script setting and deploys it.

    .PARAMETER CIName
        Specify the name of the configuration item and baseline.

    .PARAMETER CIDescription
        Specify a description of the configuration item.

    .PARAMETER DiscoveryScriptFilePath
        Specify a path to the Powershell discovery script file.

    .PARAMETER CIRuleNameDescription
        Specify a description of the configuration item rule.

    .PARAMETER CBDescription
        Specify a description of the configuration baseline.

    .PARAMETER CollectionName
        Specify a name of the device collection.

    .PARAMETER CBDescription
        Specify a description of the configuration baseline.

    .PARAMETER RecurInterval
        Specifies the time when the configuration deployment recurs.

    .PARAMETER RecurCount
        Specifies the number of recurrences of the configuration deployment.

    .PARAMETER ParameterValue
        Specify a percentage of when to generate an alert.

    .PARAMETER PostponeDateTime
        Specify a date when the configuration deployment begins.

    .EXAMPLE
       New-ConfigurationItemDeployment -CIName 'thisISaTest' -CIDescription 'this is a test' -DiscoveryScriptFilePath 'C:\Test.ps1' -CollectionName 'TestCollection' -RecurInterval 'hour' -RecurCount 2 -PostponeDateTime 2020/03/01
#>
function New-ConfigurationItemDeployment
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $CIName,

        [Parameter()]
        [string]
        $CIDescription,

        [Parameter()]
        [string]
        $DiscoveryScriptFilePath,

        [Parameter()]
        [string]
        $CIRuleNameDescription,

        [Parameter()]
        [string]
        $CBDescription,

        [Parameter()]
        [string]
        $CollectionName,

        [Parameter(Mandatory=$true)]
        [string]
        $RecurInterval,  #hour, #days, minutes, hour

        [Parameter(Mandatory=$true)]
        [int]
        $RecurCount,

        [Parameter()]
        [int]
        $ParameterValue = 90,

        [Parameter()]
        [datetime]
        $PostponeDateTime #2020/03/01
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
    New-CMBaselineDeployment -CollectionName $CollectionName -Name $CIName -Schedule $baselineSchedule -GenerateAlert $True -MonitoredByScom $True -ParameterValue $ParameterValue -PostponeDateTime $PostponeDateTime | Out-Null
}

