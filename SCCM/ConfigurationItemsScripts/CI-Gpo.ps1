#Compare GPOs in the enviornment to a baseline and export it to HTML file

Param(
    [Parameter()]
    [string]
    $ReportTitle = 'Gpo Baseline Report',
    [Parameter()]
    [string]
    $CssUri = 'C:\Temp\sample.css',
    [Parameter()]
    [string]
    $Path = 'C:\Temp\gposbaseline.xml',
    [Parameter()]
    [string]
    $OutFile = 'C:\temp\GpoReport.html'
)

#get all gpos and export to gposbaseline.xml
#Get-GPO -All | Export-Clixml -Path 'C:\Temp\gposbaseline.xml'

#Import Gpo Baseline
$gposBaselineXml = Import-Clixml -Path $Path

#compare difference of gposbaseline.xml to current gpos
$data = Compare-Object -ReferenceObject $gposBaselineXml -DifferenceObject (Get-GPO -All) -Property DisplayName,ModificationTime,Path,GpoStatus

#create an HTML report
$footer = "<h5><i>report run $(Get-Date)</i></h5>"
$css = $CssUri
$precontent = "<H1>$ReportTitle</H1>"

$data | Where-Object {$_.SideIndicator -eq '=>'} | Select-Object @{Name='Gpo Name';Expression={$_.DisplayName}},
ModificationTime,Path,GpoStatus,SideIndicator -Unique |
ConvertTo-Html -Title $ReportTitle -PreContent $precontent -PostContent $footer -CssUri $css | Out-File $OutFile

# Invoke-item -Path 'C:\temp\GpoReport.html'
