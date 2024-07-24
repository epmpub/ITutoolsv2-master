# install qt6 and linuxdeployqt tools
# 2024/07/22

read -p "Please enter your input: " userInput


Clear-Host
Write-Host "=========================================================================================================================="
Write-Host -ForegroundColor Yellow "This scipt will assist you to install Qt6 and linuxqtdeploy tools."
Write-Host -ForegroundColor Yellow "Please make sure you disk available space greater than 20GB."
Write-Host -ForegroundColor Yellow "The linuxdeployqt tools will be install to /usr/local/bin directory "
Write-Host -ForegroundColor Yellow "Please prepare you Qt account,email and password.the script need your input you account to install."
Write-Host "=========================================================================================================================="

Write-Host




Write-Host "Which folder would you like to install QT6? default is: /opt/qt653"
$ret = [System.Console]::ReadLine()

if ($ret -eq '') {
  $targetDirectory = "/opt/qt653"
}else {
  $targetDirectory = $ret
}

#OS verson,only support ubuntu 20.04
$osVersion = lsb_release -r | cut -f 2
if ($osVersion -eq '20.04') {
  Write-Host -ForegroundColor Green "- Detected OS is match"
}else {
  Write-Host "The current os version is not support"
  exit
}

$disk_free_space = df / -hl| awk ' NR>1 {print $4}'
if ($disk_free_space -gt 15) {
  Write-Host -ForegroundColor Green "- Detected Disk Available space is match"
}else {
  Write-Host "The disk space is not match"
  exit
}



sudo apt-get update
sudo apt-get -y install curl
sudo apt-get -y install libxcb-cursor0
sudo apt-get -y install gcc
sudo apt-get -y install g++
sudo apt-get -y install make

sudo apt-get -y install libgl1-mesa-dev #安装OpenGL核心库


# $ProgressPreference = 'SilentlyContinue'
$qt_installer_uri = "https://mirrors.cloud.tencent.com/qt/official_releases/online_installers/qt-unified-linux-x64-online.run"
$linuxqtdeploy_uri = "http://utools.run/linuxdeployqt-continuous-x86_64.AppImage"



if (-not(Test-Path $targetDirectory)) {
  sudo mkdir -p ${targetDirectory}
}


if ((Test-Path ${targetDirectory})) {
  sudo rm -rf ${targetDirectory}
}


sudo rm -rf ~/qt-unified-linux-x64-online.run
sudo wget -q ${qt_installer_uri} -O ~/qt-unified-linux-x64-online.run --show-progress
sudo chmod +x ~/qt-unified-linux-x64-online.run

sudo rm -rf /usr/local/bin/linuxdeployqt-continuous-x86_64.AppImage
sudo wget -q ${linuxqtdeploy_uri} -O /usr/local/bin/linuxdeployqt-continuous-x86_64.AppImage --show-progress
sudo chmod +x /usr/local/bin/linuxdeployqt-continuous-x86_64.AppImage

sudo ~/qt-unified-linux-x64-online.run --root ${targetDirectory} --accept-licenses --default-answer --confirm-command install qt.qt6.653.gcc_64 --mirror https://mirrors.cloud.tencent.com/qt/ --accept-obligations --auto-answer installationErrorWithCancel=Retry
