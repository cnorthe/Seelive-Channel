#CM client install logon script

## Set the current working directory to ensure when calling files from the
## current directory that the full path is used
$MyInvocation.MyCommand.Path | Split-Path -Parent

#Source location for CM Client install files.
$source = "\\testlabcl01\SoftwareLib\Client"

#Silently start CM Client install.
Start-Process  $source\ccmsetup.exe -ArgumentList "`"/mp:testlabdpmp01.contoso.com`" /logon SMSSITECODE=AUTO" -Wait -NoNewWindow