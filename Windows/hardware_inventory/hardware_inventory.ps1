# Requires -Version 5.1 
# Not Suported on PowerShell Core

if ($Host.Version.Major -ne 5 ) {
    Write-Host -ForegroundColor Red "This script requires PowerShell 5.1,after 5 seconds to exit."
    Start-Sleep -Seconds 5
    exit
}

$guid = New-Guid

$ProgressPreference = 'SilentlyContinue'
$info = Get-ComputerInfo

# comuter name:
#$info.LogonServer.Replace('\\','')
$disks= get-wmiobject -class win32_logicaldisk | Where-Object{$_.DriveType -eq 3} | ForEach-Object { [System.Math]::Round( $_.size / 1000/1000/1000)}
$disklist = [System.String]::Join("GB ",$disks)

$ram = [System.Math]::Round( $info.CsPhyicallyInstalledMemory / 1024 / 1024)
$timestamp = Get-Date -format "yyyy-MM-dd HH:mm:ss"
$hostname = $env:COMPUTERNAME
$cpu = $info.CsProcessors.Name
$ram = $ram.ToString()
$disks = $disklist.ToString()
$gpu = (Get-WmiObject Win32_VideoController).VideoProcessor

# Hotfix list
foreach ($item in $info.OsHotFixes){$HotFixIDss += $item.HotFixID + " "}

# Mac address
foreach ($mac in (Get-NetAdapter)) {$macs += $mac.MacAddress + "|"}

# IP address
$list = [System.Collections.ArrayList]::new()
foreach ($ip in (Get-NetIPAddress))
{
    if(($ip.AddressFamily -eq 'IPv4') -and ($ip.IPAddress -notmatch ‘169’) -and ($ip.IPAddress -notmatch ‘127’))
    {
        $null = $list.Add($ip.IPAddress)
    }
}
$ips = $list  -join "|"

# OS boottime
$LastBootUpTime = $info.OsLastBootUpTime.ToString()
$Uptime = $info.OsUptime.ToString()

# OS version
$OsVersion = $info.OsVersion

$data = [ordered]@{}
$data["Id"] = $guid
$data["Message"] = $timestamp + ',' + $hostname + ',' + $cpu + ',' + $ram + ',' + $disks + ',' + $gpu + ','+
                   $HotFixIDss + ','+ $macs + ',' + $ips + ',' +
                   $LastBootUpTime + ',' + $Uptime + ',' + $OsVersion

#free macs variable.

$macs = $null

$body = $data | ConvertTo-Json
$body

$response = Invoke-RestMethod 'http://utools.run/hardware_inventory' -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json
