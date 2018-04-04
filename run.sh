#!/bin/bash 

PORT=3306

env
ENGINE=`echo $BST_ENGINE| tr '[:lower:]' '[:upper:]'`
engine=`echo $ENGINE | tr '[:upper:]' '[:lower:]'`

for i in HOSTNAME DATABASE USERNAME PASSWORD; do  
	#NAME=${engine}_${i}; 
	NAME=BST_${i}; 
	export ${i}=${!NAME}; 
	echo $i=${!i}  ; 
done; 

case $engine in 
   "mysql"|"mariadb") e="mariadb" ;;
   *) e=$engine;;
   esac
	

URI="jdbc:$e://$HOSTNAME:$PORT/$DATABASE"

sed -i "s@\(DB\.Url=\).*\$@\1${URI}@" conf/brs-default.properties
sed -i "s/\(DB\.Username=\).*\$/\1${USERNAME}/" conf/brs-default.properties
sed -i "s/\(DB\.Password=\).*\$/\1${PASSWORD}/" conf/brs-default.properties

sed -i "s@\(nxt\.dbUrl=\).*\$@\1${URI}@" conf/nxt-default.properties
sed -i "s/\(nxt\.dbUsername=\).*\$/\1${USERNAME}/" conf/nxt-default.properties
sed -i "s/\(nxt\.dbPassword=\).*\$/\1${PASSWORD}/" conf/nxt-default.properties



while ! exec 2>/dev/null 6<>/dev/tcp/${HOSTNAME}/${PORT} 2>/dev/null; do
    echo "$(date) - still trying to connect to $engine at ${HOSTNAME}:${PORT}"
    sleep 1
done

exec 6>&-
exec 6<&-

 echo " ready";

exec /bin/bash ./burst.sh
