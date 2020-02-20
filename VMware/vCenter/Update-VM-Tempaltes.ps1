#Update VM Templates

#VMware.PowerCLI required
Import-Module VMware.PowerCLI

#vCenter FQDN
$vCenter = "VC.FQDN"

#Connect to vCenter through PowerCLI
Connect-VIServer $vCenter -Verbose

#This queries the vCenter for VM Templates in the *Templates -> Windows folder (Modify as needed)
$Templates = "Get-Folder *Templates | Get-Folder Windows | Get-Template"

#Create Loop
Foreach ($Template in $Templates) {

    #Convert VMtemplates to VM
    Get-Template  $Template | Set-Template -ToVM

    #Take VM Snapshot Prior to making changes
    New-Snapshot -VM $Template -Name Before-Updates

    #Increase VM Template Resources
    Set-VM $Template -NumCpu 4 -MemoryGB 8 -Confirm:$false

    #Power on VM
    Start-VM $Template 

    #Declare Windows Update PowerShell script
    #http://woshub.com/pswindowsupdate-module/
    $WindowsUpdate = "Install-WindowsUpdate -AcceptAll -Install -AutoReboot"

    #Declare Guest OS Local Creds
    $GuestUser = "administrator"
    $GuestPassword = "VM Template Password 1,"

    #Get PSWindowsUpdate PowerShell module from the PowerShell Gallery
    #https://www.powershellgallery.com/packages/PSWindowsUpdate/
    Invoke-VMScript -VM $Template -GuestUser $GuestUser -GuestPassword $GuestPassword -ScriptType Powershell -ScriptText "Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force"
    Invoke-VMScript -VM $Template -GuestUser $GuestUser -GuestPassword $GuestPassword -ScriptType Powershell -ScriptText "Install-Module -Name PSWindowsUpdate -Force"

    #Start Windows Update PowerShell module
    Invoke-VMScript -VM $Template -GuestUser $GuestUser -GuestPassword $GuestPassword -ScriptType Powershell -ScriptText $WindowsUpdate

    #Power Off VM After Updates
    Stop-VM -VM $Template -Confirm:$false

    #Reduce VM Template Resources 
    Set-VM $Template -NumCpu 1 -MemoryGB 1 -Confirm:$false

    #Convert VM back to template
    Set-VM -VM $Template -ToTemplate -Confirm:$false

}

#Disconnect from vCenter
Disconnect-VIServer $vCenter -Confirm:$false -Verbose