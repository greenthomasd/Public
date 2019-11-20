#Shapshot the vRealize vApp VMs.
#Useful for taking a snapshot prior to performing platform upgrades. 

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to vCenter through PowerCLI
Connect-VIServer $vCenter -Verbose

#Shutdown the VMs in the vApp
Get-VApp "vRealize*" | Stop-VApp -Force

#Query the vApp vRealize and snapshot all of the VM's at the same time. 
#These snapshot options were taken choosen because it is assumed that the VMs are in a powered off state.
Get-VApp "vRealize*" | Get-VM | New-Snapshot -Name "Pre 7.6 Upgrade" -Description "Snapshot taken prior to upgrading vRealize Automation to 7.6"

#Power on the vApp after the snapshots are created
Get-VApp "vRealize*" | Start-VApp -Verbose   

#Disconnect from vCenter
Disconnect-VIServer $vCenter -Confirm:$false -Verbose