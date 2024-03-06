# PowerShell Function/Cmdlet to clear all of Logs
Function Clear-WinEvent {
    [CmdletBinding(SupportsShouldProcess = $True)]
    Param
    ([String]$LogName)
    Process {
        If ($PSCmdlet.ShouldProcess("$LogName", "Clear log file")) {
            [System.Diagnostics.Eventing.Reader.EventLogSession]::`
                GlobalSession.ClearLog("$LogName")
        }
    }
}

function clear-all-event-logs ()
{
   $logs = Get-EventLog  -List | ForEach-Object {$_.Log}
   $logs | ForEach-Object {Clear-EventLog -LogName $_ }
   Get-EventLog -list
}

Get-WinEvent -ListLog * | ForEach-Object {Clear-WinEvent -LogName $_.LogName -ErrorAction SilentlyContinue}

clear-all-event-logs

# Clear-Host
# $VictimLog = "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall"
# Get-WinEvent -ListLog $VictimLog
# Clear-WinEvent -LogName $VictimLog
# Write-Host "`nAfter running Clear-WinEvent: Check RecordCount "
# Get-WinEvent -ListLog $VictimLog
