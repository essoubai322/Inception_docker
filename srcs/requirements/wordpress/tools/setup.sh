#!/bin/bash
set -e

until mysql -h mariadb -u ${WP_DB_USER} -p${WP_DB_PASSWORD} -e "SELECT 1"; do
  echo "Waiting for MariaDB..."
  sleep 5
done

if [ ! -f "/var/www/html/wp-config-sample.php" ]; then
    echo "WordPress not found in volume, downloading..."
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz -C /var/www/html --strip-components=1
    rm latest.tar.gz
    chown -R www-data:www-data /var/www/html
fi

if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Configuring WordPress..."
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/database_name_here/${WP_DB_NAME}/g" /var/www/html/wp-config.php
    sed -i "s/username_here/${WP_DB_USER}/g" /var/www/html/wp-config.php
    sed -i "s/password_here/${WP_DB_PASSWORD}/g" /var/www/html/wp-config.php
    sed -i "s/localhost/${WP_DB_HOST}/g" /var/www/html/wp-config.php
fi

if  ! mysql -h mariadb -u ${WP_DB_USER} -p${WP_DB_PASSWORD} -e "USE ${WP_DB_NAME}; SHOW TABLES;" | grep -q .; then
    echo "Installing WordPress automatically..."
    
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    
    wp core install --url="https://${DOMAIN_NAME}" \
                --title="My WordPress Site" \
                --admin_user=${WP_DB_USER} \
                --admin_password="${WP_DB_PASSWORD}" \
                --admin_email=${WP_DB_MAIL} \
                --skip-email \
                --path=/var/www/html \
                --allow-root

    wp theme install blocksy --activate --path=/var/www/html --allow-root

    echo "WordPress installed automatically!"
else
    echo "WordPress already installed."
fi

echo "Starting PHP-FPM..."
php-fpm8.2 -F