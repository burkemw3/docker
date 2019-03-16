FROM alpine:latest

ARG WALLABAG_VERSION=2.4

RUN set -ex \
 && apk update \
 && apk upgrade --available \
 && apk add \
      ansible \
      curl \
      git \
      libwebp \
      mariadb-client \
      nginx \
      pcre \
      php7 \
      php7-amqp \
      php7-bcmath \
      php7-ctype \
      php7-curl \
      php7-dom \
      php7-fpm \
      php7-gd \
      php7-gettext \
      php7-iconv \
      php7-json \
      php7-mbstring \
      php7-openssl \
      php7-pdo_mysql \
      php7-pdo_pgsql \
      php7-pdo_sqlite \
      php7-phar \
      php7-session \
      php7-simplexml \
      php7-tokenizer \
      php7-xml \
      php7-zlib \
      php7-sockets \
      php7-xmlreader \
      py-mysqldb \
      py-psycopg2 \
      py-simplejson \
      rabbitmq-c \
      s6 \
      tar \
 && rm -rf /var/cache/apk/* \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 && curl -s https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer \
 && git clone --branch $WALLABAG_VERSION --depth 1 https://github.com/wallabag/wallabag.git /var/www/wallabag

RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
  && echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
  && apk add --no-cache chromium@edge \
  && rm -rf /var/lib/apt/lists/* /var/cache/apk/* /usr/share/man /tmp/*

ENV CHROME_BIN=/usr/bin/chromium-browser \
  CHROME_PATH=/usr/lib/chromium/

# COPY app/app.php /var/www/wallabag/web/app.php

COPY composer.json /var/www/wallabag/composer.json
RUN set -ex \
 && cd /var/www/wallabag \
 && COMPOSER_MEMORY_LIMIT=-1 SYMFONY_ENV=prod composer update --no-dev -o --prefer-dist --no-interaction \
 && chown -R nobody:nobody /var/www/wallabag

#RUN cp /var/www/wallabag/app/config/parameters_test.yml /var/www/wallabag/app/config/parameters.yml
#RUN chown nobody:nobody /var/www/wallabag/app/config/parameters.yml

COPY root /

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["wallabag"]
