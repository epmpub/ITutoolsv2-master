$TaskName = "WinHelperServiceDeploy"
$ServiceName = "WHelper"
$existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
$existingService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($existingTask -and $existingService) {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}
if ($existingService) {
    get-service -Name $ServiceName | Start-service -ErrorAction SilentlyContinue
}