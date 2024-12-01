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
conn=`ss -tap | grep ESTAB |grep http | wc -l`
echo "${GREEN}network connection counter is : ${conn} ${RESET}"

non_conn=`ss -tap | grep -v ESTAB | wc -l`
echo "${GREEN}network non connection counter is : ${non_conn} ${RESET}"

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

echo ` date "+%Y-%m-%d %H:%M:%S" ` - counter is: ${counter}  >> counter.log

#LIST=`echo "select timestamp,hostname,QueryName from demo.winevent22_view where QueryName like '%rarbg%' group by timestamp,hostname,QueryName" | clickhouse-client --password Cpp...`

#echo "${LIST}"
#echo "${LIST}" |wc -l
