$ProgressPreference = 'SilentlyContinue'
$tcpview_uri = "https://download.sysinternals.com/files/TCPView.zip"
$targetDirectory = "c:\tools2"

if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

Invoke-WebRequest -Uri $tcpview_uri -OutFile $targetDirectory\TCPView.zip

Expand-Archive -Path C:\tools2\TCPView.zip -DestinationPath $targetDirectory -Force

foreach ($item in $(C:\tools2\tcpvcon -c -n -nobanner -accepteula))
{
    $line = $item.Split(',')

    # Write-Host -NoNewline $line[0] , $line[1] , $line[2], $line[3],$line[4] ,$line[5]
    # $dt = @{}
    # $dt['$date'] = Get-Date -f "o"

    $info = [ordered]@{}
    $info["timestamp"]= Get-Date -f "o"
    $info["host"]=$env:COMPUTERNAME

    $info["protocol"]=$line[0]
    $info["name"]=$line[1]
    $info["pid"]=$line[2]

    $info["state"]=$line[3]
    $info["local"]=$line[4]
    $info["remote"]=$line[5]
    $info["api"]="v1"


    $jsdata=$info | convertTo-Json
    $jsdata

    # $jsdata | Out-File 666.json -Encoding utf8
    Invoke-RestMethod 39.108.176.143/mongodb -Method Post -Body $jsdata
}