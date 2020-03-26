function Import-SCCMPoSHModule
{
    #Load Configuration Manager PowerShell Module
    Import-module ($Env:SMS_ADMIN_UI_PATH.Substring(0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

    #Get SiteCode
    $SiteCode = Get-PSDrive -PSProvider CMSITE
    Set-location $SiteCode":"
}

<#
.Synopsis
   Converts Security Content Automation Protocol (SCAP) content to (DCM) .cab extenstion.
.DESCRIPTION
   SCCM extensions for SCAP converts Security Content Automation Protocol (SCAP) content for use by desired configuration
   management (DCM) and DCM reports into SCAP reporting format.
.EXAMPLE
   Convert-Scap2Cab  -ScapXml $windows10Scap -OutputFile "$windows10Folder\CAT1" -Select "$windows10Stig/xccdf_mil.disa.stig_profile_CAT_I_Only" -LogFile "$logFolder\SCAP2DCM_Windows10_CAT_I_Only.log"
#>
function Convert-Scap2Cab
 {
    param
    (
        [Parameter()]
        [String]
        $ScapToDcmPath = 'F:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\Microsoft.Sces.ScapToDcm.exe',
        [Parameter(Mandatory = $true)]
        [String]
        $ScapXml,
        [Parameter(Mandatory = $true)]
        [String]
        $OutputFile,
        [Parameter(Mandatory = $true)]
        [String]
        $Select,
        [Parameter()]
        [String]
        $MaxCi = 500,
        [Parameter(Mandatory = $true)]
        [String]
        $LogFile
    )
    & $ScapToDcmPath -Scap $ScapXml -Out $OutPutFile -Select $Select -MaxCi $MaxCi -Log $LogFile
 }

<#
.Synopsis
   Creates folders in System Center Configuration Manager
.DESCRIPTION
   Creates Configuration Item folders and Collections in System Center Configuration Manager
.EXAMPLE
   New-ConfigurationFolder -Name 'Configuration Collections' -Path $SiteCode.Name+"\DeviceCollection"
#>
function New-ConfigurationFolder
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Path
    )

    New-Item -Name $Name -Path $Path -Force
    Write-Verbose -Verbose "Creating $($Name) folder in $($Path)."
}

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
        Write-Verbose -Verbose "$($file.Name) SCAP Baseline and Configuration Items imported successfully."
    }
}

<#
.Synopsis
   Creates a collection for devices and adds the collection to the Configuration Manager hierarchy.
.DESCRIPTION
   Creates a collection for devices and adds the collection to the Configuration Manager hierarchy.
.EXAMPLE
    $collectionName = "Test All Windows 10 Clients"
    $queryExpression = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Workstation 10.0%' and SMS_R_System.Client = '1'"
    $ruleName = $collectionName
    $comment = $collectionName

   New-ConfigurationCollection -CollectionName $collectionName -Comment $comment -LimitingCollectionName 'All Systems' -QueryExpression $queryExpression -RuleName $ruleName
#>
function New-ConfigurationCollection
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $CollectionName,

        [Parameter()]
        [string]
        $Comment,

        [Parameter(Mandatory = $true)]
        [string]
        $LimitingCollectionName = 'All Systems',

        [Parameter(Mandatory = $true)]
        [string]
        $QueryExpression,

        [Parameter(Mandatory = $true)]
        [string]
        $RuleName
    )

    #Refresh Schedule
    $schedule = New-CMSchedule –RecurInterval Days –RecurCount 2

    New-CMDeviceCollection -Name $CollectionName -Comment $Comment -LimitingCollectionName $LimitingCollectionName -RefreshSchedule $Schedule -RefreshType 2 | Out-Null

    Add-CMDeviceCollectionQueryMembershipRule -CollectionName $CollectionName -QueryExpression $QueryExpression -RuleName $RuleName

    Write-Verbose -Verbose "Creating $($CollectionName) Collection."
}

<#
.Synopsis
   Move CM Collections in System Center Configuration Manager
.DESCRIPTION
   This function gets CM Collection and stores it in an array then move them
   to specified folder path.
.EXAMPLE
   $serverCollection = 'All Windows Server 2016*'
   $serverFolderPath = $($SiteCode.Name+":\DeviceCollection\Configuration Items\CI - Server Collections")
   $serverInputObjects = (Get-CMCollection -Name $serverCollection)
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
        Move-CMObject -FolderPath $FolderPath -InputObject $InputObject
        Write-Verbose -Verbose "Moving $($cmDeviceCollection.Name) collection in $($FolderPath)."
    }
}

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
    Move-ConfigurationItem -Name $serverConfigurationItems -FolderPath $serverFolderPath -InputObject $serverInputObjects
#>
function Move-ConfigurationItem
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

<#
.Synopsis
   Creates configuration baseline deployments in System Center Configuration Manager
.DESCRIPTION
   This function creates configuration baseline deployments in System Center Configuration Manager
.EXAMPLE
    $cmBaselineName = 'Baseline Name'
    $collectionName = 'All Windows 10 Clients'
    New-ConfigurationDeployment -BaselineName $cmBaselineName -CollectionName $collectionName -ParameterValue 90 -PostponeDateTime 2020/03/01
#>
function New-ConfigurationDeployment
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $BaselineName,

        [Parameter()]
        [string]
        $CollectionName,

        [Parameter()]
        [boolean]
        $EnableEnforcement,

        [Parameter()]
        [int]
        $ParameterValue = 90,

        [Parameter()]
        [datetime]
        $PostponeDateTime = 2020/03/01
    )

        $schedule = New-CMSchedule -RecurCount 1 -RecurInterval Days

        New-CMBaselineDeployment -BaselineName $BaselineName -CollectionName $CollectionName -GenerateAlert $True -MonitoredByScom $True -ParameterValue $ParameterValue -PostponeDateTime $PostponeDateTime -Schedule $schedule | Out-Null
}

<#
.Synopsis
   Remove configuration baseline in System Center Configuration Manager
.DESCRIPTION
   This function gets configuration baselines and stores it in an array and removes it.
.EXAMPLE
    $cmConfigurationBaselines = 'Windows*'
    Remove-ConfigurationBaseline -Name $cmConfigurationBaselines
#>
function Remove-ConfigurationBaseline
{
    [CmdletBinding()]
    Param
    (
        [Parameter()]
        [string]
        $Name
   )

    $cmConfigurationBaselines = Get-CMBaseline -Name $Name

    foreach ($cmConfigurationBaseline in $cmConfigurationBaselines)
    {
        Remove-CMBaseline -Name $cmConfigurationBaseline.LocalizedDisplayName -Force
        Write-Verbose -Verbose "Removing $($cmConfigurationBaseline.LocalizedDisplayName) configuration baseline."
    }
}

<#
.Synopsis
   Remove configuration items in System Center Configuration Manager
.DESCRIPTION
   This function gets configuration items and stores it in an array then remove them.
.EXAMPLE
    $cmConfigurationItems = 'oval.mil.disa*'
    Remove-ConfigurationItem -Name $cmConfigurationItems
#>
function Remove-ConfigurationItem
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Name
   )

    $cmConfigurationItems = Get-CMConfigurationItem -Name $Name -Fast

    foreach ($cmConfigurationItem in $cmConfigurationItems)
    {
        Remove-CMConfigurationItem -Name $cmConfigurationItem.LocalizedDisplayName -Force
        Write-Verbose -Verbose "Removing $($cmConfigurationItem.LocalizedDisplayName) configuration item."
    }
}

