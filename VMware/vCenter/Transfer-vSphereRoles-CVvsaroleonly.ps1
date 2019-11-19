#http://www.thelowercasew.com/migrating-roles-privileges-from-an-old-vcenter-to-a-new-vcenter-using-powercli

#################################################
#
# PowerCLI Script to Transfer Roles between vCenters
# Written by BLiebowitz on 11/6/2015
#
#################################################
 
#Source vCenter
$VC1="VC1FQDN"

#Destination vCenter
$VC2 = "VC2FQDN"
 
# Set the PowerCLI Configuration to connect to multiple vCenters
Set-PowerCLIConfiguration -DefaultVIServerMode multiple -Confirm:$false
 
# Connect to both the source and destination vCenters
Connect-VIServer -server $VC1, $VC2
 
# Get roles to transfer
$roles = Get-VIRole *Role* -server $VC1
 
# Get role Privileges
foreach ($role in $roles) {
[string[]]$privsforRoleAfromVC1=Get-VIPrivilege -Role (Get-VIRole -Name $role -server $VC1) |ForEach-Object{$_.id}
 
# Create new role in VC2
New-VIRole -name $role -Server $VC2
 
# Add Privileges to new role.
Set-VIRole -role (Get-VIRole -Name $role -Server $VC2) -AddPrivilege (Get-VIPrivilege -id $privsforRoleAfromVC1 -server $VC2)
}
 
Disconnect-VIServer –server $VC1, $VC2 -Confirm:$false