$ProgressPreference = 'SilentlyContinue'

$id1log=Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=1;StartTime=(get-date).AddMinutes(-10)} | select ProviderName,Id,Message

foreach($data in $id1log)
{
    $data =  $data | ConvertTo-Json
    $response = Invoke-RestMethod 'http://utools.run/winevent/1' -Method 'POST' -Body $data
    $response | ConvertTo-Json

}



$id1log=Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=3;StartTime=(get-date).AddMinutes(-10)} | select ProviderName,Id,Message

foreach($data in $id1log)
{
    $data =  $data | ConvertTo-Json
    $response = Invoke-RestMethod 'http://utools.run/winevent/3' -Method 'POST' -Body $data
    $response | ConvertTo-Json

}



$id1log=Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=22;StartTime=(get-date).AddMinutes(-10)} | select ProviderName,Id,Message

foreach($data in $id1log)
{
    $data =  $data | ConvertTo-Json
    $response = Invoke-RestMethod 'http://utools.run/winevent/22' -Method 'POST' -Body $data
    $response | ConvertTo-Json

}
