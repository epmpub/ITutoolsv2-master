# collect ubuntu system hardware infomation
# author : andy.hu
# date: 2024/1/18 17:10

#!/bin/bash
cpu=`sudo lshw -c cpu | grep 'product' |cut -d ':' -f2`
# echo CPU: $cpu

ram=`sudo lshw -c memory | grep "System Memory" -A3 | grep "size" | cut -d':' -f2`
# echo RAM Size: $ram

disk=`sudo fdisk -l | grep "GiB" | cut -d' ' -f3,4`
# echo Disk: $disk

gpu=`sudo lshw -c display | grep product | cut -d':' -f 2`


ethernet=`sudo lshw -c network | grep "Ethernet interface" -A 2 | grep "product"`
# echo Ethernet Controller:$ethernet

wifi=`sudo lshw -c network | grep "Wireless interface" -A3 | grep "product" | cut -d':' -f2`
# echo WIFI: $wifi

soundCard=`sudo lshw -c multimedia | grep "product" | cut -d':' -f 2`
# echo SoundCard: $soundCard


brand=`sudo lshw -c system | grep "product" | head -n 1 | grep "product" | cut -d':' -f2`
# echo Brand: $brand

model=""

os=`lsb_release -d | grep "Description:" |  cut -d':' -f2`
# echo OS: $os

name=`hostname`
# echo HostName: $hostname

ipv4=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'`
# echo IP Address: $ipv4

LastCheckin=`date +"%Y-%m-%d %T"`

uuid=`uuidgen`


echo $name
echo $cpu
echo $ram
echo $disk
echo $gpu
echo $uuid



curl --location --request POST 'http://utools.run:3000/api/hosts' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "'"$name"'",
    "cpu": "'"$cpu"'",
    "ram": "'"$ram"'",
    "disk": "'"$disk"'",
    "gpu": "'"$gpu"'",
    "guid": "'"$uuid"'"
}'
