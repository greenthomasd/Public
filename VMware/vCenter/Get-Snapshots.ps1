#Get-Snapshots

#vCenter FQDN
$vCenter = "vCenterFQDN"

#Credentials
#$Creds = New-Object System.Management.Automation.PSCredential (($env:USERNAME+"@"+$env:USERDNSDOMAIN), (Read-Host ($env:USERNAME+"@"+$env:USERDNSDOMAIN)"Password" -AsSecureString))

#Connect to vCenter through PowerCLI
Connect-VIServer $vCenter -Verbose #-Credential $Creds

#Snapshot Query
Get-VM * | Get-Snapshot -Verbose | 

#Select Output
Select-Object -Property VM, Name, Description, Created, PowerState, SizeGB, IsCurrent, IsReplaySupported, Quiesced |

#Export CSV to local user's Documents directory
Export-Csv $env:USERPROFILE\Documents\Get-Snapshots_$($vCenter)_$((Get-Date).ToString('MM-dd-yyyy')).csv -Verbose

#Disconnect from vCenter
Disconnect-VIServer $vCenter -Confirm:$false -Verbose