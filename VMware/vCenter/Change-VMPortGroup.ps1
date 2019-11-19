#Change-VMPortGroup
#Use this script when migrating VMs from one port group to another. 
#Useful if rebuilding a VDS or creating new and migrating existing workloads. 

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to the vCenter
Connect-VIServer $vCenter -Verbose

$Cluster = "ClusterName"

#These examples get VMs on the original port group, and the reassign them to the new port group
Get-Cluster $Cluster | Get-VM | Get-NetworkAdapter | Where-Object -Property NetworkName -EQ "v172 Legacy Server Private" | Set-NetworkAdapter -Portgroup "v172 Server Private (ANET)" -Verbose -Confirm:$false

Get-Cluster $Cluster | Get-VM | Get-NetworkAdapter | Where-Object -Property NetworkName -EQ "v3 Legacy Server Public" | Set-NetworkAdapter -Portgroup "v3 Server Public (ANET)" -Verbose -Confirm:$false

Get-Cluster $Cluster | Get-VM | Get-NetworkAdapter | Where-Object -Property NetworkName -EQ "v48 Legacy Load Balancer Public" | Set-NetworkAdapter -Portgroup "v48 Load Balancer Public (ANET)" -Verbose -Confirm:$false

Get-Cluster $Cluster | Get-VM | Get-NetworkAdapter | Where-Object -Property NetworkName -EQ "v46 Legacy Load Balancer Private" | Set-NetworkAdapter -Portgroup "v46 Load Balancer Private (ANET)" -Verbose -Confirm:$false

Get-Cluster $Cluster | Get-VM | Get-NetworkAdapter | Where-Object -Property NetworkName -EQ "v49 Legacy Lab" | Set-NetworkAdapter -Portgroup "v49 LAB (ANET)" -Verbose -Confirm:$false

#Disconnect from the vCenter
Disconnect-VIServer vCenter -Verbose -Confirm:$false