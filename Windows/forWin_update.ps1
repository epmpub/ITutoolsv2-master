# function: install and update service.
# author:andy.hu
# email: qjanda@gmail.com
# date: 2024/1/12 14:52

$ProgressPreference = 'SilentlyContinue'
function Write-Log {
  param (
    $Message
  )
  $Message= -join (get-date -Format("yyyy/MM/dd-HH:mm:ss"))+ ':'+$env:COMPUTERNAME+':'+$Message
  Write-Output -InputObject $Message | Out-File $logPath -Append
}

$logPath = "c:\tools\up.log"

$targetDirectory = "c:\tools"
# CREATE TARGET FOLDER
if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

$svc_name = "forWin"
$bin_file = "http://it2u.oss-cn-shenzhen.aliyuncs.com/forWin.exe"
$dst_file = "c:\tools\forWin.exe"
$forWin_md5 = "http://it2u.oss-cn-shenzhen.aliyuncs.com/forWin_md5.json"

Get-Service -Name $svc_name -ErrorAction SilentlyContinue

if ($?) {
  # if exist ,create another one.
  Write-Log -Message "The service has been existed. prepare to file replacement."
  Stop-Service -Name $svc_name -Force -ErrorAction SilentlyContinue

  Stop-Process -Name $svc_name -Force -ErrorAction SilentlyContinue

  if((Get-Service -Name $svc_name).Status -eq "Stopped")
  {
    Write-Host -ForegroundColor Red $svc_name  "is stopped."
    Invoke-WebRequest -Uri $bin_file -OutFile $dst_file -ErrorAction SilentlyContinue
  }

  Get-Service -Name $svc_name | Start-Service

  if((Get-Service -Name $svc_name).Status -eq "running")
  {
    Write-Host -ForegroundColor Green $svc_name "is started."
  }

  Write-Host -ForegroundColor Green $svc_name "is updated."


}else{
  # if not exist ,create one.
  Write-Host "begin to install service"
  Invoke-WebRequest -Uri $bin_file -OutFile $dst_file -ErrorAction SilentlyContinue

  $installCMD = " nssm install " + $svc_name + " " + $dst_file  + " confirm"

  Write-Log -Message "Install the service command:"$installCMD

  start-process -FilePath "$env:ComSpec" -WorkingDirectory $targetDirectory -ArgumentList "/c",$installCMD -NoNewWindow -Wait

  Get-Service -Name $svc_name | Start-Service

  if((Get-Service -Name $svc_name).Status -eq "running")
  {
    Write-Log -Message $svc_name ":is started."
  }
}

# verify hash:

$localHash = (Get-FileHash -Algorithm MD5 $dst_file).Hash
$remoteHash = (Invoke-RestMethod $forWin_md5).Hash

if($localHash -eq $remoteHash)
{
    Write-Log -Message "The service has been updated successfully."
}