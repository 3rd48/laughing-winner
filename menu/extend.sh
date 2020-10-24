#!/bin/bash

clear
echo -e ""
echo -e " == Thirdy == " | lolcat -a
echo -e ""
read -p " Username: " User
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
read -p " Days you want to extend: " Days
Today=`date +%s`
Days_Detailed=$(( $Days * 86400 ))
Expire_On=$(($Today + $Days_Detailed))
Expiration=$(date -u --date="1970-01-01 $Expire_On sec GMT" +%Y/%m/%d)
Expiration_Display=$(date -u --date="1970-01-01 $Expire_On sec GMT" '+%d %b %Y')
passwd -u $User
usermod -e $Expiration $User
egrep "^$User" /etc/passwd >/dev/null
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
clear
echo -e ""
echo -e " == BonvScript == " | lolcat -a
echo -e ""
echo -e " Username: $User"
echo -e " Extended Account Expiry: $Days Days"
echo -e " Account Expires on: $Expiration_Display"
echo -e ""
else
clear
echo -e ""
echo -e " == BonvScript == " | lolcat -a
echo -e ""
echo -e " Username does not exists"
echo -e ""

fi
