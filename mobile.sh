echo "compiling apk"
find_urls()
{
printf $"$run Finding Urls \n"
~/go/bin/apkurlgrep -a $1 


read -n 1 -r -s -p $'\n\nPress enter to continue. to find apk secrets..\n\n'
find_secrets $1
}

find_secrets()
{
printf $"$run Extracting Secrets  \n"
/home/bandit/Desktop/wipro/ApkRecon/jadex/bin/jadx $1 -d /tmp/$(basename "$1" .apk)
printf $"$run Extracting Secrets  from sources\n"
for conf in ~/.gf/*;do
echo "Running for $(basename "$conf" .json)"
find /tmp/$(basename "$1" .apk)/sources/  -type f -print | grep -vE "R.java|r.java" | xargs -n 1 strings | ~/go/bin/gf $(basename "$conf" .json)
printf $"$run Extracting Secrets  from Resources\n"
find /tmp/$(basename "$1" .apk)/resources/  -type f -print | xargs -n 1 strings | ~/go/bin/gf  $(basename "$conf" .json) |  sed 's/=/ /g;s/>/=/g;s/<string name/ /g'
done

rm -r  /tmp/$(basename "$1" .apk)
}

find_urls $1

