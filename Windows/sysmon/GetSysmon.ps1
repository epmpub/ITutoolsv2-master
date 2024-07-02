$ProgressPreference = 'SilentlyContinue'

$targetDirectory = "c:\utools"
$config_file = "C:\utools\config.xml"
if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}
# Add-MpPreference -ExclusionPath $targetDirectory -ErrorAction SilentlyContinue
$savePathexe = Join-Path $targetDirectory "sysmon64.exe"
$sysmon_url="http://utools.run/sysmon64.exe"
$sysmon_config="http://utools.run/config.xml"
if (Test-Path $savePathexe)
{
}
else
{
    Invoke-WebRequest -Uri $sysmon_url -OutFile $savePathexe -ErrorAction Stop
}
Invoke-WebRequest -Uri $sysmon_config -OutFile $config_file -ErrorAction Stop
if ((Get-Service -Name Sysmon64 -ErrorAction SilentlyContinue).Status -eq "Running")
{
    " Sysmon Service already installed"
    start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c","sysmon64.exe -nobanner -c c:\utools\config.xml -accepteula > sysmon.log 2>&1" -NoNewWindow -Wait | Out-Null
    " Sysmon Configuaration File has been Updated"
} else {
    start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c","sysmon64.exe -nobanner -i c:\utools\config.xml -accepteula > sysmon.log 2>&1" -NoNewWindow -Wait | Out-Null
}
