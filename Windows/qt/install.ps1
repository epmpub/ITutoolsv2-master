# install qt6
# 2024/05/27

$ProgressPreference = 'SilentlyContinue'
$qt_installer_uri = "https://mirrors.aliyun.com/qt/official_releases/online_installers/qt-unified-windows-x64-online.exe "

Write-Host -ForegroundColor Green "Welcome!"

$installation_path = Read-Host -Prompt "please input you want install directory"
$qt_installer_filehash = "AF3391A285902BFF48AD38A356678C9163F5B479C51DB8A083626BACDB882D32"

$targetDirectory = $installation_path

if ((Test-Path ${installation_path})) {
  Write-Host -ForegroundColor Gray --ForegroundColor Green "clean qt installation directory."
  Remove-Item -Recurse -Force ${installation_path} -ErrorAction Continue
}

if (-not(Test-Path $targetDirectory)) {
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

Write-Host   -ForegroundColor Green "The installation will be set to  ${installation_path} ,please make sure you  disk available space greater than 45GB."

Write-Host   -ForegroundColor Green "Default installation mirror is  Aliyun Cloud"

Write-Host   -ForegroundColor red "The Script will remove the directory files in the ${installation_path},please backup you file if it's neccessary for you need"


$ret = Read-Host -Prompt "Are you sure?[Y/N]"

if ($ret -eq 'Y' -or $ret -eq 'y') {

  # check qt installer hash value is correct.
  if (Test-Path -Path $env:APPdata\qt_installer.exe) {
    if ((Get-FileHash -Path $env:APPdata\qt_installer.exe).Hash -eq $qt_installer_filehash) {
      & $env:APPDATA\qt_installer.exe --root ${installation_path} --accept-licenses  --default-answer --confirm-command install qt.qt6.653.win64_mingw  --mirror https://mirrors.aliyun.com/qt --accept-obligations --auto-answer installationErrorWithCancel=Retry
    }
    # if file hash value is not correct,begin to download.
    else {
      Write-Host -ForegroundColor Green "Please wait a moment,downloading qt installer,Installer will be automaticly start when download finished."
      Invoke-WebRequest -Uri $qt_installer_uri -OutFile $env:APPDATA\qt_installer.exe
      Write-Progress -PercentComplete 100 -Activity "Download Qt Installer finished and start Qt installer."
      & $env:APPDATA\qt_installer.exe --root ${installation_path} --accept-licenses  --default-answer --confirm-command install qt.qt6.653.win64_mingw  --mirror https://mirrors.aliyun.com/qt --accept-obligations --auto-answer installationErrorWithCancel=Retry
    }
  # file no exist. 
  }else {
    Write-Host -ForegroundColor Green "Please wait a moment,downloading qt installer,Installer will be automaticly start when download finished."
    Invoke-WebRequest -Uri $qt_installer_uri -OutFile $env:APPDATA\qt_installer.exe
    Write-Progress -PercentComplete 100 -Activity "Download Qt Installer finished and start Qt installer."
    & $env:APPDATA\qt_installer.exe --root ${installation_path} --accept-licenses  --default-answer --confirm-command install qt.qt6.653.win64_mingw  --mirror https://mirrors.aliyun.com/qt --accept-obligations --auto-answer installationErrorWithCancel=Retry
  }
}
else {
  #abort installation
  Write-Host -ForegroundColor Gray --ForegroundColor Green "thanks and bye"
}