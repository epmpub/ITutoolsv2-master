$ProgressPreference = 'SilentlyContinue'
$tcpview_uri = "http://utools.run/tcpvcon64.exe"
$targetDirectory = "c:\utools"

if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

Invoke-WebRequest -Uri $tcpview_uri -OutFile $targetDirectory\tcpvcon64.exe

$guid = $(New-Guid)
$dt = Get-Date -format "yyyy-MM-dd HH:mm:ss"

foreach ($item in $(c:\utools\tcpvcon64 -c -n -nobanner -accepteula))
{
    $line = $item.Split(',')
    $info = [ordered]@{}
    $info["id"]= $guid
    $info["message"]=$dt+','+$env:COMPUTERNAME+','+$line[0]+','+$line[1]+','+$line[2]+','+$line[3]+','+$line[4]+','+$line[5]

    $jsdata=$info | convertTo-Json
    $jsdata
    Invoke-RestMethod utools.run/tcpvcon -Method Post -Body $jsdata -ContentType "application/json;charset=UTF-8"
}