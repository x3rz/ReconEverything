mkdir ~/recon/External-IPs/
RED='\033[0;31m'
NC='\033[0m' 

echo -e "${RED}Make sure you have searched for CIDR on bgp.he. ${NC}"
echo "\n"
echo "Drop the list with filename 'cidrs.txt' in the current directory to get the resolved IPs."
# echo "$1" | metabigor net --org -o /recon/$1/metabigor-cidrs.txt
~/tools/hardcidr/hardCIDR.sh
echo /tmp/nxp/cirdrange.txt | ~/go/bin/mapcidr -silent | ~/tools/dnsx/dnsx -ptr -resp-only -r ~/tools/resources/resolvers.txt -o output.txt
echo ./cidr.txt | ~/go/bin/mapcidr -silent | ~/tools/dnsx/dnsx -ptr -resp-only -r ~/tools/resources/resolvers.txt -o output.txt
# sudo docker run --rm -it -v $(pwd)/input:/input naabu -sn -ps -pa -pe -pp -pm -arp -nd -l /input/cidrs.txt -csv -o /input/sn.csv
# sudo docker run --rm -it -v $(pwd)/input:/input naabu -Pn -tp 1000 -l /input/cidrs.txt -csv -o /input/pn.csv
