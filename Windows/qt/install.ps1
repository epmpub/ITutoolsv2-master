# install qt6
# 2024/05/27

$ProgressPreference = 'SilentlyContinue'
$qt_installer_uri = "https://mirrors.aliyun.com/qt/official_releases/online_installers/qt-unified-windows-x64-online.exe "
$targetDirectory = "d:\qt-installer"

if (-not(Test-Path $targetDirectory))
{
  New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

Write-Host   -ForegroundColor Green "Default installation will be set to  d:\qt6 ,please make sure you  disk available space greater than 45GB."

Write-Host   -ForegroundColor Green "Default installation mirror is  Aliyun Cloud"

Write-Host   -ForegroundColor red "The Script will remove the directory files in the d:\qt6,please backup you file if it's neccessary for you need"


$ret = Read-Host -Prompt "Are you sure?[Y/N]"

if($ret -eq 'Y' -or $ret -eq 'y')
{

    Write-Host   -ForegroundColor Green "Please wait a moment,downloading qt installer."

    Invoke-WebRequest -Uri $qt_installer_uri -OutFile $targetDirectory\qt_installer.exe

    if ((Test-Path d:\qt))
    {
      Write-Host -ForegroundColor Gray --ForegroundColor Green "clean qt installation directory."
      Remove-Item -Recurse -Force d:\qt -ErrorAction Continue
    }

    Write-Progress -PercentComplete 100 -Activity "Downloading Qt Installer"

    & d:\qt-installer\qt_installer.exe --root d:\qt\qt6 --accept-licenses  --default-answer --confirm-command install qt.qt6.653.win64_mingw  --mirror https://mirrors.aliyun.com/qt --accept-obligations --auto-answer installationErrorWithCancel=Retry
}else {
    
    Write-Host -ForegroundColor Gray --ForegroundColor Green "thanks and bye"

}