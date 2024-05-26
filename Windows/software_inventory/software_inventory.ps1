# Requires -Version 5.1 
# Not Suported on PowerShell Core

if ($Host.Version.Major -ne 5 ) {
    Write-Host -ForegroundColor Red "This script requires PowerShell 5.1,after 5 seconds to exit."
    Start-Sleep -Seconds 5
    exit
}

$guid = New-Guid
$timestamp = Get-Date -format "yyyy-MM-dd HH:mm:ss"
$hostname = $env:COMPUTERNAME

$softList = [ordered]@{}
$data = [ordered]@{}

$InstalledSoftware = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
foreach($obj in $InstalledSoftware)
{
    if ($null -eq $obj.GetValue('DisplayName'))
    {
    
    }else
    {
        $softList["Name"] = $obj.GetValue('DisplayName')
        $softList["Version"] = $obj.GetValue('DisplayVersion')
        $softList["InstallLocation"] = $obj.GetValue('InstallLocation')
    }
    $data["Id"] = $guid
    $data["Message"] = $timestamp + ',' + $hostname + ',' + $softList["Name"] + ',' + $softList["Version"] + ',' + $softList["InstallLocation"]
    $body = $data | ConvertTo-Json
    $body
    
    $response = Invoke-RestMethod 'http://utools.run/software_inventory' -Method 'POST' -Headers $headers -Body $body -ContentType "application/json;charset=UTF-8"
    $response | ConvertTo-Json

}

$InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
foreach($obj in $InstalledSoftware)
{
    if ($null -eq $obj.GetValue('DisplayName'))
    {
    
    }else
    {
        $softList["Name"] = $obj.GetValue('DisplayName')
        $softList["Version"] = $obj.GetValue('DisplayVersion')
        $softList["InstallLocation"] = $obj.GetValue('InstallLocation')
    }

    $data["Id"] = $guid
    $data["Message"] = $timestamp + ',' + $hostname + ',' + $softList["Name"] + ',' + $softList["Version"] + ',' + $softList["InstallLocation"]
    $body = $data | ConvertTo-Json
    $body
    
    $response = Invoke-RestMethod 'http://utools.run/software_inventory' -Method 'POST' -Headers $headers -Body $body -ContentType "application/json;charset=UTF-8"
    $response | ConvertTo-Json

}

$InstalledAppx = Get-AppxPackage  | Select-Object Name,Version,InstallLocation,PackageFullName
foreach($obj in $InstalledAppx)
{
    $softList["Name"] = $obj.Name
    $softList["Version"] = $obj.Version
    $softList["InstallLocation"] = $obj.InstallLocation

    $data["Id"] = $guid
    $data["Message"] = $timestamp + ',' + $hostname + ',' + $softList["Name"] + ',' + $softList["Version"] + ',' + $softList["InstallLocation"]
    $body = $data | ConvertTo-Json
    $body
    
    $response = Invoke-RestMethod 'http://utools.run/software_inventory' -Method 'POST' -Headers $headers -Body $body -ContentType "application/json;charset=UTF-8"
    $response | ConvertTo-Json
}
