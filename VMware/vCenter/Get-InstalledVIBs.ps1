#Get-InstalledVIBs

# https://www.shogan.co.uk/vmware/finding-a-vendor-specific-vib-on-an-esxi-host-with-powercli/

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to vCenter
Connect-VIServer $vCenter -Verbose

$AllHosts = Get-VMHost | Where-Object {$_.ConnectionState -eq “Connected”}

foreach ($VMHost in $AllHosts) {

    $ESXCLI = Get-EsxCli -VMHost $VMHost

    $ESXCLI.software.vib.list() | Select-Object AcceptanceLevel, ID, InstallDate, Name, ReleaseDate, Status, Vendor, Version #| Where-Object {$_.Vendor -match “dell”}

}

#Disconnect from vCenter
Disconnect-VIServer $vCenter -Verbose -Confirm:$false