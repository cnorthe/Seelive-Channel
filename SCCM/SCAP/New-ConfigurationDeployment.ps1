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

$cmBaselineNames = Get-CMBaseline -Name 'Windows*'
$collectionName = 'Test All Windows 10 Clients'

    foreach ($cmBaselineName in $cmBaselineNames)
    {
        New-ConfigurationDeployment -BaselineName $cmBaselineName.LocalizedDisplayName -CollectionName $collectionName -ParameterValue 50 -PostponeDateTime 2019/03/01    
        Write-Verbose -Verbose "Creating $($cmBaselineName.LocalizedDisplayName) Baseline Deployment."
    }
