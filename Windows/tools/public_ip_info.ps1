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
    Invoke-RestMethod utools.run/mylog -Method Post -Body $jsdata -ContentType "application/json;charset=UTF-8"
}

$PUB_IP = Invoke-RestMethod http://checkip.amazonaws.com

$PUB_IP_INFO =  Invoke-RestMethod https://whois.pconline.com.cn/ipJson.jsp?json=true"&"ip=$PUB_IP

mylog($PUB_IP_INFO.ip + ":" + $PUB_IP_INFO.addr)
