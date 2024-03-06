go build && rsync -av ../ root@47.107.152.77:~/utools --exclude=.git/

scp startup.sh root@47.107.152.77:~

ssh root@47.107.152.77 'chmod +x startup.sh'

ssh root@47.107.152.77 'killall utools'

ssh root@47.107.152.77 'sh ./startup.sh&'

# sh ./update.sh& 47.107.152.77