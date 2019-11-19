#Enable Alarm-Actions
#Enable alarms 

#Reference
#https://communities.vmware.com/thread/317445

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to vCenter through PowerCLI
Connect-VIServer $vCenter -Verbose #-Credential $Creds

#Define objects to enable alarms on
$alarmMgr = Get-View AlarmManager 

$servers = Get-Cluster "ClusterName" | Get-VMHost *

foreach ($server in $servers) {

    # To enable alarm actions 
    $alarmMgr.EnableAlarmActions($server.Extensiondata.MoRef, $true)

}
#Disconnect from vCenter
Disconnect-VIServer $vCenter -Confirm:$false -Verbose