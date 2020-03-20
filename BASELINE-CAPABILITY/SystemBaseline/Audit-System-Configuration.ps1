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
$global:Cancelled = $False

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
            $BaselineTimestamp = $ComponentBaselineXML.Component.Timestamp
            $DateTime = [datetime]::ParseExact($BaselineTimestamp, "yyyyMMddTHHmmss", $null)
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
    $Column1.MinimumWidth = 50
    $Column1.Width = 50
    $Column1.name = ""
    $DataGridView1.Columns.Add($Column1)
    
    $array = New-Object System.Collections.ArrayList

    $Properties = ($Components[0].PSObject.Properties | Where { $_.MemberType -eq "NoteProperty" }).Name
    $NumColumns = $Properties.Count
    $Columns = New-Object System.Collections.ArrayList
    $i=1
    Foreach($Property in $Properties) {
        $Measure = ($Components | Select-Object $Property).$Property | Measure-Object -Maximum -Property Length
        $Max = $Measure.Maximum
        $Size = ($Max * $WidthPerChar) + $Buffer
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
    $DataGridView1.AutoSizeColumnsMode = "Fill"
    Foreach($Column in $Columns) {
        $DataGridView1.Columns[$Column.Index].MinimumWidth = $Column.Size
    }
    $DataGridView1.AutoResizeColumns()

    # Add condition if baseline date isn't set
    $BaselineDateCol = $Properties.IndexOf("Baseline Date") + 1
    for($i=0;$i -lt $datagridview1.RowCount;$i++) { 
        if($datagridview1.Rows[$i].Cells[$BaselineDateCol].Value -eq "Not Set") {
            $DataGridView1.Rows[$i].Cells[0].ReadOnly = $True
            $DataGridView1.Rows[$i].Cells[0].Style.BackColor = "#d3d3d3"
        }
    }

    $Form.refresh()
}   


$Form = GenerateForm -Title "Audit Current System Configuration Baseline" -GridWidth $GridWidth -OnLoadForm_GetComponents $OnLoadForm_GetComponents

if(-not $Cancelled) {

    $AuditResults = New-Object System.Collections.ArrayList

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

        Write-Host "Running Audit for '${ModuleName}::${ComponentName}'"
        $ComponentResults = Audit-Component-Baseline -Component $ComponentName
        $AuditResults.AddRange($ComponentResults) | Out-Null
    }

    $AuditSummary = New-Object System.Collections.ArrayList

    Foreach($Component in $Components) {
        $ComponentName = $Component.Component
        $Selected = $AuditResults | Where { $_.Component -eq $ComponentName }
        if($Selected -eq $null) {
            Continue
        }
        $ComponentIssues = $AuditResults | Where { $_.Component -eq $ComponentName -and $_.Result -ne "MATCH" }
        $Audit = "Pass"
        if($ComponentIssues -ne $null) {
            $Audit = "Fail"
        }
        
        $Component | Add-Member -MemberType NoteProperty -Name "Audit Result" -Value $Audit -Force
        $Component.PSObject.Properties.Remove("Description")
        $AuditSummary.Add($Component) | Out-Null
    }

    $OnLoadForm_ComponentsResults = {
        If($DataGridView1.columncount -gt 0){
            $DataGridView1.DataSource = $null
            $DataGridView1.Columns.RemoveAt(0) 
        }
   
        $array = New-Object System.Collections.ArrayList

        $Properties = ($AuditSummary[0].PSObject.Properties | Where { $_.MemberType -eq "NoteProperty" }).Name
        $NumColumns = $Properties.Count
        $Columns = New-Object System.Collections.ArrayList
        $i=0
        $TotalSize = 0
        Foreach($Property in $Properties) {
            $Measure = ($AuditSummary | Select-Object $Property).$Property | Measure-Object -Maximum -Property Length
            $Max = $Measure.Maximum
            $Size = ($Max * $WidthPerChar) + $Buffe
            $Column = [PSCustomObject]@{
                "Index" = $i
                "Size" = $Size
                "Name" = $Property
            }
            $Columns.Add($Column) | Out-Null
            $i++
        }

        $Script:procInfo = [PSCustomObject]$AuditSummary
        $array.AddRange($procInfo)
        $DataGridView1.DataSource = $array
        $DataGridView1.AutoSizeColumnsMode = "Fill"
        Foreach($Column in $Columns) {
            $DataGridView1.Columns[$Column.Index].MinimumWidth = $Column.Size
            $DataGridView1.AutoResizeColumn($Column.Index)
        }
        # Add condition to color audit cell
        $BaselineAuditCol = $Properties.IndexOf("Audit Result")
        Write-Host $Properties
        Write-Host "Audit Column: $BaselineAuditCol"
        for($i=0;$i -lt $datagridview1.RowCount;$i++) { 
            if($datagridview1.Rows[$i].Cells[$BaselineAuditCol].Value -eq "Pass") {
                $DataGridView1.Rows[$i].Cells[$BaselineAuditCol].Style.BackColor = "#00FF00"
            }
            if($datagridview1.Rows[$i].Cells[$BaselineAuditCol].Value -eq "Fail") {
                $DataGridView1.Rows[$i].Cells[$BaselineAuditCol].Style.BackColor = "#FF0000"
            }
        }

        
        $Form.refresh()
    }   

    #$Form = GenerateForm -Title "Audit System Configuration Baseline Results" -GridWidth $GridWidth -OnLoadForm_GetComponents $OnLoadForm_ComponentsResults -SelectAll $False -ClearAll $False -Cancel $False -OK $False

    $ReportPath = Generate-HTML-Report -AuditResults $AuditResults

    $ReportIndex = "${ReportPath}\index.html"
    
    Start-Process $ReportIndex
}