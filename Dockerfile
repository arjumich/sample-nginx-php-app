FROM wyveo/nginx-php-fpm:php80

RUN adduser --disabled-password --gecos '' --home "/home/adminuser" adminuser
COPY ./supervisord.conf /etc/supervisord.conf

#RUN sed -i 's+user=root+;user=root+g' /etc/supervisord.conf

RUN chown -R adminuser:adminuser /etc/nginx
RUN chown -R adminuser:adminuser /var/log && chmod -R 777 /var/log
RUN chown -R adminuser:adminuser /var/cache/nginx && chmod -R 777 /var/cache/nginx
RUN chown -R adminuser:adminuser /var/run && chmod -R 777 /var/run
RUN chown -R adminuser:adminuser /run/php && chmod -R 777 /var/run/php

#RUN sed -i 's+listen.owner = nginx+listen.owner = www-data+g' /etc/php/8.0/fpm/pool.d/www.conf \
#    && sed -i 's+listen.group = nginx+listen.owner = www-data+g' /etc/php/8.0/fpm/pool.d/www.conf \
#    && sed -i 's+;listen.mode = 0660+listen.mode = 0660+g' /etc/php/8.0/fpm/pool.d/www.conf

RUN sed -i 's+listen.owner = nginx+;listen.owner = www-data+g' /etc/php/8.0/fpm/pool.d/www.conf \
    && sed -i 's+listen.group = nginx+;listen.owner = www-data+g' /etc/php/8.0/fpm/pool.d/www.conf

RUN sed -i 's+listen   80+listen   8080+g' /etc/nginx/conf.d/default.conf
RUN sed -i 's+error_log = /var/log/php8.0-fpm.log+error_log = /var/log/nginx/php8.0-fpm.log+g' /etc/php/8.0/fpm/php-fpm.conf


USER adminuser