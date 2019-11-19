#This script will install Windows Roles and Features to multiple servers at the same time. 

#This variable does work with multiple computer names by using commas to seperate the names. Example "pc1", "pc2", "pc3", etc... (Must use quotes around names)
$Computers = "PC1","PC2"

#This is the location of the Windows side by side install files for Windows Server 2012r2. 
$Source = "\\FileServerFQDN\Server 2012r2\sources\sxs"

#This is the list of features you want installed, must be entered as one string with one single line of quotes ie... "telnet-client,RSAT-SNMP"
$Features = "NET-Framework-Features" , "telnet-server" , "telnet-client" , "PowerShellRoot" , "Desktop-Experience" , "EnhancedStorage"

ForEach ($Computer in $Computers) {

Install-WindowsFeature  $Features -ComputerName $Computer -IncludeAllSubFeature -Source $Source -Restart

}

