#!/bin/bash 

PORT=3306
FILE="conf/brs.properties"

ENGINE=`echo $BST_ENGINE| tr '[:lower:]' '[:upper:]'`
engine=`echo $ENGINE | tr '[:upper:]' '[:lower:]'`

for i in HOSTNAME DATABASE USERNAME PASSWORD; do  
	#NAME=${engine}_${i}; 
	NAME=BST_${i}; 
	export ${i}=${!NAME}; 
done; 

case $engine in 
   "mysql"|"mariadb") e="mariadb" ;;
   *) e=$engine;;
   esac
	

URI="jdbc:$e://$HOSTNAME:$PORT/$DATABASE"

sed -i "s@\(DB\.Url=\).*\$@\1${URI}@" $FILE
sed -i "s/\(DB\.Username=\).*\$/\1${USERNAME}/" $FILE
sed -i "s/\(DB\.Password=\).*\$/\1${PASSWORD}/" $FILE

sed -i "s@\(nxt\.dbUrl=\).*\$@\1${URI}@" conf/nxt-default.properties
sed -i "s/\(nxt\.dbUsername=\).*\$/\1${USERNAME}/" conf/nxt-default.properties
sed -i "s/\(nxt\.dbPassword=\).*\$/\1${PASSWORD}/" conf/nxt-default.properties



while ! bash -c "cat < /dev/null > /dev/tcp/${HOSTNAME}/${PORT}" 2>/dev/null; do
    echo "$(date) - still trying to connect to $engine at ${HOSTNAME}:${PORT}"
    sleep 1
done
echo " ${HOSTNAME}:${PORT} ready";

exec java -jar burst.jar
