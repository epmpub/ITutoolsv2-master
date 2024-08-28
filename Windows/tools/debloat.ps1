$ProgressPreference = 'SilentlyContinue'

$targetDirectory = "c:\utools"
if (-not(Test-Path $targetDirectory)) {
    New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}
# Add-MpPreference -ExclusionPath $targetDirectory -ErrorAction SilentlyContinue
$savePathexe = Join-Path $targetDirectory "WinDebloat.zip"
$url = "http://utools.run/WinDebloat.zip"
if (Test-Path $savePathexe) {
}
else {
    Invoke-WebRequest -Uri $url -OutFile $savePathexe -ErrorAction Stop
}

Expand-Archive -Path $savePathexe -DestinationPath $targetDirectory -Force -ErrorAction Stop

start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c", "PowerShell -NoProfile -ExecutionPolicy Bypass -File c:\utools\WinDebloat\Win11Debloat.ps1" -NoNewWindow -Wait | Out-Null
# start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c","sysmon64.exe -nobanner -c c:\utools\config.xml -accepteula > sysmon.log 2>&1" -NoNewWindow -Wait | Out-Null

