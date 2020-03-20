<#     
============================================================================================
        Script: .ps1
        Author: Andrew Kraemer
        Version: 1.0.0.0
    ---------------------------------------------------------
    .DESCRIPTION
    
    ---------------------------------------------------------
    History:
    Ver               Modifications
    ---------------------------------------------------------
    1.0.0.0             
    
============================================================================================
#>

$BaselineRoot = "F:\SystemBaseline"
. "${BaselineRoot}\Include\Header-All.ps1"

$BaselineComponentXMLPath = "${BaselineRoot}\BaselineComponents.xml"
[xml]$BaselineComponentsXML = Get-Content -Path $BaselineComponentXMLPath

<#
    A lot of this is borrowed from Reset-AppStatus.ps1
#>

$GridWidth = 700
$WidthPerChar = 4
$Buffer = 10
$Cancelled = $False

$SelectedComponents = New-Object System.Collections.ArrayList

$Components = New-Object System.Collections.ArrayList

$ModulesXML = $BaselineComponentsXML.Modules.ChildNodes
Foreach($ModuleXML in $ModulesXML) {
    $ModuleName = $ModuleXML.Name
    $ComponentsXML = $ModuleXML.Component
    Foreach($ComponentXML in $ComponentsXML) {
        $ComponentName = $ComponentXML.Name
        $ComponentDescription = $ComponentXML.Description

        $ComponentBaselinePath = "${BaselineConfigPath}\${ComponentName}"
        $ComponentBaselineXMLPath = "${ComponentBaselinePath}\ComponentBaseline.xml"
        $BaselineDate = "Not Set"
        if(Test-Path -Path $ComponentBaselineXMLPath) {
            [xml]$ComponentBaselineXML = Get-Content -Path $ComponentBaselineXMLPath
            $Timestamp = $ComponentBaselineXML.Component.Timestamp
            $DateTime = [datetime]::ParseExact($Timestamp, "yyyyMMddTHHmmss", $null)
            $BaselineDate = $DateTime.ToString()
        }
        $ComponentRow = [PSCustomObject][Ordered]@{
            "Component" = $ComponentName
            "Module" = $ModuleName
            "Baseline Date" = $BaselineDate
            "Description" = $ComponentDescription
        }
        $Components.Add($ComponentRow) | Out-Null
    }
}

$OnLoadForm_GetComponents = {
    If($DataGridView1.columncount -gt 0){
        $DataGridView1.DataSource = $null
        $DataGridView1.Columns.RemoveAt(0) 
    }

    $Column1 = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
    $Column1.width = 50
    $Column1.name = ""
    $DataGridView1.Columns.Add($Column1)
    
    $array = New-Object System.Collections.ArrayList

    $Properties = ($Components[0].PSObject.Properties | Where { $_.MemberType -eq "NoteProperty" }).Name
    $NumColumns = $Properties.Count
    $Columns = New-Object System.Collections.ArrayList
    $i=1
    $TotalSize = 50
    Foreach($Property in $Properties) {
        $Measure = ($Components | Select-Object $Property).$Property | Measure-Object -Maximum -Property Length
        $Max = $Measure.Maximum
        $Size = $Max + $Buffer
        if($i -eq $Properties.Count) {
            $Size = $GridWidth - $TotalSize
        } else {
            $Size = $Size * $WidthPerChar
        }
        $TotalSize += $Size + 2
        $Column = [PSCustomObject]@{
            "Index" = $i
            "Size" = $Size
            "Name" = $Property
        }
        $Columns.Add($Column) | Out-Null
        $i++
    }

    $Script:procInfo = [PSCustomObject]$Components
    $array.AddRange($procInfo)
    $DataGridView1.DataSource = $array
    Foreach($Column in $Columns) {
        $DataGridView1.Columns[$Column.Index].Width = $Column.Size
    }
    $Form.refresh()
}   

$Form = GenerateForm -Title "Generate Current System Configuration Baseline" -GridWidth $GridWidth -OnLoadForm_GetComponents $OnLoadForm_GetComponents


if(-not $Cancelled) {

    if($SelectedComponents.Count -eq 0) {
        Write-Host "No Component Selected"
    }

    Foreach($ComponentName in $SelectedComponents) {
        $Component = $Components | Where { $_.Component -eq $ComponentName }
        $ModuleName = $Component.Module
        $Descripton = $Component.Description
        Write-Host "Running Get-Baseline for '${ModuleName}::${ComponentName}'"
    
        $ModulePath = "${ModulesPath}\${ModuleName}"
        $GetBaselineScript = Get-ChildItem -Path $ModulePath -Filter "Get-Baseline*.ps1" -File | Select-Object -First 1
        Invoke-Expression -Command "$($GetBaselineScript.FullName) -Components $ComponentName"

        Set-Baseline -Component $ComponentName
    }
}