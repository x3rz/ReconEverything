# bash github.sh org
~/tools/trufflehog github --org=$1 --only-verified
~/tools/git-hound --dig-files --dig-commits --config-file
 git-hound.yml  --subdomain-file ~/recon/active-recon/final-Resolved.txt
 
