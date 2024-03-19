$ProgressPreference = 'SilentlyContinue'

$id1logs=Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=1;StartTime=(get-date).AddMinutes(-10)} | Select-Object ProviderName,Id,Message -Last 2
foreach($my in $id1logs)
{
    $newlog = $my.Message.Replace('Process Create:','')
    $log = $newlog.Split("`r`n")

    $js = [ordered]@{}

    # $i == lines number
    for ($i = 1; $i -lt $log.Count - 1; $i++)
    { 
        $k = $log[$i].Split([string[]] ": ",[System.StringSplitOptions]"None")[0]
        $v = $log[$i].Split([string[]] ": ",[System.StringSplitOptions]"None")[1]
        $js[$k] = $v
    }
    $json = $js | ConvertTo-Json
    $response = Invoke-RestMethod 'http://39.108.176.143/winevent/1' -Method 'POST' -Body $json
    $response | ConvertTo-Json

}




$id1logs=Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=3;StartTime=(get-date).AddMinutes(-10)} | select ProviderName,Id,Message -Last 2
foreach($my in $id1logs)
{
    $newlog = $my.Message.Replace('Process Create:','')
    $log = $newlog.Split("`r`n")

    $js = [ordered]@{}

    # $i == lines number
    for ($i = 1; $i -lt $log.Count - 1; $i++)
    { 
        $k = $log[$i].Split([string[]] ": ",[System.StringSplitOptions]"None")[0]
        $v = $log[$i].Split([string[]] ": ",[System.StringSplitOptions]"None")[1]
        $js[$k] = $v
    }
    $json = $js | ConvertTo-Json
    $response = Invoke-RestMethod 'http://39.108.176.143/winevent/3' -Method 'POST' -Body $json
    $response | ConvertTo-Json

}



$id1logs=Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational";id=22;StartTime=(get-date).AddMinutes(-10)} | select ProviderName,Id,Message -Last 2
foreach($my in $id1logs)
{
    $newlog = $my.Message.Replace('Process Create:','')
    $log = $newlog.Split("`r`n")

    $js = [ordered]@{}

    # $i == lines number
    for ($i = 1; $i -lt $log.Count - 1; $i++)
    { 
        $k = $log[$i].Split([string[]] ": ",[System.StringSplitOptions]"None")[0]
        $v = $log[$i].Split([string[]] ": ",[System.StringSplitOptions]"None")[1]
        $js[$k] = $v
    }
    $json = $js | ConvertTo-Json
    $response = Invoke-RestMethod 'http://39.108.176.143/winevent/22' -Method 'POST' -Body $json
    $response | ConvertTo-Json

}
