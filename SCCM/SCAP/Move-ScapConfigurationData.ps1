function Move-ScapConfigurationData
{
    [cmdletbinding()]
    param
    (
        [Parameter()]
        [string]
        $BaselineName,

        [Parameter()]
        [string]
        $ConfigurationItemName,

        [Parameter()]
        [string]
        $DeviceCollectionName,

        [Parameter(Mandatory = $true)]
        [string]
        $FolderPath,

        [Parameter(Mandatory = $true)]
        [string]
        $InputObject
    )

    #Get configuration baselines
    Get-CMBaseline -BaselineName $BaselineName

    #Get CM device collection
    Get-CMDeviceCollection -DeviceCollectionName $DeviceCollectionName

    #Get configuration items
    Get-CMConfigurationItem -ConfigurationItemName $ConfigurationItemName

    #Move configuration data objects
    Move-CMObject -FolderPath $FolderPath -InputObject $InputObject
}

#CM device collection folder path
$cmDeviceCollectionFolderPath = $SiteCode.name+":\DeviceCollection\Compliance Settings\"

#Configuration items folder path
$configurationItemsFolderPath = $SiteCode.name+":\ConfigurationItem\Configuration Items"

#Configuration baseline folder path
$configurationBaselineFolderPath = $SiteCode.name+":\ConfigurationBaseline\Configuration Baselines"

CS - Workstation Collections

Import-SCAPBaseline -Path "$folderPath\Windows10"


