function Write-Log ($level, $message)
{
    $timestamp = Get-Date -f 'o'
    $hostname = $env:COMPUTERNAME
    $logEntry = [ordered]@{}

    $logEntry["timestamp"] = $timestamp
    $logEntry["level"] = $level
    $logEntry["hostname"] = $hostname
    $logEntry["message"] = $message

    $body = $logEntry | ConvertTo-Json
    Invoke-RestMethod -Uri http://it2u.cn/log -ContentType "Application/json;charset=UTF-8" -Method Post -Body $body
}