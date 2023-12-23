FROM node:18.0.0 AS node
FROM php:8.1-fpm AS php

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    zlib1g-dev \
    libicu-dev \
    git \
    unzip \
    jq \
    curl \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) opcache \
    && docker-php-ext-install -j$(nproc) intl

ARG APP_ENV
RUN if [ "${APP_ENV}" = "dev" ]; then pecl install xdebug \
    && docker-php-ext-enable xdebug; fi
COPY ./docker/web/php/conf.d/* /usr/local/etc/php/conf.d-dev/
RUN if [ "${APP_ENV}" = "dev" ]; then cp -r /usr/local/etc/php/conf.d-dev/* /usr/local/etc/php/conf.d/; fi

COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /usr/local/bin/node /usr/local/bin/node
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

COPY ./docker/web/php.ini /usr/local/etc/php/
COPY ./docker/web/www.conf /usr/local/etc/php-fpm.d/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV COMPOSER_ALLOW_SUPERUSER=1

ENV PATH="${PATH}:/root/.composer/vendor/bin"

# On some systems simply linking www-data will not work.
ARG UID
ARG GID
ARG ALT_USER
RUN if  [ "${ALT_USER}" = "1" ]; then groupadd -g "${GID}" shopware && \
    useradd -u "${UID}" -g "${GID}" -m shopware; fi

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R ug+rx /var/www/html

CMD ["php-fpm"]
