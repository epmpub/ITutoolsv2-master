# install qt6
# 2024/07/22

sudo apt-get update
sudo apt-get -y install curl
sudo apt-get -y install libxcb-cursor0
sudo apt-get -y install gcc
sudo apt-get -y install g++
sudo apt-get -y install make

sudo apt-get -y install libgl1-mesa-dev #安装OpenGL核心库
sudo apt-get -y install aria2


# $ProgressPreference = 'SilentlyContinue'
$qt_installer_uri = "https://mirrors.cloud.tencent.com/qt/official_releases/online_installers/qt-unified-linux-x64-online.run"


$installation_path = Read-Host -Prompt  "please input you want install directory"

$targetDirectory = $installation_path

if (-not(Test-Path $targetDirectory)) {
  sudo mkdir -p ${targetDirectory}
}

Write-Host   -ForegroundColor Green "The installation will be set to  ${installation_path} ,please make sure you  disk available space greater than 20GB."

Write-Host   -ForegroundColor Green "Installation mirror is :Tencent Cloud"

Write-Host   -ForegroundColor red "The Script will remove the directory files in the ${installation_path},please backup you file if it's neccessary for you need"


$ret = Read-Host -Prompt "Are you sure?[Y/N]"

if ((Test-Path ${installation_path})) {
  Write-Host -ForegroundColor Red "clean qt installation ${installation_path}."
  sudo rm -rf ${installation_path}
}

if ($ret -eq 'Y' -or $ret -eq 'y') {

    sudo wget ${qt_installer_uri} -O ~/qt-unified-linux-x64-online.run --show-progress 

    sudo chmod +x ~/qt-unified-linux-x64-online.run

    sudo ~/qt-unified-linux-x64-online.run --root ${targetDirectory} --accept-licenses --default-answer --confirm-command install qt.qt6.653.gcc_64 --mirror https://mirrors.cloud.tencent.com/qt/ --accept-obligations --auto-answer installationErrorWithCancel=Retry

} else {
    Write-Host "Bye!"
}