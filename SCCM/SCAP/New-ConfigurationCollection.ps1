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

#Create Collection
$collectionName = "Test All Windows 10 Clients"
$queryExpression = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_System.OperatingSystemNameandVersion like '%Workstation 10.0%' and SMS_R_System.Client = '1'"
$ruleName = $collectionName
$comment = $collectionName

New-ConfigurationCollection -CollectionName $collectionName -Comment $comment -LimitingCollectionName 'All Systems' -QueryExpression $queryExpression -RuleName $ruleName
