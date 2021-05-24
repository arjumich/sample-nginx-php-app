FROM wyveo/nginx-php-fpm:php80

RUN adduser --disabled-password --gecos '' --home "/home/adminuser" adminuser
#COPY ./supervisord.conf /etc/supervisord.conf
COPY ./start.sh /start.sh
RUN chmod +x /start.sh

RUN sed -i 's+user=root+;user=root+g' /etc/supervisord.conf

RUN mkdir /etc/nginx-tmp/
RUN cp -rp /etc/nginx/. /etc/nginx-tmp/.

RUN chown -R adminuser:adminuser /etc/nginx
RUN chown -R adminuser:adminuser /var/log && chmod -R 777 /var/log
RUN chown -R adminuser:adminuser /var/cache/nginx && chmod -R 777 /var/cache/nginx
RUN chown -R adminuser:adminuser /var/run && chmod -R 777 /var/run/ && chmod -R 777 /var/run/php
RUN chown -R adminuser:adminuser /run/php && chmod -R 777 /run/php/

RUN ls -ld /run/php
RUN php-fpm8.0 -D

#RUN sed -i 's+listen.owner = nginx+listen.owner = www-data+g' /etc/php/8.0/fpm/pool.d/www.conf \
#    && sed -i 's+listen.group = nginx+listen.owner = www-data+g' /etc/php/8.0/fpm/pool.d/www.conf \
#    && sed -i 's+;listen.mode = 0660+listen.mode = 0660+g' /etc/php/8.0/fpm/pool.d/www.conf

RUN sed -i 's+listen.owner = nginx+;listen.owner = nginx+g' /etc/php/8.0/fpm/pool.d/www.conf \
    && sed -i 's+listen.group = nginx+;listen.owner = nginx+g' /etc/php/8.0/fpm/pool.d/www.conf

RUN sed -i 's+listen   80+listen   8080+g' /etc/nginx-tmp/conf.d/default.conf
#RUN sed -i 's+error_log = /var/log/php8.0-fpm.log+error_log = /var/log/nginx/php8.0-fpm.log+g' /etc/php/8.0/fpm/php-fpm.conf
#RUN sed -i 's+;php_admin_value[error_log] = /var/log/fpm-php.www.log+php_admin_value[error_log] = /var/log/nginx/fpm-php.www.log+g' /etc/php/8.0/fpm/pool.d/www.conf
RUN sed -i 's+error_log  /var/log/nginx/error.log+error_log  /var/log/error.log+g' /etc/nginx-tmp/nginx.conf
RUN sed -i 's+access_log  /var/log/nginx/access.log+access_log  /var/log/access.log+g' /etc/nginx-tmp/nginx.conf

RUN sed -i 's+/var/run/nginx.pid+/var/run/php/nginx.pid+g' /etc/nginx-tmp/nginx.conf


USER adminuser