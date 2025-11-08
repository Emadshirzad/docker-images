FROM php:8.3-alpine

# --- Install system dependencies ---
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
    libc-dev \
    nodejs \
    npm \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# --- PHP extensions ---
RUN docker-php-ext-install pdo_mysql zip gd bcmath bz2 soap intl

# --- Puppeteer setup ---
# Set proper env vars for Browsershot + Node
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    NODE_PATH=/usr/lib/node_modules \
    PATH=$PATH:/usr/lib/node_modules/.bin

# Install Puppeteer globally (into /usr/lib/node_modules)
RUN npm install -g puppeteer@22.15.0 --prefix /usr

# --- Composer ---
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# --- Laravel Envoy (optional) ---
RUN composer global require "laravel/envoy" \
    && ln -s /root/.composer/vendor/bin/envoy /usr/local/bin/envoy

# --- Cleanup ---
RUN apk del autoconf gcc g++ make libc-dev \
    && rm -rf /var/cache/apk/* /tmp/*

WORKDIR /var/www/html

