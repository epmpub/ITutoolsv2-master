 while read p; do
  echo "$p" | clickhouse-client --password Cpp... ;
 done <createTables.sqlx
