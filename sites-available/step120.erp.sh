#!/bin/bash
vDomain="erp.puzzlout.ovh"

#Install of ERP on erp.puzzlout.ovh"
echo "Install of ERP on $vDomain"
mkdir -p /var/www/$vDomain/{public_html,logs}
cd /var/www/$vDomain/public_html
git clone https://github.com/puzzlout/portal
cp /vps-manager/assets/html/index.php /var/www/$vDomain/public_html/
sudo cp /vps-manager/assets/sites-available/$vDomain.conf /etc/apache2/sites-available/$vDomain.conf
sudo vim /etc/apache2/sites-available/$vDomain.conf
#Generate the certs Let's Encrypt for erp.puzzlout.ovh`
echo "Generate the certs Let's Encrypt for $vDomain"
cd /opt/letsencrypt
sudo -H ./letsencrypt-auto --apache -d $vDomain
sudo ls /etc/letsencrypt/live #To list the certs of Let's encrypt
sudo -H ./letsencrypt-auto --apache --renew-by-default -d $vDomain
#echo "@monthly root /opt/letsencrypt/letsencrypt-auto --quiet --apache --renew-by-default -d $vDomain >> /var/log/letsencrypt/letsencrypt-auto-update.log" | sudo tee --append /etc/crontab
sudo a2ensite $vDomain.conf
sudo systemctl reload apache2
cd ~
cd ..

#Install of  Dolibarr on erp.puzzlout.ovh
echo "Install of  Dolibarr on $vDomain"
cd /var/www/$vDomain/public_html
composer create-project dolibarr/dolibarr erp
sudo vim /etc/apache2/sites-available/erp.puzzlout.ovh.conf
sudo vim /etc/apache2/sites-available/erp.puzzlout.ovh-le-ssl.conf
sudo systemctl reload apache2
# follow instruction @ https://erp.puzzlout.ovh
cd ~
cd ..
