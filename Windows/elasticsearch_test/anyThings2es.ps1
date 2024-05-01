$API_KEY='ApiKey MXV1Tl80NEJ6enlLeTRkbU5ldzI6TzIwVF9rTnpSZXUxc0ZoZUlqRDU0QQ=='
    
$data = Get-Process  |  Select Id,ProcessName

foreach($item in $data)
{
    $body = $item | ConvertTo-Json
    irm -Uri http://192.168.3.100:9200/process/_doc -ContentType "application/json" -Headers @{'Authorization' = $API_KEY} -Method Post -Body $body
}


