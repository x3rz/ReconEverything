#! /bin/bash

# $1 - domain.com 
# $2 - Github Token file
if [ $# -eq 0 ]
  then
    echo "Usage: script.sh domain.com github_tokens.txt"
    exit 1
fi
mkdir ~/recon/$1
mkdir ~/recon/$1/raw-files	
rm -rf ~/recon/$1/raw-files/*.txt
echo "$1""   "$(whois $1 | grep "Registrant Email" | egrep -ho "[[:graph:]]+@[[:graph:]]+") >> ~/recon/$1/Registrant.txt
# curl -s -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36" "https://viewdns.info/reversewhois/?q=IP.Domains@nxp.com" | html2text | grep -Po "[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)" | tail -n +4  | head -n -1
# theHarvester -d $1 -b all -l 500 -f theharvester.html > ~/recon/$1/theharvester.txt
# mkdir ~/recon/$1/profiling
# cat ~/recon/$1/theharvester.txt | awk '/Users/,/IPs/' | sed -e '1,2d' | head -n -2 | anew -q ~/recon/$1/profiling/recousers.txt
# cat ~/recon/$1/theharvester.txt | awk '/Users/,/IPs/' | sed -e '1,2d' | head -n -2 | anew -q ~/recon/$1/profiling/users.txt
# cat ~/recon/$1/theharvester.txt | awk '/IPs/,/Emails/' | sed -e '1,2d' | head -n -2 | anew -q ~/recon/$1/profiling/ips.txt
# cat ~/recon/$1/theharvester.txt | awk '/Emails/,/Hosts/' | sed -e '1,2d' | head -n -2 | anew -q ~/recon/$1/profiling/emails.txt
# cat ~/recon/$1/theharvester.txt | awk '/Hosts/,/Trello/' | sed -e '1,2d' | head -n -2 | anew -q ~/recon/$1/profiling/hosts.txt
amass enum --passive -d $1 -config ./config/amass.ini -o ~/recon/$1/raw-files/amass.txt
echo "Do you want to run Amass ACTIVE command? (y/n)"
read choice

if [ "$choice" == "y" ]; then
    echo "Running the command..."
    amass enum --active -d $1 -config ./config/amass.ini -o ~/recon/$1/raw-files/active-amass.txt
fi
amass intel --org "$3"  -config ./config/amass.ini -o ~/recon/$1/raw-files/asn.network
amass intel -whois -df domains.txt -config ./config/amass.ini -o ~/recon/$1/raw-files/amass.root_domains

subfinder -d $1 -all -config ./config/subfinder.yaml -o ~/recon/$1/raw-files/subfinder.txt 
~/go/bin/gau --timeout 5 --subs $1 | ~/go/bin/unfurl -u domains | tee ~/recon/$1/raw-files/gau.txt
~/go/bin/waybackurls $1 | ~/go/bin/unfurl -u domains | tee ~/recon/$1/raw-files/waybackurl.txt | sort -u ~/recon/$1/raw-files/waybackurl.txt
~/go/bin/github-subdomains -d $1 -t $2 -o ~/recon/$1/raw-files/github.txt
~/go/bin/assetfinder -subs-only $1 |  tee ~/recon/$1/raw-files/assetfinder.txt
curl "https://tls.bufferover.run/dns?q=.$1" -H 'x-api-key: MNzjhSSofn1DXUokUAO0n8PJuhpRWSh8asgNgrsW' | jq -r .Results[] | cut -d ',' -f5 | grep -F ".$1" | tee ~/recon/$1/raw-files/buffer.txt
#curl -s "https://crt.sh//?q=$1&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | ~/go/bin/httprobe | tee  ~/recon/$1/raw-files/crtsh.txt

# sort and combine all the txt final.txt
cat ~/recon/$1/raw-files/*.txt | sed -E 's/^\s*.*:\/\///g'| sort -u | tee ~/recon/$1/passive-recon/final.txt
# Pass txt in puredns
mkdir ~/recon/$1
mkdir ~/recon/$1/passive-recon
~/go/bin/puredns resolve ~/recon/$1/passive-recon/final.txt -r ~/tools/resources/resolvers.txt -w ~/recon/$1/passive-recon/final-passive-resolved.txt

