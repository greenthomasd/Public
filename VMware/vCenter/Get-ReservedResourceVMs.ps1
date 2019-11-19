#Get Reservered Resources
#Reference: https://deangrant.wordpress.com/2014/04/24/powercli-retrieve-vms-where-cpu-or-memory-reservation-has-been-enabled/

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to vCenter
Connect-VIServer $vCenter -Verbos

#Get all VMs in the vCenter, define what parameters to query
$VMs = Get-VM * | Where-Object {$_.ExtensionData.ResourceConfig.MemoryAllocation.Reservation -ne "0" -or $_.ExtensionData.ResourceConfig.CpuAllocation.Reservation -ne "0"}

#Run Query
ForEach ($VM in $VMs)
    { 
        "" | Select-Object @{N="Name";E={$VM.Name}},
        @{N="CPU Reservation";E={$VM.ExtensionData.ResourceConfig.CpuAllocation.Reservation}},
        @{N="Memory Reservation";E={$VM.ExtensionData.ResourceConfig.MemoryAllocation.Reservation }} 
    } 

#Disconnect from vCenter
Disconnect-VIServer $vCenter -Verbose -Confirm:$false