[CmdletBinding()]
Param(
    [Parameter()]
    [string[]]
    $ComputerName = @('localhost'),

    [Parameter()]
    [string]
    $OutputPath = 'C:\Repo\Seelive-Channel\ResetLCM'
)

[DscLocalConfigurationManager()]
Configuration ResetLCM {
    Param (
        [String[]]
        $NodeName
    )
    Node $NodeName {
        Settings {
            ActionAfterReboot              = 'ContinueConfiguration'
            AllowModuleOverwrite           = $false
            CertificateID                  = $null
            ConfigurationDownloadManagers  = @{}
            ConfigurationID                = $null
            ConfigurationMode              = 'ApplyAndMonitor'
            ConfigurationModeFrequencyMins = 15
            DebugMode                      = @('NONE')
            MaximumDownloadSizeMB          = 500
            RebootNodeIfNeeded             = $True
            RefreshFrequencyMins           = 30
            RefreshMode                    = 'PUSH'
            ReportManagers                 = @{}
            ResourceModuleManagers         = @{}
            SignatureValidations           = @{}
            StatusRetentionTimeInDays      = 10
        }
    }
}

ResetLCM -NodeName $ComputerName -OutputPath $OutputPath

Set-DscLocalConfigurationManager -Path $OutputPath -ComputerName $ComputerName