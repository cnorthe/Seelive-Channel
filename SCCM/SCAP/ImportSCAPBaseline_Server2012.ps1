################################################# 
#
# Author: John J. Rayborn
# Date: 10 DEC 2019
# Version: 1.0.0
# 
# Examples:
# 
# .\ImportSCAPBaseline_Server2012.ps1 -ImportType Classified
# .\ImportSCAPBaseline_Server2012.ps1 -ImportType Public
# .\ImportSCAPBaseline_Server2012.ps1 -ImportType Sensitive
# .\ImportSCAPBaseline_Server2012.ps1 -ImportType CAT1
# .\ImportSCAPBaseline_Server2012.ps1 -ImportTYpe SlowRules
# 
#################################################


param
(
    ##### Import SCCM PoSH Module
    [ValidateSet("Classified","Public","Sensitive", "CAT1", "SlowRules")]
    [string]$ImportType,
        
    ##### Set File Directory Paths where SCAP CAB files are located
    [string]$FileDirectory1="E:\Source\SCAP2DCM\Server2012\Classified",
    [string]$Parse_Results1="New-Object System.Collections.ArrayList",
    [string]$FileDirectory2="E:\Source\SCAP2DCM\Server2012\Public",
    [string]$Parse_Results2="New-Object System.Collections.ArrayList",
    [string]$FileDirectory3="E:\Source\SCAP2DCM\Server2012\Sensitive",
    [string]$Parse_Results3="New-Object System.Collections.ArrayList",
    [string]$FileDirectory4="E:\Source\SCAP2DCM\Server2012\CAT1",
    [string]$Parse_Results4="New-Object System.Collections.ArrayList",
    [string]$FileDirectory5="E:\Source\SCAP2DCM\Server2012\SlowRules",
    [string]$Parse_Results5="New-Object System.Collections.ArrayList"    
)


function Import-SCCMPoSHModule
{
#Load Configuration Manager PowerShell Module
Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

#Get SiteCode
$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"
}

##### Import Classified Baseline Profiles into SCCM

function ImportBaseline-Classified
{
#ForEach loop to import each Baseline within the folder directory
ForEach($File in Get-ChildItem $FileDirectory1)
    {
    $FilePath1=$FileDirectory1 +"\"+ $File;
    #Import Baselines
    Import-CMBaseline -FileName $FilePath1 -Force 
    }
}

##### Import Public Baseline Profiles into SCCM

function ImportBaseline-Public
{
#ForEach loop to import each Baseline within the folder directory
ForEach($File in Get-ChildItem $FileDirectory2)
    {
    $FilePath2=$FileDirectory2 +"\"+ $File;
    #Import Baselines
    Import-CMBaseline -FileName $FilePath2 -Force 
    }
}

##### Import Sensitive Baseline Profiles into SCCM

function ImportBaseline-Sensitive
{
#ForEach loop to import each Baseline within the folder directory
ForEach($File in Get-ChildItem $FileDirectory3)
    {
    $FilePath3=$FileDirectory3 +"\"+ $File;
    #Import Baselines
    Import-CMBaseline -FileName $FilePath3 -Force 
    }
}

##### Import CAT1 Baseline Profiles into SCCM

function ImportBaseline-CAT1
{
#ForEach loop to import each Baseline within the folder directory
ForEach($File in Get-ChildItem $FileDirectory4)
    {
    $FilePath4=$FileDirectory4 +"\"+ $File;
    #Import Baselines
    Import-CMBaseline -FileName $FilePath4 -Force 
    }
}

##### Import Slow Rules Baseline Profiles into SCCM

function ImportBaseline-SlowRules
{
#ForEach loop to import each Baseline within the folder directory
ForEach($File in Get-ChildItem $FileDirectory5)
    {
    $FilePath4=$FileDirectory5 +"\"+ $File;
    #Import Baselines
    Import-CMBaseline -FileName $FilePath5 -Force 
    }
}

$ScriptBeginning = Get-Date

function Import-Classified
{
    Import-SCCMPoSHModule
    ImportBaseline-Classified
}

function Import-Public 
{
    Import-SCCMPoSHModule
    ImportBaseline-Public
}

function Import-Sensitive 
{
    Import-SCCMPoSHModule
    ImportBaseline-Sensitive
}

function Import-CAT1 
{
    Import-SCCMPoSHModule
    ImportBaseline-CAT1
}
function Import-SlowRules 
{
    Import-SCCMPoSHModule
    ImportBaseline-SlowRules
}

if ($ImportType -like "Classified") 
{
    Import-Classified
    Write-Host ""
    Write-Host -ForegroundColor Green "Classified SCAP Baselines and Configuration Items imported successfully."
}
elseif ($ImportType -like "Public") 
{
    Import-Public
    Write-Host ""
    Write-Host -ForegroundColor Green "Public SCAP Baselines and Configuration Items imported successfully"
}
elseif ($ImportType -like "Sensitive") 
{
    Import-Sensitive
    Write-Host ""
    Write-Host -ForegroundColor Green "Sensitive SCAP Baselines and Configuration Items imported successfully"
}
elseif ($ImportType -like "CAT1") 
{
    Install-PreInstallCMComponentServer
    Write-Host ""
    Write-Host -ForegroundColor Green "CAT1 SCAP Baselines and Configuration Items imported successfully"
}
elseif ($ImportType -like "SlowRules") 
{
    Install-PreInstallCMComponentServer
    Write-Host ""
    Write-Host -ForegroundColor Green "Slow Rules SCAP Baselines and Configuration Items imported successfully"
}
elseif ($ImportType -eq $null) 
{
    Write-Warning "The parameter ImportType was not defined"
}
$ScriptEnding = Get-Date
$Measure = $ScriptEnding - $ScriptBeginning
Write-Host ""
Write-Host -ForegroundColor Green "Execution time: $([math]::round($Measure.TotalSeconds)) seconds"