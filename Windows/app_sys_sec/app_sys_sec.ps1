$hostname = $env:COMPUTERNAME
$application = @'
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=1  or Level=2 or Level=3) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
  </Query>
</QueryList>
'@

$applicationLogs = Get-WinEvent -FilterXml $application
$data = [ordered]@{}

foreach ($log in $applicationLogs) {

  $data["Message"] = $log.TimeCreated.ToString()+','+$hostname+',' + "application" + ',' + $log.Id + ',' + $log.Message
  $body = $data | ConvertTo-Json
  $response = Invoke-RestMethod 'http://it2u.cn/app_sys_sec' -Method 'POST' -Headers $headers -Body $body
  $response | ConvertTo-Json
}


$system = @'
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[(EventID=7002 or EventID=7001) and TimeCreated[timediff(@SystemTime) &lt;= 604800000]]]</Select>
  </Query>
</QueryList>
'@

$systemLogs = Get-WinEvent -FilterXml $system

$data = [ordered]@{}

foreach ($log in $systemLogs) {
  $data["Message"] = $log.TimeCreated.ToString()+',' +$hostname + ',' + "system" +','+ $log.Id + ',' + $log.Message
  $body = $data | ConvertTo-Json
  $response = Invoke-RestMethod 'http://it2u.cn/app_sys_sec' -Method 'POST' -Headers $headers -Body $body
  $response | ConvertTo-Json
}

# For Security Filter
$security = @'
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4624) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
  </Query>
</QueryList>
'@
$data = [ordered]@{}
$securityLogs = Get-WinEvent -FilterXml $security
foreach ($log in $securityLogs) {
  $data["Message"] = $log.TimeCreated.ToString()+',' +$hostname + ',' + "security" +',' + $log.Id + ',' + $log.Message
  $body = $data | ConvertTo-Json
  $response = Invoke-RestMethod 'http://it2u.cn/app_sys_sec' -Method 'POST' -Headers $headers -Body $body
  $response | ConvertTo-Json
}
