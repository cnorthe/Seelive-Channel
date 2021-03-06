<#
.Synopsis
   Import Scap configuration items and baselines in System Center Configuration Manager
.DESCRIPTION
   This function imports Scap configuration items and baselines in System Center
   Configuration Manager
.EXAMPLE
    $ImportFolder = 'C:\temp\SCAP2Convert'
    Import-SCAPBaseline -Path "$ImportFolder\Windows10"
    Import-SCAPBaseline -Path "$ImportFolder\Server2016"
    Import-SCAPBaseline -Path "$ImportFolder\Server2019"
#>
function Import-ScapBaseline
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    $files = Get-ChildItem -Path $Path -File -Recurse -Include *.Cab

    foreach ($file in $files)
    {
        Import-CMBaseline -FileName $file.FullName -Force
        Write-Verbose -Verbose "$($file.Name) SCAP Baselines and Configuration Items imported successfully."
    }
}

#Location for SCAP CAB Benchmarks
$ImportFolder = 'C:\temp\SCAP2Convert'

Import-SCAPBaseline -Path "$ImportFolder\Windows10"
Import-SCAPBaseline -Path "$ImportFolder\Server2016"
Import-SCAPBaseline -Path "$ImportFolder\Server2019"