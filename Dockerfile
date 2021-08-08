FROM php:5.6-apache
MAINTAINER Paolo Josef Abadesco <pjabadesco@gmail.com>

ARG PATH_WWW=www
ENV PATH_WWW $PATH_WWW

RUN apt-get update && apt-get install -y --no-install-recommends \
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
    unixodbc \
    unixodbc-dev \
    sendmail \
    exiftool libpng-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/* \
    && chmod 755 /var/www/html -R \
    && chown www-data:www-data /var/www/html 

RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
    && docker-php-ext-configure mssql

RUN docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
    --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
    --enable-gd-native-ttf

RUN docker-php-ext-configure exif

# RUN set -x \
#     && cd /usr/src/php/ext/odbc \
#     && phpize \
#     && sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure \
#     && ./configure --with-unixODBC=shared,/usr \
#     && docker-php-ext-install odbc

RUN docker-php-ext-install exif gd pdo pdo_mysql curl json mbstring mysqli pdo_dblib mcrypt zip mysql mssql pdo_odbc opcache

RUN docker-php-ext-enable exif

RUN echo 'date.timezone = Asia/Manila' >> /usr/local/etc/php/php.ini
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY conf/php.ini /usr/local/etc/php/
COPY conf.d/ /usr/local/etc/php/conf.d/
COPY conf/httpd.conf /etc/apache2/sites-available/000-default.conf
COPY $PATH_WWW/ /var/www/html/

COPY $PATH_WWW/_docker/run.sh /usr/local/bin/docker-run.sh
RUN chmod +x /usr/local/bin/docker-run.sh

RUN a2enmod rewrite headers

# Memcache
# RUN pecl install memcached-2.2.0 \
#     && docker-php-ext-enable memcached

# Create Volume
# VOLUME ['/etc/apache2/sites-enabled','/var/www','/var/log/apache2']
