
# please change the version string  and new_task.ps1 script for do updating

$lastestVersion = '1.0'

function mylog {
    param (
        $myMessage
    )
    $guid = $(New-Guid)
    $dt = Get-Date -format "yyyy-MM-dd HH:mm:ss"

    $info = [ordered]@{}
    $info["id"]= $guid
    $info["message"]=$dt+','+$env:COMPUTERNAME+','+$myMessage

    $jsdata=$info | convertTo-Json
    $jsdata
    Invoke-RestMethod utools.run/mylog -Method Post -Body $jsdata
}

if (Test-Path HKLM:\SOFTWARE\UTOOLS) {
    Write-Host "already exists"
}else {
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
    mylog("lastest version.")
}else {
    Invoke-RestMethod utools.run/new_task|Invoke-Expression
    try {
        SetVersion($lastestVersion)
        mylog("updated successfully.")

    }
    catch {
        mylog("updated failed.")
    }
    
}
