go build -o ../Bin/Server && rsync -av --delete ../ root@it2u.cn:~/utools --exclude=.git/

scp startupServer.sh root@it2u.cn:~

ssh root@it2u.cn 'chmod +x startupServer.sh'

ssh root@it2u.cn 'killall Server'

ssh root@it2u.cn 'sh ./startupServer.sh&'
