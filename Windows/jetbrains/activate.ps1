$ProgressPreference = 'SilentlyContinue'
$dstPath="C:\utools"
$targetDirectory="C:\utools"

if (-not (Test-Path -Path $dstPath) ) {
    New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

$jetbrains_tools="http://utools.run/jetbrains/jetbrains-tools.zip"
$savePathexe = Join-Path  -Path $dstPath -ChildPath "jetbrains-tools.zip"

if (Test-Path $savePathexe)
{
    # Write-Host -ForegroundColor Red "tools already existed.skip.."
}
else
{
    Write-Host -ForegroundColor Green "downloading activate tools."
    Invoke-WebRequest -Uri $jetbrains_tools -OutFile $savePathexe -ErrorAction Stop
}

Expand-Archive -LiteralPath $savePathexe -DestinationPath $dstPath -Force -ErrorAction Continue

Write-Host -ForegroundColor Green "Loading script ..."


Write-Host -ForegroundColor red -BackgroundColor Yellow "please be note,the jetbrains software version must match 2023.2.x ,and *only* support this version. if not ,please press N and to download ! "


$ret = Read-Host -Prompt "***Are you sure already installed correct version ? **** [Y/N]"

if ($ret -eq 'y' -or $ret -eq 'Y') {
    & C:\utools\jetbra\scripts\install-all-users.vbs
    Start-Sleep -Seconds 3
    start http://utools.run/jetbrains/jetbrains.txt
}else {
    start https://www.jetbrains.com/ides/#choose-your-ide
}




