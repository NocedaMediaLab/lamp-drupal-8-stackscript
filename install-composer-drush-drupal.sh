#!/bin/bash

# <UDF name="domain" Label="Domain" example="Domain for FQDN" />
# <UDF name="ssuser" Label="New limited user" example="username" />
# <UDF name="db_name" Label="Database Name" />
# <UDF name="db_user" Label="New user for the database" />
# <UDF name="db_password" Label="Password for the new database user" />
# <UDF name="drupal_admin" Label="Drupal admin username" />
# <UDF name="drupal_password" Label="Drupal admin password" />
# <UDF name="email" Label="Email for your Drupal admin account" />

#### INSTALL COMPOSER #########################################################
cd /home/"$SSUSER"/
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --quiet
rm composer-setup.php
sudo mv composer.phar /usr/local/bin/composer

#### INSTALL DRUPAL ###########################################################
cd /var/www/webapps/$DOMAIN
composer create-project --no-install drupal/recommended-project drupal

cd drupal
sed -i 's+"web-root": "web/"+"web-root": "public/"+g' composer.json
sed -i 's+"web/core"+"public/core"+g' composer.json
sed -i 's+"web/libraries/{$name}"+"public/libraries/{$name}"+g' composer.json
sed -i 's+"web/modules/contrib/{$name}"+"public/modules/contrib/{$name}"+g' composer.json
sed -i 's+"web/profiles/contrib/{$name}"+"public/profiles/contrib/{$name}"+g' composer.json
sed -i 's+"web/themes/contrib/{$name}"+"public/themes/contrib/{$name}"+g' composer.json
sed -i 's+"web/modules/custom/{$name}"+"public/modules/custom/{$name}"+g' composer.json
sed -i 's+"web/themes/custom/{$name}"+"public/themes/custom/{$name}"+g' composer.json

# Install Drush and additional contrib modules
composer require drush/drush drupal/admin_toolbar drupal/memcache

wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush

mkdir ./public/sites/default/files
chmod a+w ./public/sites/default/files
cp ./public/sites/default/default.settings.php ./public/sites/default/settings.php
chmod a+w ./public/sites/default/settings.php

# Set trusted hosts -- this will show a warning in Drupal if it is not set.
PARSED_DOMAIN="${DOMAIN//\./\\.}"
cat <<END >> ./public/sites/default/settings.php
\$settings['trusted_host_patterns'] = array(
   '^$PARSED_DOMAIN$',
   '^www\.$PARSED_DOMAIN$',
 );

 // Memcache module
 $conf['cache_backends'][] = 'sites/all/modules/contrib/memcache/memcache.inc';
 $conf['lock_inc'] = 'sites/all/modules/contrib/memcache/memcache-lock.inc';
 $conf['memcache_stampede_protection'] = TRUE;
 $conf['cache_default_class'] = 'MemCacheDrupal';
 // The 'cache_form' bin must be assigned to non-volatile storage.
 $conf['cache_class_cache_form'] = 'DrupalDatabaseCache';
 // Don't bootstrap the database when serving pages from the cache.
 $conf['page_cache_without_database'] = TRUE;
 $conf['page_cache_invoke_hooks'] = FALSE;
END

cd public
drush site-install \
--db-url="mysql://$DB_USER:$DB_PASSWORD@localhost:3306/$DB_NAME" \
--account-name="$DRUPAL_ADMIN" \
--account-pass="$DRUPAL_PASSWORD" \
--account-mail="$EMAIL" \
--site-name="$DOMAIN" \
--site-mail="noreply@$DOMAIN" -y

drush en -y admin_toolbar admin_toolbar_tools admin_toolbar_links_access_filter memcache memcache_admin
