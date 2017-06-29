FROM registry.access.redhat.com/rhscl/php-70-rhel7
# Edit Version - original: TP3_VERS=8.7.1
# To be able to change the Image


RUN cd /var/www/html && \
    wget -O - https://netcologne.dl.sourceforge.net/project/typo3/TYPO3%20Source%20and%20Dummy/TYPO3%208.7.1/typo3_src-8.7.1.tar.gz | tar -xzf - && \
    ln -s typo3_src-* typo3_src && \
    ln -s typo3_src/index.php && \
    ln -s typo3_src/typo3 && \
    ln -s typo3_src/_.htaccess .htaccess && \
    mkdir typo3temp && \
    mkdir typo3conf && \
    mkdir fileadmin && \
    mkdir uploads && \
    touch FIRST_INSTALL && \
    chown -Rvf www-data. .
    


# Configure volumes
VOLUME /var/www/html/fileadmin
VOLUME /var/www/html/typo3conf
VOLUME /var/www/html/typo3temp
VOLUME /var/www/html/uploads
    

EXPOSE 8080

COPY containerfiles/ /

RUN chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
