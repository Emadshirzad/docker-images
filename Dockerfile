FROM php:8.3-alpine

# Install dependencies (using apk for Alpine)
RUN apk update && apk add --no-cache \
    bash \
    git \
    curl \
    libzip-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    freetype-dev \
    bzip2-dev \
    libxml2-dev \
    icu-dev \
    autoconf \
    gcc \
    g++ \
    make \
    libc-dev

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql zip gd bcmath bz2 soap intl

# Install Node, npm, Chromium, and Puppeteer
RUN apk add --no-cache \
    nodejs \
    npm \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

RUN npm install -g puppeteer@22.15.0 && \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Install Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel Envoy globally
RUN composer global require "laravel/envoy" \
    && ln -s /root/.composer/vendor/bin/envoy /usr/local/bin/envoy

# Clean up
RUN apk del autoconf gcc g++ make libc-dev \
    && rm -rf /var/cache/apk/*
