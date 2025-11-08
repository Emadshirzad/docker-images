FROM node:24-alpine

# --- Install system dependencies ---
RUN apk update && apk add --no-cache \
    bash \
    git \
    curl \
    npm \
    chromium


# --- Puppeteer setup ---
# Set proper env vars for Browsershot + Node
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    NODE_PATH=/usr/lib/node_modules \
    PATH=$PATH:/usr/lib/node_modules/.bin

# Install Puppeteer globally (into /usr/lib/node_modules)
RUN npm install -g puppeteer@22.15.0 --prefix /usr

RUN rm -rf /var/cache/apk/* /tmp/*

WORKDIR /var/www/html

