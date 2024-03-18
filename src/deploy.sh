go build -o ../Bin/Server && rsync -av --delete ../ root@47.107.152.77:~/utools --exclude=.git/

scp startupServer.sh root@47.107.152.77:~

ssh root@47.107.152.77 'chmod +x startupServer.sh'

ssh root@47.107.152.77 'killall Server'

ssh root@47.107.152.77 'sh ./startupServer.sh&'

# sh ./update.sh& 47.107.152.77