$ProgressPreference = 'SilentlyContinue'
$events = Get-WinEvent  -FilterHashtable @{ logname = "Microsoft-Windows-Sysmon/Operational"; Id = 5;StartTime=(get-date).AddMinutes(-30) } -erroraction silentlycontinue
$guid = New-Guid

$timestamp = Get-Date -format "yyyy-MM-dd HH:mm:ss"

foreach ($event in $events)
{
    $eventXML = [xml]$Event.ToXml()

    $o = New-Object -Type PSObject -Property @{
    RuleName = $eventXML.Event.EventData.Data[0].'#text'
    UtcTime = $eventXML.Event.EventData.Data[1].'#text'
    ProcessGuid = $eventXML.Event.EventData.Data[2].'#text'
    ProcessId = $eventXML.Event.EventData.Data[3].'#text'

    Image = $eventXML.Event.EventData.Data[4].'#text'
    User = $eventXML.Event.EventData.Data[5].'#text'

    }

    $logs = $timestamp+','+$env:COMPUTERNAME+','+$o.RuleName + ','+$o.UtcTime+','+$o.ProcessGuid+","+$o.ProcessId+","+
            $o.Image+","+$o.User

    $js = [ordered]@{}
    $js["Id"] = $guid
    $js["Message"] = $logs

    $json = $js | ConvertTo-Json
    $response = Invoke-RestMethod 'http://utools.run/sysmon_id5' -Method 'POST' -Body $json
    $response | ConvertTo-Json
}