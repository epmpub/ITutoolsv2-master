dt=`date +"%Y-%m-%d %T"`
inotifywait -m -e create /root/utools/API/data| while read -r dir action file;do mongoimport -d health -c proc $dir$file && echo $dt":insert fie:"$dir$file":OK" >>db.log;done
