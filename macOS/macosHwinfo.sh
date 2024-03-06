SN=`system_profiler SPHardwareDataType | awk '/Serial Number/ {print $4}'`
CPU=`system_profiler SPHardwareDataType | awk '/Processor Name/ {print $3,$4,$5}'`
RAM=`system_profiler SPHardwareDataType | awk '/Memory/ {print $2,$3}'`
SATADISK=`system_profiler SPSerialATADataType   | awk '/Capacity/{print $0}' | head -n 1 |awk '/Capacity/{print $2,$3}'`

SSDDisk=`system_profiler SPStorageDataType | awk '/Capacity/ {print $2,$3}'`

DISK=${SATADISK:-$SSDDisk}

UserName=`ls -la /dev/console | cut -d" " -f4`

Model=`system_profiler SPHardwareDataType | awk '/Model Name/ {print $3,$4}'`
LastCheckin=`date +"%Y-%m-%d %T"`

WIFI_MAC=`system_profiler SPNetworkDataType | awk '/MAC Address/ {print $3}'`
LAN_MAC=`system_profiler SPNetworkDataType | awk '/MAC Address/ {print $3}'`
FullName=`id -F $UserName`
HostName=`hostname`

curl --location --request POST 'http://utools.run/data' \
--header 'Content-Type: application/json' \
--data-raw '{
    "SN": "'"$SN"'",
    "CPU": "'"$CPU"'",
    "RAM": "'"$RAM"'",
    "DISK": "'"$DISK"'",
    "UserName": "'"$UserName"'",
    "Brand": "Apple",
    "Model": "'"$Model"'",
    "HostName": "'"$HostName"'",
    "LastCheckin": "'"$LastCheckin"'",
    "userList":[
        {
            "UserName":"'"$UserName"'"
        },
        {
            "FullName":"'"$FullName"'"
        }
    ],
    "MacAddrList":[
        {
            "Caption":"WIFI",
            "Mac":"'"$WIFI_MAC "'"
        },
        {
            "Caption":"LAN",
            "MAC":"'"$LAN_MAC "'"
        }
    ]
    	
}'

