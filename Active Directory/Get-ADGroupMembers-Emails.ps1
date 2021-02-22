#Get User names and email addresses for members of an Active Directory Security Group

#Define AD Group to query
Get-ADGroupMember "ADGroupGoesHere" | 

#Get AD User information
Get-ADUser -Properties mail | 

#Select object properties
Select-Object -Property name, mail | 

#Export to CSV
Export-Csv -Path $env:USERPROFILE\downloads\Downloads\ADGroupMembersEmail_$((Get-Date).ToString('MM-dd-yyyy')).csv