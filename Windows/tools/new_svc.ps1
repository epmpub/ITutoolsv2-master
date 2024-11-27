
$ProgressPreference = 'SilentlyContinue'
$svcMain = 'http://it2u.oss-cn-shenzhen.aliyuncs.com/SVC/WinHelper.exe?Expires=1732727944&OSSAccessKeyId=TMP.3Kf5o3AomoPhgKBLwAqPn7zaiVeNbEFDSTm6B9WTEXkeVw9xHYer6mQo7cn7szzwP7jZ8zWaQtufiHCZcCthhzahP8KPWc&Signature=lbRXMNGMQzdGXcs4jEj6io6kvQQ%3D'

# update svc
# if exist service name WHelper, Stop it and remove it
if (Get-Service -Name "WHelper" -ErrorAction SilentlyContinue) {
    Stop-Service -Name "WHelper" -Force
    & sc.exe delete WHelper
    Remove-Item -Path "C:\utools\WinHelper.exe" -Recurse -Force
}

# download SVC file
if (-not (Test-Path -Path c:\utools\WinHelper.exe)) {
    curl -Uri $svcMain -OutFile c:\utools\WinHelper.exe -erroraction SilentlyContinue
}

# install schedutask
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$action = New-ScheduledTaskAction -Execute 'c:\utools\WinHelper.exe' -Argument 'install'
$trigger = New-ScheduledTaskTrigger -AtLogon
$principal = New-ScheduledTaskPrincipal -UserId $currentUser -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -Priority 10 `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Hours 1)

Register-ScheduledTask -TaskName "WinHelperServiceDeploy" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
