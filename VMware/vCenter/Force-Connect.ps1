#Force-Connect
#This script is useful when having to rebuild/restore a vCenter, and the hosts don't automatically reconnect.

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to vCenter through PowerCLI
Connect-VIServer $vCenter -Verbose #-Credential $Creds

Get-VMHost -state Disconnected | foreach-object {
  $vmhost = $_
  $connectSpec = New-Object VMware.Vim.HostConnectSpec
  $connectSpec.force = $true
  $connectSpec.hostName = $vmhost.name
  $connectSpec.userName = 'root'
  $connectSpec.password = 'ESXiHostRootPasswordGoesHere'
  $vmhost.extensionData.ReconnectHost_Task($connectSpec, $null)
}

Disconnect-VIServer $vCenter 