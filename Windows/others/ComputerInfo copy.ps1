# Requires -Version 5.1 
# Not Suported on PowerShell Core

if ($Host.Version.Major -ne 5 ) {
    Write-Host -ForegroundColor Red "This script requires PowerShell 5.1,after 5 seconds to exit."
    Start-Sleep -Seconds 5
    exit
}

chcp 65001
$guid = New-Guid
$proces = get-process | Select-Object Name,Id,ProcessName -First 20 | ? {$_.Name -notlike 'svchost'} | ? {$_.Name -notlike 'RuntimeBroker'}

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")

$dict = @{}

foreach ($item in $proces)
{
    $id=$item.Id
    $name=$item.Name
    $cpu=$item.CPU

    $dict["process_id"]=$id
    $dict["process_name"]=$name
    $dict["cpu"]=$cpu
    $dict["guid"]=$guid


    $data = $dict | ConvertTo-Json

    
    $response = Invoke-RestMethod 'http://utools.run:3000/api/process' -Method 'POST' -Headers $headers -Body $data
    $response | ConvertTo-Json

}



$adapters = Get-NetAdapter | Select-Object Name,InterfaceDescription,MacAddress

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json;charset=UTF-8")


$JSON = @{}

$adapters

foreach ($it in $adapters)
{

    Write-Host -ForegroundColor Red $it.Description

    $name=$it.Name
    $description=$it.InterfaceDescription
    $macaddress=$it.MacAddress


    $JSON["name"]=$name
    $JSON["interfaceDescription"]=$description
    $JSON["macaddress"]=$macaddress
    $JSON["guid"]=$guid


    $body = $JSON | ConvertTo-Json

    
    $body 

    $response = Invoke-RestMethod 'http://utools.run:3000/api/adapters' -Method 'POST' -Headers $headers -Body $body 
    #$response | ConvertTo-Json

}


$ProgressPreference = 'SilentlyContinue'
$info = Get-ComputerInfo

# comuter name:
#$info.LogonServer.Replace('\\','')
$disks= get-wmiobject -class win32_logicaldisk | ?{$_.DriveType -eq 3} | %{ [System.Math]::Round( $_.size / 1000/1000/1000)}
$disklist = [System.String]::Join("GB,",$disks)

$ram = [System.Math]::Round( $info.CsPhyicallyInstalledMemory / 1024 / 1024)

$JSON = @{}


$JSON["name"]=$env:COMPUTERNAME
$JSON["cpu"] = $info.CsProcessors.Name
$JSON["ram"] = $ram.ToString()
$JSON["disk"] = $disklist.ToString()
$JSON["gpu"] = ((Get-WmiObject Win32_VideoController).VideoProcessor)[1]
$JSON["guid"]=$guid

$body = $JSON | ConvertTo-Json

$body


$response = Invoke-RestMethod 'http://utools.run:3000/api/hosts' -Method 'POST' -Headers $headers -Body $body
