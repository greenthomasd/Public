#Server Account Creation Script
#https://technet.microsoft.com/en-us/library/ee617245.aspx

#AD Computer account names
$ServerName = "Hostname"

#OU for the AD Computer accounts to be created in
$OU = "distinguishedName Goes Here"

#AD security group for AD Computer account to be added to for classification
$ServerADGroup = "distinguishedName Goes Here"

#Description of the AD computer account
$ServerDescription = "Server Description"
 
 foreach ($ServerName in $ServerName)
 {

#Create new server account
New-ADComputer -Name $ServerName -SamAccountName $ServerName -Path $OU -Enabled $true -Description $ServerDescription -Verbose

#Add newly created server account to the corresponding server group
Add-ADGroupMember $ServerADGroup -Members "$ServerName$" -Verbose

}
