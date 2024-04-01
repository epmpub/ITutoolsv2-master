$hostname = $env:COMPUTERNAME

# $application = @'
# <QueryList>
#   <Query Id="0" Path="Application">
#     <Select Path="Application">*[System[(Level=1 ) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
#   </Query>
# </QueryList>
# '@

# $applicationLogs = Get-WinEvent -FilterXml $application -ErrorAction SilentlyContinue
# $data = [ordered]@{}

# foreach ($log in $applicationLogs) {

#   $data["Message"] = $log.TimeCreated.ToString() + ',' + $hostname + ',' + "application" + ',' + $log.Id + ',' + $log.Message
#   $body = $data | ConvertTo-Json
#   $response = Invoke-RestMethod 'http://utools.run/app_sys_sec' -Method 'POST' -Headers $headers -Body $body
#   $response | ConvertTo-Json
# }


$system = @'
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[(EventID=7002 or EventID=7001) and TimeCreated[timediff(@SystemTime) &lt;= 604800000]]]</Select>
  </Query>
</QueryList>
'@


$systemLogs = Get-WinEvent -FilterXml $system -ErrorAction SilentlyContinue

$data = [ordered]@{}

foreach ($log in $systemLogs) {
  $data["Message"] = $log.TimeCreated.ToString() + ',' + $hostname + ',' + "system" + ',' + $log.Id + ',' + $log.Message
  $body = $data | ConvertTo-Json
  $response = Invoke-RestMethod 'http://utools.run/app_sys_sec' -Method 'POST' -Headers $headers -Body $body
  $response | ConvertTo-Json
}


$CurrentWindowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$CurrentWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($CurrentWindowsIdentity)

if ($CurrentWindowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) 
{
# For Security Filter
$security = @'
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4624) and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
  </Query>
</QueryList>
'@
    $data = [ordered]@{}
    $securityLogs = Get-WinEvent -FilterXml $security -ErrorAction SilentlyContinue
    foreach ($log in $securityLogs) {
      $location = $log.Message.IndexOf("This event is")
      $Message = $log.Message.Remove($location,$log.Message.Length-$location)
      
      $data["Message"] = $log.TimeCreated.ToString() + ',' + $hostname + ',' + "security" + ',' + $log.Id + ',' + $Message
      $body = $data | ConvertTo-Json
      $body
      $response = Invoke-RestMethod 'http://utools.run/app_sys_sec' -Method 'POST' -Headers $headers -Body $body
      $response | ConvertTo-Json
    }
} 
else {
  Write-Warning "Insufficient permissions to run this script"
}
