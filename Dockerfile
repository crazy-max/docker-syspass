FROM alpine:3.9

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="CrazyMax" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="syspass" \
  org.label-schema.description="sysPass" \
  org.label-schema.version=$VERSION \
  org.label-schema.url="https://github.com/crazy-max/docker-syspass" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/crazy-max/docker-syspass" \
  org.label-schema.vendor="CrazyMax" \
  org.label-schema.schema-version="1.0"

RUN apk --update --no-cache add \
    ca-certificates \
    curl \
    libressl \
    libxml2 \
    mysql-client \
    nginx \
    php7 \
    php7-cli \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fileinfo \
    php7-fpm \
    php7-gd \
    php7-gettext \
    php7-iconv \
    php7-intl \
    php7-json \
    php7-ldap \
    php7-mbstring \
    php7-mcrypt \
    php7-mysqlnd \
    php7-opcache \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-phar \
    php7-session \
    php7-simplexml \
    php7-tokenizer \
    php7-xml \
    php7-xmlwriter \
    php7-zip \
    shadow \
    supervisor \
    tzdata  \
  && sed -i -e "s/;date\.timezone.*/date\.timezone = UTC/" /etc/php7/php.ini \
  && rm -rf /var/cache/apk/* /var/www/* /tmp/*

ENV SYSPASS_VERSION="3.0.5.19020701"

RUN apk --update --no-cache add -t build-dependencies \
    git \
  && mkdir -p /var/www \
  && addgroup -g 1000 syspass \
  && adduser -u 1000 -G syspass -h /var/www -s /bin/sh -D syspass \
  && passwd -l syspass \
  && usermod -a -G syspass nginx \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
  && git clone --branch ${SYSPASS_VERSION} https://github.com/nuxsmin/sysPass.git /var/www \
  && chown -R syspass. /var/www \
  && su - syspass -c "composer install --no-dev --no-interaction --no-ansi --working-dir=/var/www" \
  && sed -i "s/define('CONFIG_PATH'.*/define('CONFIG_PATH', '\/data\/config');/" /var/www/lib/Base.php \
  && sed -i "s/define('BACKUP_PATH'.*/define('BACKUP_PATH', '\/data\/backup');/" /var/www/lib/Base.php \
  && sed -i "s/define('CACHE_PATH'.*/define('CACHE_PATH', '\/data\/cache');/" /var/www/lib/Base.php \
  && chown -R syspass. /var/www \
  && chown -R nginx. /var/lib/nginx /var/log/nginx /var/log/php7 /var/tmp/nginx \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/* \
    /var/www/.composer \
    /var/www/.git \
    /var/www/tests \
    /var/www/.gitignore \
    /var/www/.travis* \
    /var/www/composer* \
    /tmp/*

COPY entrypoint.sh /entrypoint.sh
COPY assets /

RUN mkdir -p /var/log/supervisord \
  && chmod a+x /entrypoint.sh

EXPOSE 8000
WORKDIR /var/www
VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
