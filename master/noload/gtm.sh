clear
echo -e "\e[1;32m-----------------------------------------------------"
echo -e "\e[1;32m       GTM Installer by ThirdyMocky           "
echo -e "\e[1;32m-----------------------------------------------------"
echo -----------------------------------------------------
echo Updating System Files
echo -----------------------------------------------------
sleep 2
apt update
apt install sudo -y
apt -y upgrade 
apt install nano fail2ban unzip python build-essential curl -y
apt install screen -y
clear
sleep 2
clear
echo -----------------------------------------------------
echo Configuring SSHD Server
echo -----------------------------------------------------
sleep 2
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
echo "SSHD Port Running on port: 22"
clear
echo -----------------------------------------------------
echo Configuring Sysctl
echo -----------------------------------------------------
sleep 2
sysctl -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
clear
echo -----------------------------------------------------
echo Configuring Date and Time
echo -----------------------------------------------------
sleep 2
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Manila /etc/localtime
clear
echo -----------------------------------------------------
echo SELinux Disabled!
echo -----------------------------------------------------
sleep 2
SELINUX=disabled 
clear
echo -----------------------------------------------------
echo Checking Configuration
echo -----------------------------------------------------
sleep 2
update-rc.d fail2ban defaults
clear
echo -----------------------------------------------------
echo Configuring IPTables
echo -----------------------------------------------------
sleep 2
sysctl -p
iptables -t nat -F; iptables -t mangle -F; iptables -F; iptables -X
iptables -A OUTPUT -p tcp --dport 25 -j REJECT
iptables -A OUTPUT -p tcp --dport 22 -j DROP
clear
sleep 2
clear
cd /root/
wget https://raw.githubusercontent.com/3rd48/thirdy/main/master/noload/check.sh
chmod +x check.sh
sleep 1
clear
wget https://raw.githubusercontent.com/3rd48/thirdy/main/master/noload/proxy.py
chmod +x proxy.py
sleep 2
clear
echo -----------------------------------------------------
echo Insert Cron Job Setting
echo -----------------------------------------------------
sleep 2
export EDITOR=nano
crontab -l > mycron
echo "@reboot /usr/bin/python /root/proxy.py
* * * * * /root/check.sh" >> mycron
crontab mycron
sleep 1
/etc/init.d/cron restart
sleep 2
clear
echo -----------------------------------------------------
echo "Copyright PH-Tambayan 2020"
echo ------------------------------------------------------
echo "Installation is finish! Please reboot your VPS!"
echo ------------------------------------------------------
clear
rm -f wget-log*
rm -f gtm.sh*
cd && wget "https://raw.githubusercontent.com/3rd48/thirdy/main/create.sh" -O thirdy-create-user.sh && sed -i 's/_Dreyannz_/Thirdy/g' /root/thirdy-create-user.sh && echo "alias create='bash thirdy-create-user.sh'" >> .bashrc && source .bashrc
reboot 1*
