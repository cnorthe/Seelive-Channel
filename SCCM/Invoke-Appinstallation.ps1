<# 
.SYNOPSIS 
   Invoke installation or uninstallation of available application on remote computer  
  
.DESCRIPTION 
  Function that will invoke an Installation or Uninstallation of specified Application in Software Center that's available for the remote computer.  
  
.PARAMETER Computername 
    Specify the remote computer you wan't to run the script against  
  
.PARAMETER AppName 
    Specify the Application you wan't to invoke an action on  
  
.PARAMETER Method 
    Specify the method or action you want to perform, Install or Uninstall 
  
.EXAMPLE 
 
    Invoke-AppInstallation -Computername SD010 -AppName "Google Chrome" -Method Install 
 
    or  
 
    Invoke-AppInstallation -Computername SD010 -AppName "Google Chrome" -Method Uninstall 
      
  
.NOTES 
    FileName:    Invoke-Appinstallation.ps1 
    Author:      Timmy Andersson 
    Contact:     @Timmyitdotcom 
    Created:     2016-08-05 
    Updated:     2017-01-08 
              
#> 
Function Invoke-AppInstallation 
{ 
[CmdletBinding()] 
Param 
( 
 
 [String][Parameter(Mandatory=$True, Position=1)] $Computername, 
 [String][Parameter(Mandatory=$True, Position=2)] $AppName, 
 [ValidateSet("Install","Uninstall")] 
 [String][Parameter(Mandatory=$True, Position=3)] $Method 
) 
  
Begin { 
$Application = (Get-CimInstance -ClassName CCM_Application -Namespace "root\ccm\clientSDK" -ComputerName $Computername | Where-Object {$_.Name -like $AppName}) 
  
$Args = @{EnforcePreference = [UINT32] 0 
Id = "$($Application.id)"
IsMachineTarget = $Application.IsMachineTarget 
IsRebootIfNeeded = $False 
Priority = 'High' 
Revision = "$($Application.Revision)" } 
  
} 
  
Process 
  
{ 
  
Invoke-CimMethod -Namespace "root\ccm\clientSDK" -ClassName CCM_Application -ComputerName $Computername -MethodName $Method -Arguments $Args 
  
} 
  
End {} 
  
}