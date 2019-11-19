#Get-PoweredOffVMs

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to vCenter through PowerCLI
Connect-VIServer $vCenter

#VM query
Get-VM * | Where-Object -Property PowerState -EQ PoweredOff | 

#Select Properties
Select-Object -Property Name, Notes, Guest, Folder, UsedSpaceGB, VMHost | 

#Export CSV to local user's downloads directory 
Export-Csv $env:USERPROFILE\downloads\PoweredOffVMs_$($vCenter)_$((Get-Date).ToString('MM-dd-yyyy')).csv -Verbose

#Disconnect from vCenter
Disconnect-VIServer $vCenter -Confirm:$false -Verbose