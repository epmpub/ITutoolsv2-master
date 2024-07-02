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
'powershell -executionPolicy ByPass -Command "irm utools.run/hardware_inventory_win7|iex"' | out-file c:\utools\collectLogs.bat -Encoding ascii -Append

# Define task parameters
$taskName = "collectLogs"
$taskTime = "06:00"

# Create the scheduled task
schtasks /create /tn $taskName /tr "cmd /c c:\utools\collectLogs.bat" /sc minute /mo 15  /RU "system" /st $taskTime /f

# Verify the task creation
schtasks /query /tn $taskName

