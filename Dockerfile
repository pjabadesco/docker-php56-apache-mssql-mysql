FROM php:5.6-apache

RUN apt-get update && apt-get install -y --no-install-recommends \
    git zip unzip \
    libcurl4-openssl-dev \
    libedit-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    freetds-dev \
    freetds-bin \
    freetds-common \
    libdbd-freetds \
    libsybdb5 \
    libqt4-sql-tds \
    libqt5sql5-tds \
    libqxmlrpc-dev \
    libmcrypt-dev \
    libpng-dev \
    libmemcached-dev \
    unixodbc \
    unixodbc-dev \
    sendmail \
    exiftool libpng-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
    && docker-php-ext-configure mssql

RUN docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
    --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
    --enable-gd-native-ttf

# RUN set -x \
#     && cd /usr/src/php/ext/odbc \
#     && phpize \
#     && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
#     && ./configure --with-unixODBC=shared,/usr \
#     && docker-php-ext-install odbc

# Memcache
RUN pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

# Redis
# RUN pecl install -o -f redis-2.2.8 \
#     && rm -rf /tmp/pear \
#     && docker-php-ext-enable redis
RUN pecl install redis-2.2.8 \
    && docker-php-ext-enable redis
# RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz \
#     && tar xfz /tmp/redis.tar.gz \
#     && rm -r /tmp/redis.tar.gz \
#     && mv phpredis-2.2.7 /usr/src/php/ext/redis \
#     && docker-php-ext-install redis

RUN docker-php-ext-configure exif \
    && docker-php-ext-install bcmath calendar gettext exif gd pdo pdo_mysql curl json mbstring mysqli pdo_dblib mcrypt zip mysql mssql pdo_odbc opcache

RUN pecl install mongo \
    && docker-php-ext-enable mongo

# Install Ioncube Loader
RUN curl -L https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -o ioncube.tar.gz \
    && tar -xvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.6.so /usr/local/lib/php/extensions/* \
    && rm -rf ioncube.tar.gz ioncube \
    && echo "zend_extension=ioncube_loader_lin_5.6.so" > /usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_5.6.ini    

COPY conf/php.ini /usr/local/etc/php/
COPY conf.d/ /usr/local/etc/php/conf.d/
COPY conf/httpd.conf /etc/apache2/sites-available/000-default.conf

RUN  chmod 755 /var/www/html -R
COPY --chown=www-data:www-data www/ /var/www/html/

RUN a2enmod rewrite headers remoteip

# Create Volume
# VOLUME ['/etc/apache2/sites-enabled','/var/www','/var/log/apache2']
