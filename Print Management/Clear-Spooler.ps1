#PrintServer has a dependency on the print spooler service, you must stop the PaperCut Print Provider service (PCPrintProvider) before stopping the spooler service, and after the Print Spooler service starts. 
$Computer = "PrintServerFQDN"

Invoke-Command -ComputerName $Computer -ScriptBlock {

#Stop the PaperCut Print Provider service
get-service PCPrintProvider | Stop-Service -force

#Stop the Spooler service
get-service Spooler | Stop-Service -force

#Delete the files from the Spooler cache
remove-item C:\Windows\system32\spool\Printers\* -recurse

#Start the Spooler Service
get-service Spooler | Start-Service

#Start the PaperCut Print Provider service
get-service PCPrintProvider | Start-Service

}
