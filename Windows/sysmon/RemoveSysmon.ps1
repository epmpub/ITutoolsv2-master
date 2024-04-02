
$ProgressPreference = 'SilentlyContinue'
$targetDirectory = "c:\utools"

if ((Get-Service -Name Sysmon64 -ErrorAction SilentlyContinue).Status -eq "Running")
{
    " Sysmon Service already installed,try to remove"
    start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c","sysmon64.exe -accepteula -nologo -u >nul 2>1" -NoNewWindow -Wait
} else {
   
}


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

try {
    [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog("$LogName")
}catch [System.Diagnostics.Eventing.Reader.EventLogException] {
    write-host -Foreground Yellow "EventLog NotFound"
}
Write-Host -ForegroundColor Green "Remove utools folder ok."
