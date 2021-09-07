<#
Script Name: CompareGpo.ps1
Author:      Clive Northey
Version:     1.0

.Synopsis
    This script compares GPOs exported to a CSV to what is in a target Active Directory environment. It will create a text report of
    the Gpo Names that are stored in CSV, only the Gpo Names that are stored in the current Domain and only the Gpo Names that are stored in the CSV and Domain.
.PARAMETERS
    -CsvPath:
        MANDATORY: False
        TYPE: String
        PURPOSE: location path of the csv file.
    -ReportPath:
        MANDATORY: False
        TYPE: String
        PURPOSE: location path of the text report file.
.EXAMPLE
   .\CompareGpo.ps1
#>

Param (
    [string]
    $CsvPath,
    [string]
    $ReportPath
)

#import CSV file
$GposCsv = Import-Csv -Path $CsvPath
$GposCsv = $GposCsv | Select-Object GpoName

#Get Domain name for Gpos
$Domain = $env:USERDNSDOMAIN

#Get all the Gpos in the current Domain
$Gpos = Get-GPO -All -Domain $Domain | Select-Object @{Name = 'GpoName'; E = { $_.DisplayName } }

#empty arrays for Gpos
$GposCsvArray = [System.Collections.ArrayList]@()
$GposArray = [System.Collections.ArrayList]@()

#loop thru all the Gpos in Csv and add names to empty array
foreach ($Gpo in $GposCsv) {
    $gpoName = $Gpo
    $GposCsvArray.Add($gpoName) | Out-Null
}

#loop thru all the Gpos in Domain and add names to empty array
foreach ($Gp in $Gpos) {
    $gpoName = $Gp
    $GposArray.Add($gpoName) | Out-Null
}

# Shows only the Gpo Names that are stored in CSV
$onlyInCsv = $GposCsvArray | Where-Object { $GposArray -notcontains $_ } | Sort-Object -Property GpoName

# Shows only the Gpo Names that are stored in the current Domain.
$onlyInDomain = $GposArray | Where-Object { $GposCsvArray -notcontains $_ } | Sort-Object -Property GpoName

# Shows only the Gpo Names that are stored in the CSV and Domain
$containedInBoth = $GposCsvArray | Where-Object { $GposArray -match $_ } | Sort-Object -Property GpoName

<#
# Shows only the Gpo Names that are only in Csv and only in Domain
$containedNotInBoth = ($GposCsvArray | Where {$GposArray -NotContains $_}) + ($GposArray |
Where {$GposCsvArray -NotContains $_}) | Sort-Object -Property GpoName
#>

$header = @"
*************************************************************
Group Policy Compare Report - Latest Check $((Get-Date).ToShortDateString())
*************************************************************
"@

#Timestamp and report Output file name
$timestamp = Get-Date -format 'MMddyyyy'
$outputFile = "GpoCompareReport-$timestamp.txt"
$outputPath = Join-Path -path $ReportPath -ChildPath $outputFile

#hashtable of parameters for Out-File.
$outParams = @{
    FilePath = $OutputPath
    Encoding = "ASCII"
    Append   = $True
    Width    = 120
}

$header | Out-File @outParams

#create results in .txt file
$onlyInCsv | Select-Object @{N = "GpoNames in CSV Domain"; E = { $_.GpoName } } | Out-File @outParams
$onlyInDomain | Select-Object @{N = "GpoNames in $($env:USERDNSDOMAIN)"; E = { $_.GpoName } } | Out-File @outParams
$containedInBoth | Select-Object @{N = "GpoNames in CSV and $($env:USERDNSDOMAIN)"; E = { $_.GpoName } } | Out-File @outParams
