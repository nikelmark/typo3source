FROM registry.access.redhat.com/rhscl/php-70-rhel7
# Edit Version - original: TP3_VERS=8.7.1
# To be able to change the Image

USER 0

ENV CONTENT_DIR=/var/www/html \
    APACHE_APP_ROOT=/opt/app-root/src \
    TP3_VERS=8.7.1 \ 
    TP3_FULL_FILE=typo3_src-\${TP3_VERS} \
    TYPO3_DL=https://get.typo3.org/8.7

# mod_authn_dbd mod_authn_dbm mod_authn_dbd mod_authn_dbm mod_echo mod_lua

WORKDIR /tmp

RUN set -x && \
    rm -fr /var/cache/* && \
    yum -y autoremove rh-php70-php-pgsql rh-php70-php-ldap postgresql postgresql-devel postgresql-libs autoconf automake glibc-devel glibc-headers libcom_err-devel libcurl-devel libstdc++-devel make openssl-devel pcre-devel gcc gcc-c++ gdb gdb-gdbserver git libgcrypt-devel libgpg-error-devel libxml2-devel libxslt-devel openssh openssh-clients sqlite-devel zlib-devel && \
    mkdir -p ${CONTENT_DIR} && \
    cd ${CONTENT_DIR} && \
    wget https://get.typo3.org/${TP3_VERS} && \
    tar -xf ${TP3_VERS} && \
    mkdir -p typo3temp && \
    mkdir -p typo3conf && \
    mkdir -p fileadmin && \
    mkdir -p uploads && \
    ln -s typo3_src-* typo3_src && \
    ln -s typo3_src/index.php && \
    ln -s typo3_src/typo3 && \
    ln -s typo3_src/_.htaccess .htaccess && \
    touch FIRST_INSTALL && \
    sed -i -f /opt/app-root/etc/httpdconf.sed /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    sed -i '/php_value session.save_path/d' /opt/rh/httpd24/root/etc/httpd/conf.d/rh-php70-php.conf && \
    head -n151 /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf | tail -n1 | grep "AllowOverride All" || exit && \
    echo "IncludeOptional /opt/app-root/etc/conf.d/*.conf" >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    mkdir /tmp/sessions && \
    chown -R 1001:0 /opt/app-root /tmp/sessions && \
    chmod -R a+rwx /tmp/sessions && \
    chmod -R ug+rwx /opt/app-root && \
    chmod -R a+rwx /etc/opt/rh/rh-php70 && \
    chmod -R a+rwx /opt/rh/httpd24/root/var/run/httpd && \
    ln -s ${CONTENT_DIR}/$(basename $( echo ${TP3_FULL_FILE}|envsubst ) '') ${APACHE_APP_ROOT}/typo3_src && \
    cd ${APACHE_APP_ROOT} && \
    touch ${APACHE_APP_ROOT}/FIRST_INSTALL && \
    chmod 777 ${APACHE_APP_ROOT}/FIRST_INSTALL && \
    ln -s typo3_src/typo3 typo3 && \
    ln -s typo3_src/index.php index.php
    

EXPOSE 8080

VOLUME /var/www/html/fileadmin
VOLUME /var/www/html/typo3conf
VOLUME /var/www/html/typo3temp
VOLUME /var/www/html/uploads

COPY containerfiles/ /

RUN chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
