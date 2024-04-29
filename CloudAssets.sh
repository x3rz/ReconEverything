# Gen of Priority wordlist from ~/recon/passive-recon/final.txt ~/recon/active-recon/bruteforce.txt ~/recon/active-recon/final-Resolved.txt
# For Bucket Finding and bruteforce
# $1 - target.com
# $2 - target
# $3 - product made by company
RED='\033[0;31m'
NC='\033[0m' 
if [ $# -eq 0 ]
  then
    echo "Usage: script.sh domain.com domain <product made by company>"
    exit 1
fi
echo "${RED}Make sure you have setup the awscli${NC}"
mkdir ~/recon/$1/cloud-assets
cat ~/recon/$1/passive-recon/final.txt ~/recon/$1/active-recon/bruteforce.txt ~/recon/$1/active-recon/final-Resolved.txt | sed 's/\./\n/g' | sort -u | tee ~/recon/$1/cloud-assets/words.txt
cat ~/recon/$1/cloud-assets/words.txt | sed -E 's/$/\.s3.amazon.com/' | tee ~/recon/$1/cloud-assets/buckets.txt
~/tools/slurp/slurp-1.1.0-linux-amd64 domain -p ~/tools/slurp/permutations.json -t $1 -c 25 | tee ~/recon/$1/cloud-assets/slurp-data.txt

s3scanner scan --buckets-file ~/recon/$1/cloud-assets/buckets.txt | tee ~/recon/$1/cloud-assets/s3scanner.txt

~/tools/cloud_enum/cloud_enum.py -k $1 -k $2 -k $3 -l ~/recon/$1/cloud-assets/cloud-enum.txt
mkdir /tmp/logs/$1
python3 s3cario.py -dL ~/recon/$1/active-recon/live -s -u -r --all | tee /tmp/logs/$1/s3cario
# run lazys3

# AWSBucketDump.py - scans the access and download the files
# python3 AWSBucketDump.py -l ../buckets.txt -g interesting_Keywords.txt -D -m 500000 -d 1


# Cloudbrute - same as cloud enum but more defined
## All providers search
# ~/tools/cb/cloudbrute -d $1 -k $2 -m storage -t 80 -T 10 -w "~/tools/cb/data/storage_small.txt"
# ~/tools/cb/cloudbrute -d $1 -k $2 -m storage -t 80 -T 10 -w "~/tools/cb/data/storage_large.txt"
# ~/tools/cb/cloudbrute  -d $1 -k $2 -m storage -t 80 -T 10 -w "~/recon/cloud-assets/words.txt" -D -C ~/tools/cb/config
## Specific provider search
# CloudBrute -d target.com -k keyword -m storage -t 80 -T 10 -w -c amazon -o target_output.txt


