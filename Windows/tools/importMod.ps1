$module_url = "http://utools.run/GetGreetingDemo.dll"
$destination = "c:\utools\GetGreetingDemo.dll"

Remove-Module -Name GetGreetingDemo -Force -ErrorAction SilentlyContinue
Remove-Item -Force $destination -ea 0
Write-Host "Downloading module..."
Invoke-WebRequest -Uri $module_url -OutFile $destination -ErrorAction Stop
Import-Module c:\utools\GetGreetingDemo.dll -ErrorAction Stop
Get-Greeting