# nginx-php-fpm App
#####
### For local Testing

**Build**
```sh
docker build -t klovercloud/nginx-php:latest .
```
**Run**
```sh
docker run --rm --name testnginx -p 8080:8080 --read-only --tmpfs=/tmp --tmpfs=/var/log --tmpfs=/var/cache/nginx --tmpfs=/run/php/ -v /home/arjun/Docker-vol/nginx-php-vol/nginx-conf:/etc/nginx klovercloud/nginx-php:latest
```
### Notes
- Running nginx with php-fpm (php 8)
- mounted nginx configuration files 
- User files can be mounted on /usr/share/nginx/html