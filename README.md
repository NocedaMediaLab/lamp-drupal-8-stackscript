# HTTP/2 LAMP stack with Apache, MariaDB, PHP 7.3 (php-fpm), Acme (SSL), Git, Composer, Drush, and Drupal 8

A Linode StackScript compatible with Debian 10+ and Ubuntu 19.10+

### Requirements
- Debian 10+ and Ubuntu 19.10+
- Linode with at least 2GB ram.
- User has SSH public and private keys on local computer

## Deployment details


### Security
- UFW and Fail2Ban
- Root access and password authentication are disabled.
- User with SSH key authentication. Password authentication for sudo is disabled.

### LAMP Stack
- Apache with HTTP/2 and mod_event
- MariaDB instead of MySql. New user with admin rights.
- PHP 7.3 with php-fpm, memcached, opcache and all Drupal core-required PHP modules.

### Additional packages and scripts
- Git
- Composer (globally installed)
- SSL using the Acme Certificate Protocol script.
- Aliases for Drush, and project and document root directories.
- Virtualhost creation and deletion script for additional domains.

### Drupal
- Project root for composer files, vendors, etc.
- Web root under the project root.
- Drupal 8 is installed the recommended way (using Composer)
- Drush and Drupal modules memcache and admin_toolbar are pre-installed and enabled.

***Please wait at least 10 minutes for all the scripts and commands to run before logging in.***

## Post-installation
- Install an SSL certificate, run 'acme.sh --help' for details.
- Disable default site 'sudo a2dissite 000-default.conf'
- For creation of more virtualhosts, a global script has been installed. See https://github.com/NocedaMediaLab/virtualhost for more details.
- Read the Drupal user guide: https://www.drupal.org/docs/user_guide/en/index.html
- Get Drupal support: https://www.drupal.org/support"
- Get involved with the Drupal community: https://www.drupal.org/getting-involved
- Remove the welcome message by editing the .bash_profile file.
