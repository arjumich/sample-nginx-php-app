#!/bin/bash

ls -ld /run/php/
sleep 5

#### KLOVERCLOUD CHANGES (START) ####
#### Persisting the nginx configuration files####

if [ -d "/etc/nginx/" ]
then
	echo '[INFO] Persistant volume mounted'
	fileCount=$(find /etc/nginx -type f | wc -l)
	if [ $fileCount -gt 4 ]
         then
         echo "[INFO] nginx configuration files exists"
	else
		echo "[INFO] Copying nginx configuration files to /etc/nginx/";
		cp -r /etc/nginx-tmp/. /etc/nginx/.
		echo "[INFO] All nginx configuration files copied to /etc/nginx/";
	fi
else
	echo '[ERROR] /etc/nginx/ doesnt exists'
fi

ls -ld /run/php/
sleep 5

#### KLOVERCLOUD CHANGES (END) ####

# Update nginx to match worker_processes to no. of cpu's
procs=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i -e "s/worker_processes  1/worker_processes $procs/" /etc/nginx/nginx.conf

# Always chown webroot for better mounting
chown -Rf nginx:nginx /usr/share/nginx/html

# Start supervisord and services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf