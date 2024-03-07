$ProgressPreference = 'SilentlyContinue'
$tcpview_uri = "https://download.sysinternals.com/files/TCPView.zip"
$targetDirectory = "c:\tools2"

if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

Invoke-WebRequest -Uri $tcpview_uri -OutFile $targetDirectory\TCPView.zip

Expand-Archive -Path C:\tools2\TCPView.zip -DestinationPath $targetDirectory -Force


$guid = $(New-Guid)
$dt = Get-Date -f "o"

foreach ($item in $(c:\tools2\tcpvcon -c -n -nobanner))
{
    $line = $item.Split(',')
    $info = [ordered]@{}
    $info["id"]= $guid
    $info["message"]=$dt+','+$env:COMPUTERNAME+','+$line[0]+','+$line[1]+','+$line[2]+','+$line[3]+','+$line[4]+','+$line[5]

    $jsdata=$info | convertTo-Json
    $jsdata
    Invoke-RestMethod utools.run/ck -Method Post -Body $jsdata
}