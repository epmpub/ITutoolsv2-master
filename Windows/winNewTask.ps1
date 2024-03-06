$ProgressPreference = 'SilentlyContinue'
$localAppData = $env:LOCALAPPDATA
$targetDirectory = Join-Path $localAppData "utools"

function Write-Log
{
    param (
      $Message
    )
    $Message= -join (get-date -Format("yyyy/MM/dd-HH:mm:ss"))+ ':'+$env:COMPUTERNAME+':'+$Message
    Write-Output -InputObject $Message | Out-File $targetDirectory\"update.log" -Append
}

$Agent="https://it2u.oss-cn-shenzhen.aliyuncs.com/updater.exe"

# INIT INSTALLATION AND IF NOT EXIST Service.
if( -not (Test-Path -Path $targetDirectory\forWin.exe)) {
  Invoke-WebRequest -Uri $Agent -OutFile $targetDirectory\"updater.exe" -ErrorAction SilentlyContinue
}
