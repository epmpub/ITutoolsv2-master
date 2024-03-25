# clean sysmon Log
$LogName='Microsoft-Windows-Sysmon/Operational'
try {
    [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog("$LogName")
}
catch {
}
