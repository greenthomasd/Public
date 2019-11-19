#Show the available drive space on the CommVault Infrastrucure Servers

$CommVaultServers = Get-ADGroupMember "Distinguished Name of CommVault Computer Security Group"

foreach ($CommVaultServers in $CommVaultServers){ 
Get-PSDrive 
}

#Invoke-Command -ComputerName $CommVaultServers -ScriptBlock {
#Get-PSDrive | Format-Table -GroupBy PSComputerName
#}
