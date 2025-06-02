# Run Windows Update and force install updates
Install-Module PSWindowsUpdate -Force -Scope CurrentUser

Import-Module PSWindowsUpdate

# Get all available updates
$updates = Get-WindowsUpdate

# Install all available updates
Install-WindowsUpdate -AcceptAll -AutoReboot


# Schedule the script to run at logon
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File `"$($MyInvocation.MyCommand.Path)`""
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
Register-ScheduledTask -TaskName "RunWindowsUpdateAtLogon" -Action $action -Trigger $trigger -Principal $principal
# Schedule another script to run at logon
$action2 = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File `"C:\script\updateapps.ps1`""
$trigger2 = New-ScheduledTaskTrigger -AtLogOn
$principal2 = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
Register-ScheduledTask -TaskName "RunUpdateAppsAtLogon" -Action $action2 -Trigger $trigger2 -Principal $principal2