# in utools folder;
# sudo apt install inotify-tools
# https://downloads.mongodb.com/compass/mongodb-mongosh_2.1.1_amd64.deb
# https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.9.4.tgz
# nohup sh insertDB.sh &

inotifywait -m -e create .| while read -r dir action file;do mongoimport -d health -c proc $file;done
