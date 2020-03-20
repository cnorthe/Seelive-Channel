<#     
============================================================================================
        Script: Get-Baseline-SCCM-Inventory.ps1
        Version: 1.0.0.0
    ---------------------------------------------------------
    .DESCRIPTION
    This file is included at the beginning of all "Get-Baseline" scripts
    
    ---------------------------------------------------------
    History:
    Ver               Modifications
    ---------------------------------------------------------
    1.0.0.0             
    
============================================================================================
#>
Param([Array]$Components = $null)

$ModuleName = "SCCM-Inventory"

$BaselineRoot = "F:\SystemBaseline"
. "${BaselineRoot}\Include\Header-Module.ps1"

Import-SQL-Module

$QueriesPath = "${ModulePath}\Queries"

$DBQueryFiles = Get-ChildItem -Filter "*.sql" -Path $QueriesPath -Recurse

Foreach($DBQueryFile in $DBQueryFiles) {
    $ComponentName = $DBQueryFile.BaseName
    if($Components -ne $null -and $ComponentName -notin $Components) {
        Continue
    }
    Write-Host "Processing Baseline Component: ${ComponentName}"
    $CurrentComponentPath = Get-Current-Component-Path -ComponentName $ComponentName
    Recreate-Directory -Path $CurrentComponentPath
    
    $Query = Get-Content -Path $DBQueryFile.FullName -Raw

    $Results = Run-SQL-Query -Query $Query
    $CurrentComponentPath = Get-Current-Component-Path -ComponentName $ComponentName 
    $ComponentData = Process-DataTable -DataTable $Results -Path $CurrentComponentPath

    Create-Baseline-Files -ComponentData $ComponentData
}