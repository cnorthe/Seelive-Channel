#new CI with new setting(script type)/rule with remediation in pipeline:

$myCIName = 'myNewCI'
$myCSName = 'myNewSetting'
$myCRName = 'myNewRule'

New-CMConfigurationItem -Name $myCIName -CreationType WindowsOS | Add-CMComplianceSettingScript
-Name $myCSName -DataType Integer -DiscoveryScriptLanguage PowerShell -DiscoveryScriptText 'Test'
-RemediationScriptLanguage PowerShell -RemediationScriptText 'Re-Test' -RuleName 'myNewRule'
-ValueRule -ExpectedValue 1 -ExpressionOperator IsEquals | Set-CMComplianceRuleValue -RuleName $myCRName
-Remediate $true