#!/bin/bash

set -e

scan_type='[incert scan type here  airstrike or nuke ]'
email='[your email here]'
DATE=`date +%y%m%d%H%M%S`
IP=`cat ./loot/targets.txt`


docker-compose run sniper sniper -f /usr/share/sniper/loot/targets.txt -m $scan_type -w nuke_scan_$DATE;

sleep 30

for i in $IP; do 
mv ./loot/$i ./loot/workspace/nuke_scan_$DATE/$i && \
echo "<p> <a href=$i/sniper-report.html target=_new>$i</a> </p>" >> ./loot/workspace/nuke_scan_$DATE/index.html && \
sed -i -e "s/\/usr\/share\/sniper\/loot\/$i\//\.\//g" ./loot/workspace/nuke_scan_$DATE/$i/sniper-report.html
done;

mv ./loot/workspace/nuke_scan_$DATE ./result/nuke_scan_$DATE;
cd ./result
tar -czf nuke_scan_$DATE.tar.gz nuke_scan_$DATE;
rm -rf ./nuke_scan_$DATE 
echo "Weekly Security audit report! See attachment" | mutt -a "./nuke_scan_$DATE.tar.gz" -s "Weekly Security Report!" -- $email

docker rm $(docker ps -a | grep sniper | grep Exited |awk {'print$1'})
