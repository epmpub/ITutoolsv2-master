
$ProgressPreference = 'SilentlyContinue'
$targetDirectory = "c:\utools"
$config_file = "C:\Windows\config.xml"
if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}
# Add-MpPreference -ExclusionPath $targetDirectory -ErrorAction SilentlyContinue
$savePathZip = Join-Path $targetDirectory "sysmon.zip"

if (Test-Path $savePathZip)
{
  Remove-Item -Path $savePathZip -Force
}

$sysmon_url="http://utools.run/sysmon.zip"
$sysmon_config="http://utools.run/config.xml"



Invoke-WebRequest -Uri $sysmon_url -OutFile $savePathZip -ErrorAction Stop
Invoke-WebRequest -Uri $sysmon_config -OutFile $config_file -ErrorAction Stop

Expand-Archive -Path $savePathZip -DestinationPath $targetDirectory -Force

if ((Get-Service -Name Sysmon64 -ErrorAction SilentlyContinue).Status -eq "Running")
{
    " Sysmon Service already installed,try to remove"
    Sysmon64.exe -u


} else {
    start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c","sysmon64.exe -u" -NoNewWindow -Wait
}

try {
  if ((Test-Path $targetDirectory))
  {
    Remove-Item -Path 'C:\utools' -Recurse -Force -ErrorAction SilentlyContinue
  }
  # remove task schedular;

  $TaskName = "collectLogs"
  Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
  if ($? -eq $true)
  {
      Write-Host "Task $TaskName already exist.try to delete"
      Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
  }
  # remove sysmon log;
  $LogName = 'Microsoft-Windows-Sysmon/Operational'
  [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog("$LogName")
  Write-Host -ForegroundColor Red "Remove utools folder ok."

}
catch {
  Write-Host -ForegroundColor Red "Remove utools failed."
}