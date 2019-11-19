$computers = "PCName"

Invoke-Command -ComputerName $computers -ScriptBlock {

Get-WmiObject -Class win32_product -Filter "Name like 'Dell OpenManage'" | ForEach-Object { $_.Uninstall()}
}