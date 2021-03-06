#Dockerfile Args
ARG PHP_V

# PHP version
FROM php:${PHP_V}-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl \
    libmemcached-dev \
    libz-dev \
    libjpeg-dev \
    libpng-dev \
    libwebp-dev \
    libssl-dev \
    libmcrypt-dev \
    less \
    nano \
    vim \
    cron \
    git \
    unzip \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN apt-get install ${PHP_V}-common || true 
RUN docker-php-ext-install common || true
RUN apt-get install ${PHP_V}-pear || true
RUN docker-php-ext-install pear && docker-php-ext-enable pear || true    
RUN apt-get install ${PHP_V}-intl || true
RUN docker-php-ext-install intl && docker-php-ext-enable intl || true
RUN apt-get install ${PHP_V}-opcache || true
RUN docker-php-ext-install opcache && docker-php-ext-enable opcache || true
RUN apt-get install ${PHP_V}-pdo || true
RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql || true
RUN apt-get install ${PHP_V}-mbstring || true 
RUN docker-php-ext-install mbstring && docker-php-ext-enable mbstring || true
RUN apt-get install ${PHP_V}-zip || true 
RUN docker-php-ext-install zip && docker-php-ext-enable zip || true
RUN apt-get install ${PHP_V}-memcache || true 
RUN docker-php-ext-install memcache && docker-php-ext-enable memcache || true
RUN apt-get install ${PHP_V}-json || true 
RUN docker-php-ext-install json && docker-php-ext-enable json || true
RUN apt-get install ${PHP_V}-xml || true 
RUN docker-php-ext-install xml && docker-php-ext-enable xml || true
RUN apt-get install ${PHP_V}-exif || true 
RUN docker-php-ext-install exif && docker-php-ext-enable exif || true
RUN apt-get install ${PHP_V}-redis || true 
RUN docker-php-ext-install redis && docker-php-ext-enable redis || true
RUN apt-get install ${PHP_V}-mongodb || true 
RUN docker-php-ext-install mongodb && docker-php-ext-enable mongodb || true
RUN apt-get install ${PHP_V}-bcmatch || true 
RUN docker-php-ext-install bcmatch && docker-php-ext-enable bcmatch || true
RUN apt-get install ${PHP_V}-ctype || true 
RUN docker-php-ext-install ctype && docker-php-ext-enable ctype || true
RUN apt-get install ${PHP_V}-ccurl || true 
RUN docker-php-ext-install curl && docker-php-ext-enable curl || true
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/* || true
RUN pecl install imagick || true
RUN docker-php-ext-enable imagick || true
RUN apk add libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev gd && docker-php-ext-install gd || true
RUN apt-get install ${PHP_V}-gd || true 
RUN docker-php-ext-install gd && docker-php-ext-enable gd || true
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp || true
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-webp-dir=/usr/include/ || true

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install node & npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Add user
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# User permissions
RUN chown -R www:www /var/www

# Change current user to www
USER www

# Expose port 9000
EXPOSE 9000
CMD ["php-fpm"]
