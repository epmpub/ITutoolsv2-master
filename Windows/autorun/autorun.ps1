
# author:andy.hu
# date:2020-03-20 10:16AM
# description: collect autorun information and send to utools.run

$ProgressPreference = 'SilentlyContinue'
$dstPath="C:\utools"

if (-not (Test-Path -Path $dstPath) ) {
    New-Item -Path $targetDirectory -ItemType Directory | Out-Null
}

# Add-MpPreference -ExclusionPath C:\tools -ErrorAction SilentlyContinue

if ((Get-MpComputerStatus).AMServiceEnabled) {
    Add-MpPreference -ExclusionPath $dstPath -ErrorAction SilentlyContinue
}



if (Test-Path -Path $dstPath"\autorunsc64.exe") {
    Write-Host "Bin file Exists,Download Skipped"
}
else {
    Write-Host "autorunsc64.exe not exists, download it"
    Invoke-WebRequest -Uri "http://utools.run/autorunsc64.exe" -OutFile $dstPath"\autorunsc64.exe"
}

c:\utools\autorunsc64.exe -nobanner -accepteula -a smlt -m  -c > $dstPath"\autorun.log"

$autoruns = import-csv -Path $dstPath"\autorun.log"

$guid = New-Guid
$autorunData = [ordered]@{}
$data = [ordered]@{}

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json;charset=UTF-8")

$createTime = Get-Date -format "yyyy-MM-dd HH:mm:ss"

foreach ($item in $autoruns) {
    $autorunData["entrytime"] = $item.Time.ToString()
    $autorunData["entrylocation"] = $item.'Entry Location'
    $autorunData["entryname"] = $item.Entry
    $autorunData["enabled"] = $item.Enabled

    $autorunData["category"] = $item.Category
    $autorunData["profile"] = $item.Profile
    $autorunData["description"] = $item.Description
    $autorunData["company"] = $item.Company

    $autorunData["imagepath"] = $item.'Image Path'
    $autorunData["versioin"] = $item.Version
    $autorunData["launchstring"] = $item.'Launch String'
    $autorunData["guid"] = $guid

    $data["Id"] = $guid
    $data["Message"] = $createTime.toString() + '$' +
    $autorunData["entrytime"] + '$' +
    $env:COMPUTERNAME + '$' +
    $autorunData["entrylocation"] + '$' +
    $autorunData["entryname"] + '$' +
    $autorunData["enabled"] + '$' +
    $autorunData["category"] + '$' +
    $autorunData["profile"] + '$' +
    $autorunData["description"] + '$' +
    $autorunData["company"] + '$' +
    $autorunData["imagepath"] + '$' +
    $autorunData["versioin"] + '$' +
    $autorunData["launchstring"]

    $body = $data | ConvertTo-Json

    $response = Invoke-RestMethod 'http://utools.run/autorun' -Method 'POST' -Headers $headers -Body $body
    $response | ConvertTo-Json
}