#!/bin/bash


envsubst < /opt/app-root/etc/conf.d/50-mpm-tuning.conf.template > /opt/app-root/etc/conf.d/50-mpm-tuning.conf
envsubst < /opt/app-root/etc/conf.d/00-documentroot.conf.template > /opt/app-root/etc/conf.d/00-documentroot.conf

exec httpd -D FOREGROUND
