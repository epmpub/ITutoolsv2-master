$ProgressPreference = 'SilentlyContinue'
$guid = New-Guid

$timestamp = Get-Date -format "yyyy-MM-dd HH:mm:ss"
$events = Get-WinEvent  -FilterHashtable @{ logname = "Microsoft-Windows-Sysmon/Operational"; Id = 3;StartTime=(get-date).AddMinutes(-15) } -erroraction silentlycontinue
 
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
    Protocol = $eventXML.Event.EventData.Data[6].'#text'
    Initiated = $eventXML.Event.EventData.Data[7].'#text'

    SourceIsIpv6 = $eventXML.Event.EventData.Data[8].'#text'
    SourceIp = $eventXML.Event.EventData.Data[9].'#text'
    SourceHostname = $eventXML.Event.EventData.Data[10].'#text'
    SourcePort = $eventXML.Event.EventData.Data[11].'#text'
    SourcePortName = $eventXML.Event.EventData.Data[12].'#text'

    DestinationIsIpv6 = $eventXML.Event.EventData.Data[13].'#text'
    DestinationIp = $eventXML.Event.EventData.Data[14].'#text'
    DestinationHostname = $eventXML.Event.EventData.Data[15].'#text'
    DestinationPort = $eventXML.Event.EventData.Data[16].'#text'
    DestinationPortName = $eventXML.Event.EventData.Data[17].'#text'

    }
 
    $logs = $timestamp +','+$env:COMPUTERNAME+','+$o.RuleName+','+$o.UtcTime +','+$o.ProcessGuid +','+
    $o.ProcessId+','+$o.Image+','+$o.User+','+$o.Protocol+','+$o.Initiated+','+
    $o.SourceIsIpv6+','+$o.SourceIp+','+$o.SourceHostname+','+$o.SourcePort+','+$o.SourcePortName+','+
    $o.DestinationIsIpv6+','+$o.DestinationIp+','+$o.DestinationHostname+','+$o.DestinationPort+','+$o.DestinationPortName

    $js = [ordered]@{}
    $js["Id"] = $guid
    $js["Message"] = $logs

    $json = $js | ConvertTo-Json
    $response = Invoke-RestMethod 'http://utools.run/sysmon_id3' -Method 'POST' -Body $json
    $response | ConvertTo-Json
 
}
 