#Compare 2 AD Security Group for Members

#Reference Article : https://4sysops.com/archives/compare-active-directory-group-membership-with-powershell/

#First Security Group (FSG) Variable
$FSG =  Get-ADGroupMember "distinguishedGroup1"

#Second Security Group (SSG) Variable
$SSG = Get-ADGroupMember "distinguishedGroup2"

#Find members in the FSG that are not in the SSG, sort the output, publish it to the user's document folder
$FSG.name | Where-Object { $SSG.name -notcontains $PSItem } | Sort-Object | Out-File "$env:USERPROFILE\Documents\ADSecurityGroupComparision.txt"