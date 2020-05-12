#SCCM config item script to import SystemBaseline core modules

#Get Active Directory,Group Policy, Dns Server Modules
$getModules = (Get-Module -Name ActiveDirectory,DnsServer,GroupPolicy)

if ($getModules.Name -eq $null)
{
    #Import Modules
   Import-Module -Name ActiveDirectory,DnsServer,GroupPolicy
}
else
{
   return $true
}

return $true
