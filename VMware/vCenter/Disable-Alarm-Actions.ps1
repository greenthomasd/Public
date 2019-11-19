#Disable-Alarm-Actions
#Disable alarms 

#Reference
#https://communities.vmware.com/thread/317445

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to vCenter through PowerCLI
Connect-VIServer $vCenter -Verbose #-Credential $Creds

#Define objects to disable alarms on
$alarmMgr = Get-View AlarmManager 

$servers = Get-Cluster "ClusterName" | Get-VMHost *

foreach ($server in $servers) {

    # To disable alarm actions 
    $alarmMgr.EnableAlarmActions($server.Extensiondata.MoRef,$false)

}

#Disconnect from vCenter
Disconnect-VIServer $vCenter -Confirm:$false -Verbose