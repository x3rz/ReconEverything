# Subdomain Bruteforce
RED='\033[0;31m'
NC='\033[0m' 
if [ $# -eq 0 ]
  then
    echo "Usage: script.sh domain.com"
    exit 1
fi
mkdir ~/recon/$1/active-recon
~/go/bin/puredns bruteforce ~/tools/SecLists/Discovery/DNS/dns-Jhaddix.txt $1 -r ~/tools/resources/resolvers.txt -w ~/recon/$1/active-recon/bruteforce.txt --bin ~/tools/massdns/bin/massdns
# Uptill now we have two lists final-passive-resolved.txt and bruteforce.txt
# Mergeing then and fetched the 302 redirected sites
cat ~/recon/$1/passive-recon/final-passive-resolved.txt bruteforce.txt | sort -u | tee subdomain.txt


~/go/bin/puredns resolve subdomain.txt -r ~/tools/resources/resolvers.txt -w ~/recon/$1/active-recon/Resolved.txt

# Permutation and altration of the subdomains

~/go/bin/gotator -sub ~/recon/$1/active-recon/Resolved.txt -perm ~/tools/resources/permutation.txt -depth 1 -numbers 10 -mindup -adv -md > ~/recon/$1/active-recon/gotator1.txt
sleep 10
~/go/bin/puredns resolve ~/recon/$1/active-recon/gotator1.txt -r ~/tools/resources/resolvers.txt -w ~/recon/$1/active-recon/final-Resolved.txt 

