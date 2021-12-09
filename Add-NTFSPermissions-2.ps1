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

    .PARAMETER $TargetObj
	    Specifies the Target obj security account or group to mirror the existing permissions applied to the shared folder(s).
        This is a required parameter.

    .EXAMPLE
	    Add-NTFSPermissions -Path 'C:\Data_Lab','C:\Data_Test' -ObjNames 'Test\TestGroup1','Test\TestUser1' -TargetObj 'Lab\LabGroup1'

	    This example checks to see if the security group LabGroup1 has permissions on a folder and then added TestGroup1 with the same NTFS
        Permissions.

    .INPUTS
	    None.

    .OUTPUTS
	    None.

    .NOTES
	    This is a function that can be reused.
        Created by Clive Northey 12/1/2021. Microsoft Corperation.

    .LINK
	    None.
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
        [string]
        $TargetObj
    )

    Try {
        #Get share folders and subfolders filepath
        $rootPath = [Array] (Get-Item -Path $Path)

        forEach ($item in $rootPath) {

            #Get current ACL access rule from share folders
            $acl = Get-Acl $item.FullName

            #filter for target secuirty group
            $TargetAccessRules = $Acl.Access | Where-Object { $_.IdentityReference.Value -like $TargetObj -and $_.IsInherited -eq $false }

            #Build ACL access rules from target security group
            forEach ($objName in $ObjNames) {
                $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList ($objName, $TargetAccessRules.FileSystemRights, `
                        $TargetAccessRules.InheritanceFlags, `
                        $TargetAccessRules.PropagationFlags, `
                        $TargetAccessRules.AccessControlType)

                #check if target security group exist on shared folder
                if ($TargetAccessRules.IdentityReference -eq $TargetObj) {

                    $acl.AddAccessRule($accessRule)

                    #Set ACL access rule
                    Set-Acl –path $item.FullName -AclObject $acl
                    Write-Verbose "Successfully assigned $($TargetAccessRules.FileSystemRights) access rights to $($objName) on $($item.FullName) shared folder." -Verbose
                }
                else {
                    Write-Verbose "Unable to find $($TargetObj) Permissions on $($item.FullName) shared folder" -Verbose
                }
            }
        }
    }
    catch {
        Write-Warning "Unable to assign $($TargetAccessRules.FileSystemRights) access rights to $($objName) on $($item.FullName) shared folder .$($_.Exception.message)"
    }
}
#script ends

Add-NTFSPermissions -Path $FolderPath -ObjNames 'Test\TestGroup1', 'Test\TestUser1' -TargetObj 'Lab\LabGroup1'
