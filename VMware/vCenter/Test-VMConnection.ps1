#Test-VMNetwork

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Connect to vCenter
Connect-VIServer $vCenter -Verbose

$Cluster = "ClusterName"

$VMs = Get-Cluster $Cluster | Get-VM * | Where-Object -Property PowerState -EQ PoweredOn | Select-Object -Property name, @{Name = 'DNSHostname'; Expression = { $_.guest.hostname } } | Select-Object -Property DNSHostName

ForEach ($VM in $VMs) {
    if (  Test-Connection -ComputerName $VM.DNSHostname -Count 1 ) { 
        New-Object -TypeName PSCustomObject -Property @{
            ServerName    = $VM.DNSHostname
            'Ping Status' = 'Ok'
        }

    } 
       
    else 
    {
            
        New-Object -TypeName PSCustomObject -Property @{
            ServerName    = $VM.DNSHostname
            'Ping Status' = 'Failed'
        }
            
    }
}

#Disconnect from vCenter
Disconnect-VIServer $vCenter -Verbose -Confirm:$false