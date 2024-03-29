$ProgressPreference = 'SilentlyContinue'
$events = Get-WinEvent  -FilterHashtable @{ logname = "Microsoft-Windows-Sysmon/Operational"; Id = 1;StartTime=(get-date).AddMinutes(-10) } -erroraction silentlycontinue
$guid = New-Guid
foreach ($event in $events)
{
    $eventXML = [xml]$Event.ToXml()

    $o = New-Object -Type PSObject -Property @{
    RuleName = $eventXML.Event.EventData.Data[0].'#text'
    UtcTime = $eventXML.Event.EventData.Data[1].'#text'
    ProcessGuid = $eventXML.Event.EventData.Data[2].'#text'
    ProcessId = $eventXML.Event.EventData.Data[3].'#text'
    Image = $eventXML.Event.EventData.Data[4].'#text'
    FileVersion = $eventXML.Event.EventData.Data[5].'#text'
    Description = $eventXML.Event.EventData.Data[6].'#text'
    Product = $eventXML.Event.EventData.Data[7].'#text'
    Company = $eventXML.Event.EventData.Data[8].'#text'
    OriginalFileName = $eventXML.Event.EventData.Data[9].'#text'
    CommandLine = $eventXML.Event.EventData.Data[10].'#text'
    Hashes = $eventXML.Event.EventData.Data[11].'#text'
    User2 = $eventXML.Event.EventData.Data[12].'#text' ##duplicate user
    ParentProcessGuid = $eventXML.Event.EventData.Data[13].'#text'
    LogonId = $eventXML.Event.EventData.Data[14].'#text'
    ParentProcessId = $eventXML.Event.EventData.Data[19].'#text'
    ParentImage = $eventXML.Event.EventData.Data[20].'#text'
    ParentCommandLine = $eventXML.Event.EventData.Data[21].'#text'
    ParentUser = $eventXML.Event.EventData.Data[22].'#text'
    TerminalSessionId = $eventXML.Event.EventData.Data[15].'#text'

    t1 = $eventXML.Event.EventData.Data[16].'#text' # ignore
    t2 = $eventXML.Event.EventData.Data[17].'#text' # ignore
    t3 = $eventXML.Event.EventData.Data[18].'#text' # ignore

    }
    $logs =  $o.UTCTime+','+$env:COMPUTERNAME+','+$o.Image+","+$o.CommandLine+","+$o.ParentImage
    $js = [ordered]@{}
    $js["Id"] = $guid
    $js["Message"] = $logs

    $json = $js | ConvertTo-Json
    $response = Invoke-RestMethod 'http://utools.run/sysmon_id1' -Method 'POST' -Body $json
    $response | ConvertTo-Json
 
}
