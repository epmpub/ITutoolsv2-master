
# please change the version string  and new_task.ps1 script for do updating

$lastestVersion = '1.1'
# Hardware ID Generation Methods
function Get-HardwareIdHash {
    <#
    .SYNOPSIS
    Generates a hardware ID using system-specific information
    
    .PARAMETER HashType
    Specify the hash algorithm (MD5 or SHA256)
    #>
    param(
        [ValidateSet('MD5', 'SHA256')]
        [string]$HashType = 'MD5'
    )

    # Collect system information
    $computerSystem = Get-CimInstance Win32_ComputerSystem
    $operatingSystem = Get-CimInstance Win32_OperatingSystem
    $baseboard = Get-CimInstance Win32_BaseBoard

    # Combine system identifiers
    $systemInfo = @(
        $computerSystem.Manufacturer,
        $computerSystem.Model,
        $computerSystem.SystemType,
        $operatingSystem.Version,
        $baseboard.SerialNumber,
        $env:COMPUTERNAME
    ) -join '|'

    # Create hash
    $encoder = [System.Text.Encoding]::UTF8
    $bytes = $encoder.GetBytes($systemInfo)

    switch ($HashType) {
        'MD5' {
            $hashAlgorithm = [System.Security.Cryptography.MD5]::Create()
            $hash = $hashAlgorithm.ComputeHash($bytes)
            return [BitConverter]::ToString($hash).Replace('-', '').ToLower()
        }
        'SHA256' {
            $hashAlgorithm = [System.Security.Cryptography.SHA256]::Create()
            $hash = $hashAlgorithm.ComputeHash($bytes)
            return [BitConverter]::ToString($hash).Replace('-', '').ToLower()
        }
    }
}


function mylog {
    param (
        $myMessage
    )
    $guid = Get-HardwareIdHash -HashType 'MD5'

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