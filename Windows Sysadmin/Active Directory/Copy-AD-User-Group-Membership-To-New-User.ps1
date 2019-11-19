#Reference URL: http://mikefrobbins.com/2014/01/30/add-an-active-directory-user-to-the-same-groups-as-another-user-with-powershell/

# The $SourceUser variable is the UPN of the user that you want to copy the group memberships from:
$SourceUser = "soureupn" #UPNGoesHere

# The $DestinationUser variable is the UPN of the user that you want to copy the group memberships to:
$DestinationUser = "destinationupn" #UPNGoesHere

#Import the Active Directory PowerShell Module
Import-Module ActiveDirectory

#Get Groups of the user you want to copy stuff from
Get-ADUser -Identity $SourceUser -Properties memberof |

#Show Groups user is apart of
Select-Object -ExpandProperty memberof |

#Get user to copy groups to, -PassThru to show what is being copied
Add-ADGroupMember -Members $DestinationUser -PassThru | 

#Shows the groups that were copied to the destination account
Select-Object -Property SamAccountName