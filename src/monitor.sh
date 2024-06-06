!#usr/bin/sh

while true;do
        sleep 3
        ps aux | grep "Server" | grep -v grep || sh startupServer.sh
done