#Deletes OST files in the user writable volumes on NP VDI desktops
powershell -command & { Remove-Item -Path C:\snapvolumestemp\writable\UEM\OST\* -Include *.ost }