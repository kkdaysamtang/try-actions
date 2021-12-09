FROM php:7.3.13-fpm

# APT install
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libzip-dev \
        libpq-dev \
        libpng-dev \
        libxml2-dev \
        libicu-dev \
        libghc-zlib-dev \
        git \
    && rm -rf /var/lib/apt/lists/*

# Install & enable php extension
RUN docker-php-ext-install \
        bcmath \
        zip \
        pdo_pgsql \
        pdo_mysql \
        pgsql \
        gd \
        pcntl \
        opcache \
        soap \
        sockets \
        intl \
    && echo "no" | pecl install apcu \
    && echo "no" | pecl install redis \
    && echo "no" | pecl install grpc \
    && docker-php-ext-enable \
        apcu \
        redis \
        grpc \
    && echo "apc.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --version=1.10.21 --install-dir=/usr/local/bin --filename=composer \
    && php composer-setup.php --version=2.0.12 --install-dir=/usr/local/bin --filename=composer2 \
    && php -r "unlink('composer-setup.php');"
