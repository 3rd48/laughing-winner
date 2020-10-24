#!/bin/bash
source /usr/local/sbin/base-script

clear
echo -e ""
echo -e "$TITLE"
echo -e " Create Account"
echo -e ""
read -p $'\e[32m  Username: \e[0m' User

# Check If Username Exist, Else Proceed
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
clear
echo -e ""
echo -e "$TITLE"
echo -e "\e[31m Username Already Exists on your server, please try another username\e[0m."
exit 0
else
read -p $'\e[32m  Password: \e[0m' Pass
read -p $'\e[32m  Active Days: \e[0m' Days
echo -e ""
echo -e ""
clear
sleep 1
IPADDR=$(wget -4qO- http://ipinfo.io/ip)
Today=`date +%s`
Days_Detailed=$(( $Days * 86400 ))
Expire_On=$(($Today + $Days_Detailed))
Expiration=$(date -u --date="1970-01-01 $Expire_On sec GMT" +%Y/%m/%d)
Expiration_Display=$(date -u --date="1970-01-01 $Expire_On sec GMT" '+%d %b %Y')
opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2 | xargs | sed -e 's/ /, /g' )"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2 | xargs | sed -e 's/ /, /g')"
stunnel4port="$(netstat -nlpt | grep -i stunnel | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2 | xargs | sed -e 's/ /, /g')"
openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2 | xargs | sed -e 's/ /, /g')"
squidport="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}' | xargs | sed -e 's/ /, /g')"
useradd -m -s /bin/false -e $Expiration $User > /dev/null
egrep "^$User" /etc/passwd &> /dev/null
echo -e "$Pass\n$Pass\n" | passwd $User &> /dev/null
clear
echo -e ""
echo -e "$TITLE"
echo -e " Your Account:"
echo -e "\e[32m  Username: \e[0m"$User
echo -e "\e[32m  Password: \e[0m"$Pass
echo -e "\e[32m  Account Expiry: \e[0m"$Expiration_Display
echo -e ""
echo -e "\e[32m  Host/IP: \e[0m"$IPADDR
echo -e "\e[32m  OpenSSH Port: \e[0m"$opensshport
echo -e "\e[32m  Dropbear Port: \e[0m"$dropbearport
echo -e "\e[32m  SSL Port: \e[0m"$stunnel4port
echo -e "\e[32m  Proxy Ports: \e[0m"$squidport
echo -e "\e[32m  OpenVPN Port: \e[0m"$openvpnport
echo -e ""
echo -e ""
fi
