echo 'WARNING:: please use command : sed -i 's/OLDDB_NAME/NEWDB_NAME/g' *.* to update script first IF YOU NOT USE DEFAUT Database Name !!!!'
echo 'WARNING:: please use command : cat *.sql to query database name !!!!'
./dropDB.sh && ./createTables.sh && ./createViews.sh
