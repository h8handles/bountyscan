#!/bin/bash

gobuster dns -d $1 -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt --wildcard -q >> dnsGo.txt
#wordlist needs to be changed or argument needs to be coded for wordlist 
# find out why wordpress.org needed wildcard but not huffingtonpost.com?????


cat dnsGo.txt | sed -e 's/\<Found\>//g' | tee -a dnsNew.txt

cat dnsNew.txt | sed 's/://g' | tee -a new.txt

cat new.txt | sed "s/^[ \t]*//"

rm dnsGo.txt && rm dnsNew.txt

curl -s https://crt.sh/\?q\=%25$i%25.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' >> new.txt

cat new.txt | sort -u | tee -a crt-sh.go.txt

curl -s https://certspotter.com/api/v0/certs\?domain\=$1 | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sed "s/^[ \t]*//" >> new2.txt  

cat new.txt | tee -a new2.txt



cat crt-sh.go.txt >> new2.txt

rm new.txt 
rm crt-sh.go.txt

mv new2.txt final.txt

cat final.txt | sed "s/^[ \t]*//" | tee -a Final.txt

rm final.txt

cat Final.txt | sed "s/^[ \t]*//" | tee -a Final_dns.txt

rm Final.txt

cat Final_dns.txt | sort -u | tee -a final.txt

#cat crt-sh.go.txt | sort -u | tee -a final.txt

#cat final.txt
