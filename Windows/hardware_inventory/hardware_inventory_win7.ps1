# Requires -Version 5.1 
# Not Suported on PowerShell Core

if ($Host.Version.Major -ne 5 ) {
    Write-Host -ForegroundColor Red "This script requires PowerShell 5.1,after 5 seconds to exit."
    Start-Sleep -Seconds 5
    exit
}

$guid = New-Guid

$ProgressPreference = 'SilentlyContinue'

# comuter name:

$disks= get-wmiobject -class win32_logicaldisk | Where-Object{$_.DriveType -eq 3} | ForEach-Object { [System.Math]::Round( $_.size / 1000/1000/1000)}
$disklist = [System.String]::Join("GB ",$disks)

$ram = ((Get-CimInstance CIM_PhysicalMemory).Capacity | Measure-Object -Sum).Sum / (1024 * 1024 * 1024)
$timestamp = Get-Date -format "yyyy-MM-dd HH:mm:ss"
$hostname = $env:COMPUTERNAME
$cpu = (Get-WmiObject -Query "select * from  Win32_Processor").Name
$ram = $ram.ToString()
$disks = $disklist.ToString()
$gpu = (Get-WmiObject Win32_VideoController).VideoProcessor

# Hotfix list

# Mac address

# IP address

# OS boottime

# OS version
$OsVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption

$data = [ordered]@{}
$data["Id"] = $guid
$data["Message"] = $timestamp + ',' + $hostname + ',' + $cpu + ',' + $ram + ',' + $disks + ',' + $gpu + ','+
                   $OsVersion

#free macs variable.


$body = $data | ConvertTo-Json
$body

$response = Invoke-RestMethod 'http://utools.run/hardware_inventory' -Method 'POST' -Headers $headers -Body $body -ContentType "application/json;charset=UTF-8"
$response | ConvertTo-Json
