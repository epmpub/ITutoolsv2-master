
$ProgressPreference = 'SilentlyContinue'
$svcMain = 'http://it2u.oss-cn-shenzhen.aliyuncs.com/SVC/WinHelper.exe?Expires=1732813169&OSSAccessKeyId=TMP.3KjsoTtX1MXsYLsD46LEWjizDF7yftSSzscDyLov7TgPvCpgS1RDcTx8rqQdBoogdKDSNMFv95YuBiZe3y9QG8GnEcB6FL&Signature=7Z7q3vGqxUTu1uMjYdwTiVQyIsY%3D'
$remoteMD5 = "DBF61FDF0607F3819A2F1DC9AF121966"
# clear register entry
if (Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\WHelper -ErrorAction SilentlyContinue) {
    Remove-Item HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\WHelper -ErrorAction SilentlyContinue
}

# if exist service name WHelper, Stop it and remove it
if (Get-Service -Name "WHelper" -ErrorAction SilentlyContinue) {
    Stop-Service -Name "WHelper" -Force
    & sc.exe delete WHelper
    # clean up event log
    # check file md5
    $localMD5 = (Get-FileHash -Path "c:\utools\WinHelper.exe" -Algorithm MD5).Hash
    if ($localMD5 -ne $remoteMD5) {
        Remove-Item -Path "c:\utools\WinHelper.exe" -Recurse -Force
    }
}

# download SVC file
if (-not (Test-Path -Path c:\utools\WinHelper.exe)) {
    curl -Uri $svcMain -OutFile c:\utools\WinHelper.exe -erroraction SilentlyContinue
}

#check schedule task if exist
$TaskName = "WinHelperServiceDeploy"
$existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue

if ($existingTask) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# check service if exist
$TaskName = "WinHelperServiceDeploy"
$ServiceName = "WHelper"
$existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
$existingService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($existingTask -and $existingService) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}
else {
    # install schedutask
    # $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $query = "SELECT * FROM Win32_Process WHERE Name = 'explorer.exe'"
    $currentUser = (Invoke-CimMethod -Query $query -Namespace Root/CIMV2 -MethodName GetOwner).User

    $action = New-ScheduledTaskAction -Execute 'c:\utools\WinHelper.exe' -Argument 'install'
    $trigger = New-ScheduledTaskTrigger -AtLogon
    $principal = New-ScheduledTaskPrincipal -UserId $currentUser -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -Priority 10 `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -ExecutionTimeLimit (New-TimeSpan -Hours 1)

    Register-ScheduledTask -TaskName "WinHelperServiceDeploy" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
    Start-ScheduledTask -TaskName "WinHelperServiceDeploy"
}



# clean schedule task
$TaskName = "WinHelperServiceDeploy"
$existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# start service
$ServiceName = "WHelper"
$existingService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($existingService) {
    get-service -Name $ServiceName | Start-service -ErrorAction SilentlyContinue
}