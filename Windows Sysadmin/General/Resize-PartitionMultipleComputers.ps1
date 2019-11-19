#https://blogs.technet.microsoft.com/heyscriptingguy/2013/09/02/powertip-use-powershell-3-0-to-resize-partitions/

#Make sure to change the drive letter variable on line 13 to the correct drive letter. 

#Remote Computer to execute the cmdlets in the -ScriptBlock section
$Computers = "PC1", "PC2", "ETC"

#foreach ($Computer in $Computers){

Invoke-Command -ComputerName $Computers -ScriptBlock {

#Drive letter only, do not put "C:\" only "C" or whatever drive letter. 
$DriveLetter = "C"

#Diskpart cmd to rescan all drives on remote computer
"rescan" | diskpart

#Get the maximum size for the specified drive letter
$MaxSize = (Get-PartitionSupportedSize -DriveLetter $DriveLetter).sizeMax

#Resize the partition to the largest available size, defined by the cmdlet on line 17
Resize-Partition -DriveLetter $DriveLetter -Size $MaxSize

}
#}