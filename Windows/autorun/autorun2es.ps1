$API_KEY='ApiKey MXV1Tl80NEJ6enlLeTRkbU5ldzI6TzIwVF9rTnpSZXUxc0ZoZUlqRDU0QQ=='
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

    $body = $autorunData | ConvertTo-Json
    
irm -Uri http://192.168.3.100:9200/student/_doc -ContentType "application/json" -Headers @{'Authorization' = $API_KEY} -Method Post -Body $body
}