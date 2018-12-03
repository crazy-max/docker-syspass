#!/bin/sh

function runas_syspass() {
  su - syspass -s /bin/sh -c "$1"
}

TZ=${TZ:-UTC}
PUID=${PUID:-1000}
PGID=${PGID:-1000}

MEMORY_LIMIT=${MEMORY_LIMIT:-256M}
UPLOAD_MAX_SIZE=${UPLOAD_MAX_SIZE:-16M}
OPCACHE_MEM_SIZE=${OPCACHE_MEM_SIZE:-128}

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone
sed -i -e "s|date\.timezone.*|date\.timezone = ${TZ}|" /etc/php7/php.ini \

# Change syspass UID / GID
echo "Checking if syspass UID / GID has changed..."
if [ $(id -u syspass) != ${PUID} ]; then
  usermod -u ${PUID} syspass
fi
if [ $(id -g syspass) != ${PGID} ]; then
  groupmod -g ${PGID} syspass
fi

# PHP
echo "Setting PHP-FPM configuration..."
sed -e "s/@MEMORY_LIMIT@/$MEMORY_LIMIT/g" \
  -e "s/@UPLOAD_MAX_SIZE@/$UPLOAD_MAX_SIZE/g" \
  /tpls/etc/php7/php-fpm.d/www.conf > /etc/php7/php-fpm.d/www.conf

# OpCache
echo "Setting OpCache configuration..."
sed -e "s/@OPCACHE_MEM_SIZE@/$OPCACHE_MEM_SIZE/g" \
  /tpls/etc/php7/conf.d/opcache.ini > /etc/php7/conf.d/opcache.ini

# Nginx
echo "Setting Nginx configuration..."
sed -e "s/@UPLOAD_MAX_SIZE@/$UPLOAD_MAX_SIZE/g" \
  /tpls/etc/nginx/nginx.conf > /etc/nginx/nginx.conf

# Check first install
firstInstall=0
if [[ ! -d /data/config ]]; then
  firstInstall=1
  echo "Copying config files..."
  cp -Rf /var/www/app/config /data/config
fi

echo "Initializing sysPass files / folders..."
mkdir -p /data/backup /data/cache /data/config
rm -rf /var/www/app/backup /var/www/app/cache /var/www/app/config

# Fix perms
echo "Fixing permissions..."
chown -R syspass. /data
chmod 750 /data/backup /data/cache /data/config

exec "$@"
