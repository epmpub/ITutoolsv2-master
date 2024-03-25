
# author:andy.hu
# date:2020-03-20 10:16AM
# description: collect autorun information and send to utools.run

$ProgressPreference = 'SilentlyContinue'

# Add-MpPreference -ExclusionPath C:\tools -ErrorAction SilentlyContinue

if ((Get-MpComputerStatus).AMServiceEnabled) {
    Add-MpPreference -ExclusionPath C:\tools -ErrorAction SilentlyContinue
    Add-MpPreference -ExclusionPath C:\tools2 -ErrorAction SilentlyContinue
}



if (Test-Path -Path "C:\tools\autorunsc64.exe") {
    Write-Host "Yes"
}
else {
    Write-Host "autorunsc64.exe not exists, download it"
    Invoke-WebRequest -Uri "http://utools.run/Autoruns.zip" -OutFile "C:\tools\Autoruns.zip"
    Expand-Archive -Path "C:\tools\Autoruns.zip" -DestinationPath "C:\tools\"
    Remove-Item -Path "C:\tools\Autoruns.zip"
}

C:\tools\autorunsc64.exe -nobanner -accepteula -a smlt -m  -c > C:\tools\autorun.log

$autoruns = import-csv -Path C:\tools\autorun.log

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
    # $body = $autorunData | ConvertTo-Json

    # to mongodb
    # Invoke-RestMethod 'http://utools.run/autorun2mongodb' -Method 'POST' -Headers $headers -Body $body

    # to clickhouse
    $data["Id"] = $guid
    $data["Message"] = $createTime.toString() + ',' +
    $autorunData["entrytime"] + ',' +
    $env:COMPUTERNAME + ',' +
    $autorunData["entrylocation"] + ',' +
    $autorunData["entryname"] + ',' +
    $autorunData["enabled"] + ',' +
    $autorunData["category"] + ',' +
    $autorunData["profile"] + ',' +
    $autorunData["description"] + ',' +
    $autorunData["company"] + ',' +
    $autorunData["imagepath"] + ',' +
    $autorunData["versioin"] + ',' +
    $autorunData["launchstring"]

    $body = $data | ConvertTo-Json

    $response = Invoke-RestMethod 'http://utools.run/autorun' -Method 'POST' -Headers $headers -Body $body
    $response | ConvertTo-Json
}