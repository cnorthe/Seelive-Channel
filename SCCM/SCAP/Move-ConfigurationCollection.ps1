<#
.Synopsis
   Move CM Collections in System Center Configuration Manager
.DESCRIPTION
   This function gets CM Collection and stores it in an array then move them
   to specified folder path.
.EXAMPLE
   $serverCollection = 'oval.mil.disa*'
    $serverFolderPath = $($SiteCode.Name+":\DeviceCollection\Configuration Items\CI - Server Collections")
    $serverInputObjects = (Get-CMConfigurationItem  -Name $serverCollection)
    Move-ConfigurationCollection -Name $serverCollection -FolderPath $serverFolderPath -InputObject $serverInputObjects
#>
function Move-ConfigurationCollection
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $true)]
        [string]
        $FolderPath,

        [Parameter(Mandatory = $true)]
        [system.array]
        $InputObject
    )

    $cmDeviceCollections = Get-CMDeviceCollection  -Name $Name

    foreach ($cmDeviceCollection in $cmDeviceCollections)
    {
        Move-CMObject -FolderPath $FolderPath -InputObject $inputObject

        Write-Verbose -Verbose "Moving $($cmDeviceCollection.Name) collection in $($FolderPath)."
    }
}

$serverCollection = 'CI - All Server*'
$serverFolderPath = $($SiteCode.Name+":\DeviceCollection\Configuration Items\CI - Server Collections")
$serverInputObjects = (Get-CMDeviceCollection  -Name $serverCollection)

$workstationCollection = 'CI - All Windows*'
$workstationFolderPath = $($SiteCode.Name+":\DeviceCollection\Configuration Items\CI - Workstation Collections")
$workstationInputObjects = (Get-CMDeviceCollection  -Name $workstationCollection)

Move-ConfigurationCollection -Name $serverCollection -FolderPath $serverFolderPath -InputObject $serverInputObjects
Move-ConfigurationCollection -Name $workstationCollection -FolderPath $workstationFolderPath -InputObject $workstationInputObjects
