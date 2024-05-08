
$ProgressPreference = 'SilentlyContinue'

$tcpviewer64 = "http://utools.run/tcpview64.exe"
$autoruns64 = "http://utools.run/autoruns64.exe"
$procexp64 = "http://utools.run/procexp64.exe"

curl -Uri $tcpviewer64 -OutFile $env:APPDATA\tcpviewer64.exe
curl -Uri $autoruns64 -OutFile $env:APPDATA\autoruns64.exe
curl -Uri $procexp64 -OutFile $env:APPDATA\procexp64.exe



& $env:APPDATA\tcpviewer64.exe
& $env:APPDATA\autoruns64.exe
& $env:APPDATA\procexp64.exe