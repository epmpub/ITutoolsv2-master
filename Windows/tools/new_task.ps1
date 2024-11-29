$ProgressPreference = 'SilentlyContinue'
function mylog {
  param (
    $myMessage
  )
  $guid = $(New-Guid)
  $dt = Get-Date -format "yyyy-MM-dd HH:mm:ss"

  $info = [ordered]@{}
  $info["id"] = $guid
  $info["message"] = $dt + ',' + $env:COMPUTERNAME + ',' + $myMessage

  $jsdata = $info | convertTo-Json
  $jsdata
  Invoke-RestMethod utools.run/mylog -Method Post -Body $jsdata
}

$targetDirectory = "c:\utools"

if (-not(Test-Path $targetDirectory)) {
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

# Check Update

'powershell -executionPolicy ByPass -Command "irm utools.run/update|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii 
'powershell -executionPolicy ByPass -Command "irm utools.run/hardware_inventory|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/hardware_inventory_es|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/new_svc|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append

$TaskName = "collectLogs"
Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue | Out-Null
if ($? -eq $true) {
  Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
}

$actions = New-ScheduledTaskAction -Execute 'cmd /c c:\utools\collectLogs.bat'

$TheDate = ([DateTime]::Now)
$Duration = $TheDate.AddYears(25) - $TheDate

$trigger = New-ScheduledTaskTrigger -Once -At(Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1) -RepetitionDuration $Duration
$principal = New-ScheduledTaskPrincipal -UserId 'system' -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
$task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask $TaskName -InputObject $task | Out-Null

Start-ScheduledTask -TaskName $TaskName
