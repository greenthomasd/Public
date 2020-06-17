#Count members in an AD group

#Reference https://www.thisprogrammingthing.com/2012/get-the-count-of-the-number-of-users-in-an-ad-group/

(get-aduser -filter { memberof -recursivematch "CN=Group,OU=Users,DC=contoso,DC=local" }).count