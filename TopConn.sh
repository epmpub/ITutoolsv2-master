
ss -tanp | grep ESTAB | grep -v "127.0.0.1" | wc -l

netstat -an | grep ESTABLISHED | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | head

