# funciton: get Server Hardware Information;
# author: andy.hu
# date: 2024/01/09 14:51

# $process=Get-Process | Select-Object NPM,PM,WS,CPU,Id,SI,ProcessName



$dt = @{}
$dt['$date'] = Get-Date -f "o"

$info = [ordered]@{}
$info["timestamp"]=$dt
$info["host"]=$env:COMPUTERNAME
$info["cpu"]=(Get-CimInstance -ClassName Win32_Processor).Caption
$jsdata=$info | convertTo-Json
# $jsdata | Out-File 666.json -Encoding utf8
Invoke-RestMethod utools.run/data -Method Post -Body $jsdata
