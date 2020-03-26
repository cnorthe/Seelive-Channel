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
        [Parameter()]
        [string]
        $CollectionName,

        [Parameter()]
        [boolean]
        $EnableEnforcement,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [int]
        $ParameterValue = 90,

        [Parameter()]
        [datetime]
        $PostponeDateTime = 2020/03/01
    )

    $schedule = New-CMSchedule -RecurCount 1 -RecurInterval Days

    $cmBaselineNames = Get-CMBaseline -Name $Name

    foreach ($cmBaselineName in $cmBaselineNames)
    {
        New-CMBaselineDeployment -Name $cmBaselineName.LocalizedDisplayName -CollectionName $CollectionName -GenerateAlert $True -MonitoredByScom $True -ParameterValue $ParameterValue -PostponeDateTime $PostponeDateTime -Schedule $schedule | Out-Null
        Write-Verbose -Verbose "Creating $($cmBaselineName.LocalizedDisplayName) Baseline Deployment."
    }
}

$cmBaselineNames = 'Windows 10*'
$collectionName = "CI - All Windows 10 Clients"

New-ConfigurationDeployment -Name $cmBaselineNames -CollectionName $collectionName -PostponeDateTime 2019/03/01
