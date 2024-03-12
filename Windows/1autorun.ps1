
# author:andy.hu
# date:2020-03-20 10:16AM
# description: collect autorun information and send to utools.run

$ProgressPreference = 'SilentlyContinue'
function Write-Log
{

 param(
        [ValidateSet('INFO','ERR','FATAL')] $level,
        [System.String] $Message
    )

    $timestamp = Get-Date -f 'o'
    $hostname = $env:COMPUTERNAME
    $logEntry = [ordered]@{}

    $logEntry["timestamp"] = $timestamp
    $logEntry["level"] = $level
    $logEntry["hostname"] = $hostname
    $logEntry["message"] = $message

    $body = $logEntry | ConvertTo-Json
    Invoke-RestMethod -Uri http://utools.run/log -ContentType "Application/json;charset=UTF-8" -Method Post -Body $body
}


if (Test-Path -Path "C:\tools\autorunsc64.exe") {
    Write-Host "autorunsc64.exe exists"
} else {
    Write-Host "autorunsc64.exe not exists, download it"
    Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Autoruns.zip" -OutFile "C:\tools\Autoruns.zip"
    Expand-Archive -Path "C:\tools\Autoruns.zip" -DestinationPath "C:\tools\"
    Remove-Item -Path "C:\tools\Autoruns.zip"
}

C:\tools\autorunsc64.exe -nobanner -accepteula -a slt -m  -c > C:\tools\autorun.log

$autoruns = import-csv -Path C:\tools\autorun.log

$guid = New-Guid
$autorunData = [ordered]@{}

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json;charset=UTF-8")


foreach($item in $autoruns)
{
    $autorunData["entrytime"] = $item.Time.ToString()
    $autorunData["entrylocation"] = $item.'Entry Location'
    $autorunData["entryname"] = $item.Entry
    $autorunData["enabled"] = $item.Enabled

    $autorunData["category"] = $item.Category
    $autorunData["profile"] = $item.Profile
    $autorunData["description"] = $item.Description
    $autorunData["company"] = $item.Company

    $autorunData["imagepath"] = $item.'Image Path'
    $autorunData["versioin"] = $item.Version
    $autorunData["launchstring"] = $item.'Launch String'
    $autorunData["guid"] = $guid
    $body = $autorunData | ConvertTo-Json
    # Invoke-RestMethod 'http://utools.run:3000/api/autorun' -Method 'POST' -Headers $headers -Body $body


    
    $body
}