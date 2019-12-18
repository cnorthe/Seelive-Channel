<#
.Synopsis
   Script to Copy PowerSTIG & Dsc Modules
.DESCRIPTION
   This script recursively copy the entire contents of Modules folder to remote test computers
.PARAMETER ComputerName
    The target computer prepared to receive modules
.PARAMETER Source
    Modules source location
.PARAMETER Destination
    Target computer module directory
.EXAMPLE
   Copy-Module -ComputerName 'WKS01' -Source 'C:\temp\Modules\*' -Destination 'C:\Program Files\WindowsPowerShell\Modules'
#>

function Copy-Module
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string[]]
        $ComputerName,

        [Parameter(Mandatory)]
        [string]
        $Source,

        [Parameter(Mandatory)]
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [string]
        $Destination
    )

    Begin
    {
        $ComputerNames = $ComputerName
    }
    Process
    {
        ForEach ($ComputerName in $ComputerNames)
        {
            if (Test-Connection -ComputerName $ComputerName -Count 1)
            {
                $Session = New-PSSession -ComputerName $ComputerName -ErrorAction 'Continue'
                Copy-Item -Path $Source -Destination $Destination -ToSession $Session -Recurse -Force
                Write-Verbose -Message "Modules copied successfully on $ComputerName"
            }
            else {
                Write-Verbose -Message  "Fail to copy modules on $ComputerName"
            }
        }
    }
    End
    {
    }
}
