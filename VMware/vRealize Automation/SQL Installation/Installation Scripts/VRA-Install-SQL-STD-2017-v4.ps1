#VRA-Install-SQL-2017-Standard

#Reference: https://be-virtual.net/vrealize-automation-sql-database-installation/

##### Files required
# - Microsoft SQL Server Installation File
# - Microsoft SQL Server Slipstream Installation File
# - Microsoft SQL Management Studio Installation File
# - CommVault Customized Software Package

#Declare Secure Credentials for network file access
#Service Account needs "Remote Management Users" & "WinRMRemoteWMIUsers_" rights on the remote file server
$UserName = "FQDN-Service-Account"
$Password = "PasswordGoesHere"
$SecureStringPwd = $Password | ConvertTo-SecureString -AsPlainText -Force 
$Creds = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecureStringPwd

#Create Temp Directories for installation files on the newly created VM
New-Item C:\Temp -ItemType Directory
New-Item C:\Temp\SSMS -ItemType Directory

#Create SQL Temp Directory on the newly created VM
New-Item T:\MSSQL14.MSSQLSERVER\MSSQL\DATA -ItemType Directory

#Create SQL Log Directory on the newly created VM
New-Item L:\MSSQL14.MSSQLSERVER\MSSQL\Data -ItemType Directory

#Copy SQL Installation Files from File Server w/Installation Media
#Path for files is the local path on the File Server, not the UNC path
#File Server needs WMF 5.1 installed
#Service Account needs read rights to these files
$SQLSession = New-PSSession -ComputerName "MediaServerFQDN" -Credential $Creds
Copy-Item "E:\SQL_Image\2017\StandardPerCore" -Destination "C:\Temp\" -FromSession $SQLSession -Recurse -Verbose

#Choose if you want SSMS to match the SQL version installed, or download the latest version from Microsoft. This example matches SSMS to the installed SQL Installation

#Copy SQL SSMS that matches SQL Engine on the newly created VM
Copy-Item D:\SQLTool\SQL2017Tools\SSMS_17.19.1-Setup-ENU.exe -Destination "C:\Temp\SSMS" -FromSession $SQLSession -Recurse -Verbose

#Download the latest SQL Management Studio Installation Files Directly from Microsoft
#Invoke-WebRequest "https://go.microsoft.com/fwlink/?linkid=2043154&clcid=0x409" -OutFile C:\Temp\SSMS\SSMS-Setup-ENU.exe -Credential $Creds

#Copy SQL Slipstream Files
#Copy-Item "E:\Server\Service Packs\MS SQL Server\SQL2017\SlipPatch" -Destination "C:\Temp\" -FromSession $SQLSession -Recurse -Verbose 
Copy-Item "E:\Server\Service Packs\MS SQL Server\SQL2017\CU17\SlipPatch" -Destination "C:\Temp\" -FromSession $SQLSession -Recurse -Verbose 

#Copy SQL 2017 DLT Configuration File
Copy-Item "E:\SQL_Image\2017\SQL17_DLT_ConfigurationFile_VRA.ini" -Destination "C:\Temp\" -FromSession $SQLSession -Recurse -Verbose

##### Install Microsoft SQL Management Studio
C:\Temp\SSMS\SSMS_17.19.1-Setup-ENU.exe /install /passive /norestart

##### Microsoft SQL Server 2017 Standard
C:\Temp\StandardPerCore\setup.exe /ConfigurationFile="C:\Temp\SQL17_DLT_ConfigurationFile_VRA.ini"

#Install CommVault
#Reference: https://documentation.commvault.com/commvault/v11/article?p=2042.htm

#Copy CommVault Backup Agent Install Package
New-Item C:\Temp\CV -ItemType Directory
$CVSession = New-PSSession -ComputerName CommServeFQDN -Credential $Creds
Copy-Item "D:\SQL-Agent-SP15" -Destination "C:\Temp\CV" -FromSession $CVSession -Recurse -Verbose

#Install CommVault Backup Agent
C:\Temp\CV\SQL-Agent-SP15\Setup.exe C:\Temp\CV\SQL-Agent-SP15\install.xml /silent

#Give CV Agent Installation Time to Finish so files can be removed
Start-Sleep 300

#Notify CommVault Administrators about new SQL installation
$hostname = (Hostname)
$emailTo = "CVadmin@corp.org" #use , to separate addresses
$emailFrom = "vRealize@corp.org"
$subject = "New SQL VM Installation Needs Backup"
$message = "New VM Creation with SQL DB. Please add " + $hostname + " to CommVault Backups."
$smtpserver = "webmail.corp.org"
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($emailFrom, $emailTo, $subject, $message) #This line sends the email

#Remove Installation Files
Remove-Item C:\Temp -Recurse -Force

#End Script
Exit