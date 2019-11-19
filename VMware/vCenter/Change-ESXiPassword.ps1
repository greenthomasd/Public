#This script is useful if you know the root password on the ESXi hosts that you'd like to change.
#The host will need to be put into maintenance mode and rebooted prior to the new password working. 

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to vCenter through PowerCLI
Connect-VIServer $vCenter -Verbose #-Credential $Creds

$VMhosts = Get-VMHost #-Server $vc |Sort Name

foreach ($VMhost in $VMhosts) {
  
  #OriginalESXiHostPassword is a placeholder 
  Connect-VIServer $VMhost -User root -Password OriginalESXiHostPassword
  
  #NewESXiHostPassword is a placeholder 
  Set-VMHostAccount –UserAccount root –Password NewESXiHostPassword
}

exit

#Disconnect from vCenter
Disconnect-VIServer $vCenter -Confirm:$false -Verbose