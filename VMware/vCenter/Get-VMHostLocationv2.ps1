#Get-VMHostlocation
#This will return a list of VMs with their host locations for a specific cluster, then export the output to the current user's Downloads directory

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to the vCenter
Connect-VIServer $vCenter -Verbose

#Specify which cluster
#$ClusterName = WhichCluster

#Get all VMs from the cluster with selected properties, then export the output to a CSV in the current user's downloads directory. 
#Get-Cluster $ClusterName | 
Get-VM * | Select-Object -Property Name, PowerState, NumCPU, MemoryGB, VMhost | Export-Csv $env:userprofile\downloads\Get-VMHostLocation_$((Get-Date).ToString('MM-dd-yyyy')).csv -Verbose

#Completion Notification 
Write-Host "Script completed successfully, please check " $env:userprofile\downloads "for Get-VMHostLocation.csv Thanks!" -ForegroundColor Green

#Disconnect
Disconnect-VIServer -Verbose -Confirm:$false