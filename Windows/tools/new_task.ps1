$ProgressPreference = 'SilentlyContinue'
function mylog {
  param (
      $myMessage
  )
  $guid = $(New-Guid)
  $dt = Get-Date -format "yyyy-MM-dd HH:mm:ss"

  $info = [ordered]@{}
  $info["id"]= $guid
  $info["message"]=$dt+','+$env:COMPUTERNAME+','+$myMessage

  $jsdata=$info | convertTo-Json
  $jsdata
  Invoke-RestMethod utools.run/mylog -Method Post -Body $jsdata
}

# call API to install sysmon tools

Invoke-RestMethod utools.run/sysmon|Invoke-Expression

$targetDirectory = "c:\utools"

if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

# Check Update

'powershell -executionPolicy ByPass -Command "irm utools.run/update|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii 
'powershell -executionPolicy ByPass -Command "irm utools.run/hardware_inventory|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/tcpvcon|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/autorun|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/1|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/3|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/5|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/11|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append

# 'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/12|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append

'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/22|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/27|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/app_sys_sec|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append

$TaskName = "collectLogs"
Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue | Out-Null
if ($? -eq $true)
{
    Write-Host "Task $TaskName already exist.try to  Unregister."
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
}

$actions = New-ScheduledTaskAction -Execute 'cmd /c c:\utools\collectLogs.bat'

$TheDate= ([DateTime]::Now)
$Duration = $TheDate.AddYears(25) -$TheDate

$trigger = New-ScheduledTaskTrigger -Once -At(Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration $Duration
$principal = New-ScheduledTaskPrincipal -UserId 'system' -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
$task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask $TaskName -InputObject $task | Out-Null

mylog("registe OK.")

Start-ScheduledTask -TaskName collectLogs
