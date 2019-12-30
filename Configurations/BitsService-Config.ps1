configuration Bits
{

    param
    (
        [string[]]$ComputerName='localhost'
    )
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    # One can evaluate expressions to get the node list
    # E.g: $AllNodes.Where("Role -eq Web").NodeName
    node $ComputerName
    {
        # Call Resource Provider
        # E.g: WindowsFeature, File
        Service EnableBits
        {
           Ensure = "Present"
           Name   = "Bits"
           State = "Running"
        }
    }
}

Set-Location $env:temp
Bits -ComputerName 'Testlabcl02'
#Test-DscConfiguration -Path .\Bits -Verbose
Start-DscConfiguration -Path .\Bits -Wait -Verbose



Get-Service -name bits
Get-Service -name bits | Stop-Service -PassThru