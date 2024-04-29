#! /bin/bash

# $1 - Domain.com
# $2 - JWT Token 
# $3 - emails.txt
if [ $# -eq 0 ]
  then
    echo "Usage: script.sh domain.com JWT_token emails_file.txt"
    exit 1
fi
mkdir ~/recon/$1
mkdir ~/recon/$1/valid-emails	


python3 ~/tools/TeamsEnum/TeamsEnum.py -a token -t "$2" -o ~/recon/$1/valid-emails/validated_emails.json -f $3


echo -e "\e[1;34mDont forget to \e[1;31mSort and Unique.\e[0m"

# https://github.com/immunIT/TeamsUserEnum
