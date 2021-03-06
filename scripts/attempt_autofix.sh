#!/bin/bash


##Attempt to fix backends issue
echo -e '\e[93m Attempting to restart all backend Application servers \e[0m'

systemctl restart ndeploy_backends || service ndeploy_backends restart

echo -e '\e[93m The following PHP-FPM master process has started \e[0m'

for pid in $(pidof php-fpm)
do
    lsof -p $pid | grep txt
done

##Attempt to re-generate all nginx config

echo -e '\e[93m Attempting to regenerate all nginx conf  \e[0m'
for CPANELUSER in $(cat /etc/domainusers|cut -d: -f1);do echo "ConfGen:: $CPANELUSER" && /opt/nDeploy/scripts/generate_config.py $CPANELUSER;done


#Attempt to re-generate all apache+php-fpm config
echo -e '\e[93m Attempting to setup php-fpm for apache httpd \e[0m'
for CPANELUSER in $(cat /etc/domainusers|cut -d: -f1);do echo "ConfGen:: $CPANELUSER" && /opt/nDeploy/scripts/apache_php_config_generator.py $CPANELUSER;done

##Restart ndeploy_watcher
echo -e '\e[93m Attempting to restart ndeploy_watcher daemon \e[0m'

systemctl restart ndeploy_watcher || service ndeploy_watcher restart
