<#
.Synopsis
   Move configuration items in System Center Configuration Manager
.DESCRIPTION
   This function gets configuration items and stores it in an array then move them
   to specified folder path.
.EXAMPLE
   $serverConfigurationItems = 'oval.mil.disa*'
    $serverFolderPath = $($SiteCode.name+":\ConfigurationItem\Configuration Items\CI - Server Collections")
    $serverInputObjects = (Get-CMConfigurationItem  -Name $serverConfigurationItems -Fast)
    Move-ConfigurationBaseline -Name $serverConfigurationItems -FolderPath $serverFolderPath -InputObject $serverInputObjects
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

    $cmConfigurationNames = Get-CMConfigurationItem  -Name $Name -Fast

    foreach ($cmConfigurationName in $cmConfigurationNames)
        {
            Move-CMObject -FolderPath $FolderPath -InputObject $inputObject

            Write-Verbose -Verbose "Moving $($cmConfigurationName.LocalizedDisplayName) configuration item in $($FolderPath)."
        }
}

$serverConfigurationItems = 'oval.mil.disa*'
$serverFolderPath = $($SiteCode.name+":\ConfigurationItem\Configuration Items\CI - Server Collections")
$serverInputObjects = (Get-CMConfigurationItem  -Name $serverConfigurationItems -Fast)

$workstationConfigurationItems = 'oval.mil.disa*'
$workstationFolderPath = $($SiteCode.name+":\ConfigurationItem\Configuration Items\CI - Workstation Collections")
$workstationInputObjects = (Get-CMConfigurationItem  -Name $workstationConfigurationItems -Fast)

Move-ConfigurationBaseline -Name $serverConfigurationItems -FolderPath $serverFolderPath -InputObject $serverInputObjects
Move-ConfigurationBaseline -Name $workstationConfigurationItems -FolderPath $workstationFolderPath -InputObject $workstationInputObjects