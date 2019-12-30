configuration DscSmb
{
    param (
        [string[]]$ComputerName = 'localhost'
    )

    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xSmbShare
    Import-DscResource -ModuleName cNtfsAccessControl
  
    node $ComputerName
    {
    
        WindowsFeature DSCServiceFeature
        {
            Ensure = 'Present'
            Name = 'DSC-Service'
        }

        xSmbShare CreateShare
        {
           Ensure = 'Present'
           Name   = 'DscSmbShare'
           Path = 'c:\DscSmbShare'
           FullAccess = 'Contoso\labdomainadmin'
           ReadAccess = 'Contoso\DscNodes'
           FolderEnumerationMode = 'AccessBased'
           DependsOn = '[File]CreateFolder'
        }

        cNtfsPermissionEntry PermissionSet1
        {
            Ensure = 'Present'
            Path = 'c:\DscSmbShare'
            Principal = 'Contoso\labdomainadmin'
            AccessControlInformation = @(
                cNtfsAccessControlInformation
                {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'Modify'
                    Inheritance = 'ThisFolderSubfoldersAndFiles'
                    NoPropagateInherit = $false
                }
            )
            DependsOn = '[File]CreateFolder'
        }

        cNtfsPermissionEntry PermissionSet2
        {
            Ensure = 'Present'
            Path = 'c:\DscSmbShare'
            Principal = 'Contoso\DscNodes'
            AccessControlInformation = @(
                cNtfsAccessControlInformation
                {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'ReadAndExecute'
                    Inheritance = 'ThisFolderSubfoldersAndFiles'
                    NoPropagateInherit = $false
                }
            )
            DependsOn = '[File]CreateFolder'
        }

        File CreateFolder
        {
            Ensure          = 'Present'
            DestinationPath = 'c:\DscSmbShare'
            Type            = 'Directory'
        }       
    }
}

Set-Location -Path $env:Temp
DscSmb
Start-DscConfiguration -Path .\DscSmb -Verbose -Wait -Force