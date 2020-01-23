#############################################################################
# Authored by: John Rayborn
#
# Version : 1.0
# Created : 10 DEC 2019
# Modified :
#
# Purpose : This script installs the SCAP Extensions for the SCCM console.
#
#
#############################################################################

$File="E:\Source\ConfigMgrSCAPExtension\COnfigMgrExtensionsForSCAP.msi"
$DataStamp = Get-Date -Format yyyyMMddTHHmmss
$LogFile = '{0}-{1}.log' -f $File.fullname,$DataStamp
$MSIArguments = @(
    "/i"
    ('"{0}"' -f $File.fullname)
    "/qn"
    "/norestart"
    "/L*v"
    $LogFile
)
Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow