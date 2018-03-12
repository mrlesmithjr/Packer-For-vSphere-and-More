# Check to make sure if PowerCLI module is installed
if ((Get-InstalledModule -Name VMware.PowerCLI -ErrorAction SilentlyContinue) -eq $null) {
  Install-Module -Name VMware.PowerCLI -Scope CurrentUser | Out-Null
}

# Disable invalid cert checking
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -confirm:$false | Out-Null

# Disable participation in CEIP
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -confirm:$false | Out-Null

# Define vCenter info
$vCenterServerHost = "10.0.102.60"
$vCenterUsername = "administrator@vsphere.local"
$vCenterPassword = "VMw@re1!"

## Connect to vCenter
Connect-VIServer $vCenterServerHost -User $vCenterUsername -Password $vCenterPassword | Out-Null

Get-VMHost | Get-AdvancedSetting -Name Net.GuestIPHack | Set-AdvancedSetting -Value 1 -Confirm:$false

# Ensure ESXi hosts have SSH enabled
Get-VMHost | Get-VMHostService | Where-Object {$_.Key -eq "TSM-SSH"} | Start-VMHostService -Confirm:$false

# This is required to allow VNC
Get-VMHost | Get-VMHostFirewallException -Name "gdbserver" | Set-VMHostFirewallException -Enabled:$true

# Disconnect from vCenter
Disconnect-VIServer * -Confirm:$false
