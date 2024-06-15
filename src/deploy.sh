go build -o ../Bin/Server && rsync -av --delete ../ root@utools.run:~/utools --exclude=.git/

scp startupServer.sh root@utools.run:~

ssh root@utools.run 'chmod +x startupServer.sh'

ssh root@utools.run 'killall Server'

ssh root@utools.run 'sh ./startupServer.sh&'
