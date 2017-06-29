#!/bin/sh

set -x

if [ ! -d /var/www/html ]; then
    cd /var/www/html
    mkdir typo3temp
    mkdir typo3conf
    mkdir fileadmin
    mkdir uploads
    touch FIRST_INSTALL
    chown -Rvf www-data. .

ln -s typo3_src-* typo3_src 
ln -s typo3_src/index.php 
ln -s typo3_src/typo3 
ln -s typo3_src/_.htaccess .htaccess 
