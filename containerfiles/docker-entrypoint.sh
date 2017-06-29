#!/bin/sh

set -x

if [ ! -d /var/www/html ]; then
    cd /var/www/html
    touch FIRST_INSTALL
    chown -Rvf www-data. .

ln -s typo3_src-* typo3_src 
ln -s typo3_src/index.php 
ln -s typo3_src/typo3 
ln -s typo3_src/_.htaccess .htaccess 
