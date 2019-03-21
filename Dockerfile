FROM php:7.2-fpm

RUN apt-get update && \
    apt-get install -y --force-yes --no-install-recommends \
        unzip \
        curl \
        git \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        libmagickwand-dev \
        libxml2-dev

# Install soap extention
RUN docker-php-ext-install soap

# Install for image manipulation
RUN docker-php-ext-install exif

# Install the PHP mcrypt extention (from PECL, mcrypt has been removed from PHP 7.2)
RUN pecl install mcrypt-1.0.1
RUN docker-php-ext-enable mcrypt

# Install the PHP pcntl extention
RUN docker-php-ext-install pcntl

# Install the PHP zip extention
RUN docker-php-ext-install zip

# Install the PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql

# Install the PHP pdo_pgsql extention
RUN docker-php-ext-install pdo_pgsql

# Install the PHP bcmath extension
RUN docker-php-ext-install bcmath

#####################################
# Imagick:
#####################################

RUN pecl install imagick && \
    docker-php-ext-enable imagick

#####################################
# GD:
#####################################

# Install the PHP gd library
RUN docker-php-ext-install gd && \
    docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

#####################################
# PHP Memcached:
#####################################

# Install the php memcached extension
RUN pecl install memcached && \
    docker-php-ext-enable memcached

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

COPY ./conf/php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www

CMD ["php-fpm"]