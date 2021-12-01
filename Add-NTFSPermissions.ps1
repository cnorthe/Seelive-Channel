<#
    .SYNOPSIS
	    PS function to add NTFS security permissions to a shared folders.

    .DESCRIPTION
	    PS function to add NTFS security permissions to shared folders. The function invokes domain users and security groups
        NTFS security permissions to shared folders.

    .PARAMETER Path
	    Specifies the root path(s) of the shared folder(s). The path can be a local folder or a network based folder.
        This is a required parameter. Do not end the path with a trailing slash. A slash at the end will cause an error!

    .PARAMETER ObjNames
	    Specifies the name(s) of the domain users or groups to add NTFS security permissions.
        This is a required parameter and accepts multiple strings. Type the full 'domain\username' or 'domain\groupname'

    .PARAMETER AccessRights
	    Specifies the access rights permission that will be applied to the shared folder(s).
        This is a required parameter.

    .EXAMPLE
	    Add-NTFSPermissions -Path 'C:\Data_Lab','C:\Data_Test' -ObjNames 'Test\TestGroup1','Test\TestUser1' -AccessRights FullControl

	    This example adds 'FullControl' access right permission for a test group and test user account on two shared folders.

    .INPUTS
	    None.

    .OUTPUTS
	    None.

    .NOTES
	    This is a function that can be reused.
        Created by Clive Northey 12/1/2021. Microsoft Corperation.

    .LINK
	    https://github.com/cnorthe/Seelive-Channel/blob/master/Add-NTFSPermissions.ps1
#>

function Add-NTFSPermissions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path -Path $_ })]
        [string[]]
        $Path,

        [Parameter(Mandatory = $true)]
        [string[]]
        $ObjNames,

        [Parameter(Mandatory = $true)]
        [ValidateSet('FullControl', 'Read', 'Write', 'ReadAndExecute', 'Modify')]
        [string]
        $AccessRights
    )

    Try {
        #Get share folders and subfolders filepath
        $rootPath = [Array] (Get-Item -Path $Path)

        forEach ($item in $rootPath) {
            #Create ACL access rules
            $fileSystemAccessRights = [System.Security.AccessControl.FileSystemRights]($AccessRights)
            $inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]('ContainerInherit, ObjectInherit')
            $propagationFlags = [System.Security.AccessControl.PropagationFlags]('None')
            $accessControl = [System.Security.AccessControl.AccessControlType]('Allow')

            #Build ACL access rules from parameters
            forEach ($objName in $ObjNames) {
                $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList ($objName, $fileSystemAccessRights, $inheritanceFlags, $propagationFlags, $accessControl)

                #Get current ACL access rule from share folders
                $acl = Get-Acl $item.FullName

                $acl.AddAccessRule($accessRule)

                #Set ACL access rule
                Set-Acl –path $item.FullName -AclObject $acl
                Write-Verbose "Successfully assigned $($AccessRights) access rights to $($objName) on $($item.FullName) share folder." -Verbose
            }
        }
    }
    catch {
        Write-Warning "Unable to assign $($AccessRights) access rights to $($objName) on $($item.FullName) share folder .$($_.Exception.message)"
    }
}
