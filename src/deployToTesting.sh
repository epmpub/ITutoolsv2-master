go build -o ../Bin/Server && rsync -av --delete ../ root@39.108.176.143:~/utools --exclude=.git/

scp startupServer.sh root@39.108.176.143:~

ssh root@39.108.176.143 'chmod +x startupServer.sh'

ssh root@39.108.176.143 'killall Server'

ssh root@39.108.176.143 'sh ./startupServer.sh&'
