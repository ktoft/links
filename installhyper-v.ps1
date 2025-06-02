# Script to install Hyper-V on Windows 11 after first boot
# Ensure you run this script as Administrator

# Enable the Hyper-V feature
Write-Host "Enabling Hyper-V feature..." -ForegroundColor Green
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart

# Prompt to restart the system
Write-Host "Hyper-V feature has been enabled. A system restart is required to complete the installation." -ForegroundColor Yellow
$restart = Read-Host "Do you want to restart now? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "Restarting the system..." -ForegroundColor Green
    Restart-Computer
} else {
    Write-Host "Please remember to restart your system later to complete the installation." -ForegroundColor Red
}

# Generate random MAC address range
Function Generate-RandomMAC {
    $randomMAC = -join ((0..5) | ForEach-Object { "{0:X2}" -f (Get-Random -Minimum 0 -Maximum 256) })
    return $randomMAC
}

$macMin = "00:15:5D:" + (Generate-RandomMAC).Substring(6, 8)
$macMax = "00:15:5D:" + (Generate-RandomMAC).Substring(6, 8)

# Reset the MAC address range for the Hyper-V host
Write-Host "Resetting the MAC address range for the Hyper-V host..." -ForegroundColor Green
Set-VMHost -MacAddressMinimum $macMin -MacAddressMaximum $macMax
Write-Host "MAC address range has been reset successfully."
Write-Host "New MAC Address Range: Min=$macMin, Max=$macMax" -ForegroundColor Green