#This script is designed to delete the Windows Update cache on remote computers. 

#This variable does work with multiple computer names by using commas to seperate the names. Example "pc1", "pc2", "pc3", etc... (Must use quotes around names)
$ComputerName = "PCNameHere"

Invoke-Command -ComputerName $ComputerName -ScriptBlock { 

#Stop Windows Update Service
Stop-Service wuauserv -Force -PassThru 

#Remove Windows Updates local cache location
Remove-Item "C:\Windows\SoftwareDistribution\*" -Recurse

#Start Windows Update Service
Start-Service wuauserv -PassThru
}