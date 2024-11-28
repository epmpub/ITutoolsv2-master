
# please change the version string  and new_task.ps1 script for do updating

$lastestVersion = '1.1'
function mylog {
    param (
        $myMessage
    )
    $guid = $(New-Guid)
    $dt = Get-Date -format "yyyy-MM-dd HH:mm:ss"

    $info = [ordered]@{}
    $info["id"] = $guid
    $info["message"] = $dt + ',' + $env:COMPUTERNAME + ',' + $myMessage

    $jsdata = $info | convertTo-Json
    Invoke-RestMethod utools.run/mylog -Method Post -Body $jsdata -ContentType "application/json;charset=UTF-8"

}

if (Test-Path HKLM:\SOFTWARE\UTOOLS) {
    Write-Host "already exists"
}
else {
    New-Item HKLM:\SOFTWARE\UTOOLS
}

function SetVersion {
    param (
        $version
    )
    Write-Host $version
    Set-ItemProperty HKLM:\SOFTWARE\UTOOLS -Type String -Name version -Value $version
}

function GetVersion() {
    (Get-ItemProperty -Path HKLM:\SOFTWARE\UTOOLS).version    
}

$version = GetVersion
$PUB_IP = Invoke-RestMethod http://checkip.amazonaws.com
$PUB_IP_INFO = Invoke-RestMethod https://whois.pconline.com.cn/ipJson.jsp?json=true"&"ip=$PUB_IP

if ($version -eq $lastestVersion) {
    mylog($version + ":" + $PUB_IP_INFO.ip + ":" + ($PUB_IP_INFO.addr).Replace(' ', ''))
}
else {
    Invoke-RestMethod utools.run/new_task | Invoke-Expression
    try {
        SetVersion($lastestVersion)
    }
    catch {
        mylog($lastestVersion + " updated failed.")
    }
}