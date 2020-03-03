<#
.Synopsis
   Move configuration baseline items in System Center Configuration Manager
.DESCRIPTION
   This function gets configuration baselines and stores it in an array then move them
   to specified folder path.
.EXAMPLE
   $serverBaselineItems = 'Windows Server*'
    $serverFolderPath = $($SiteCode.name+":\ConfigurationBaseline\Configuration Baselines\CI - Server Collections")
    $serverInputObjects = (Get-CMBaseline -Name $serverBaselineItems)
    Move-ConfigurationBaseline -Name $serverBaselineItems -FolderPath $serverFolderPath -InputObject $serverInputObjects
#>
function Move-ConfigurationBaseline
{
    [CmdletBinding()]
    Param
    (
        [Parameter()]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [string]
        $FolderPath,

        [Parameter(Mandatory = $true)]
        [system.array]
        $InputObject
    )

    $cmBaselineNames = Get-CMBaseline -Name $Name

    foreach ($cmBaselineName in $cmBaselineNames)
        {
            Move-CMObject -FolderPath $FolderPath -InputObject $inputObject

            Write-Verbose -Verbose "Moving $($cmBaselineName.LocalizedDisplayName) Baselines in $($FolderPath)."
        }
}

$serverBaselineItems = 'Windows Server*'
$serverFolderPath = $($SiteCode.name+":\ConfigurationBaseline\Configuration Baselines\CI - Server Collections")
$serverInputObjects = (Get-CMBaseline -Name $serverBaselineItems)

$workstationBaselineItems = 'Windows 10*'
$workstationFolderPath = $($SiteCode.name+":\ConfigurationBaseline\Configuration Baselines\CI - Workstation Collections")
$workstationInputObjects = (Get-CMBaseline -Name $workstationBaselineItems)

Move-ConfigurationBaseline -Name $serverBaselineItems -FolderPath $serverFolderPath -InputObject $serverInputObjects
Move-ConfigurationBaseline -Name $workstationBaselineItems -FolderPath $workstationFolderPath -InputObject $workstationInputObjects