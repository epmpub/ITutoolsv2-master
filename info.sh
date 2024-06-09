#!/usr/bin/sh



# Define some color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'


#echo "select * from demo.mylog_view where message not like '%latest%' and message not like '%version%'" | clickhouse-client --password Cpp...

echo "==================================================================================================="

echo "${GREEN}network connection:${RESET}"
netstat -antup | grep 'ESTABLISHED' | grep './Server' | grep -v '127.0.0.1'|uniq | sort -k 4

echo "==================================================================================================="

echo "${GREEN}iptables rule${RESET}"

iptables -L -v -n

echo "==================================================================================================="
echo "${GREEN}memory usage${RESET}"

free -h

echo "==================================================================================================="
echo "${GREEN}cpu usage${RESET}"

mpstat

echo "==================================================================================================="
echo "${GREEN}disk usage${RESET}"
df -mh /dev/vda3

counter=`echo "select count(distinct(hostname)) as N from demo.hardware_inventory_view;" | clickhouse-client --password Cpp...`

echo "${GREEN}=======================================<counter is :${counter}>===========================================${RESET}"

#LIST=`echo "select timestamp,hostname,QueryName from demo.winevent22_view where QueryName like '%rarbg%' group by timestamp,hostname,QueryName" | clickhouse-client --password Cpp...`

#echo "${LIST}"
#echo "${LIST}" |wc -l
