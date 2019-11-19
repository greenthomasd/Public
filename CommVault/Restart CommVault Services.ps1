#Remotely Restart CommVault Services on CommVault Media Agents

$CommVaultServers = Get-ADGroupMember "Distinguished Name of CommVault Media Agent Security Group"

foreach ($CommVaultServer in $CommVaultServers) {

    Invoke-Command -ComputerName $CommVaultServer -ScriptBlock { Get-Service gx* | Where-Object Status -EQ "running" | Restart-Service -Force -PassThru }
}