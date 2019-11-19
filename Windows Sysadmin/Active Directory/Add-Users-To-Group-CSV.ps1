#Source URL : https://emeneye.wordpress.com/2014/07/09/adding-multiple-users-to-a-group-in-active-directory-using-powershell-and-csv/

# Import active directory module for running AD cmdlets
Import-module ActiveDirectory

#Store the data from UserList.csv in the $List variable
$List = Import-CSV .\UserList.csv

#Loop through user in the CSV
ForEach ($User in $List)
{

#Add the user to the TestGroup1 group in AD
Add-ADGroupMember -Identity TestGroup1 -Member $User.username
}