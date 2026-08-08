#!/bin/bash
echo "=== apimelody :17072 ==="
curl -sk --max-time 12 -o /dev/null -w "code=%{http_code} size=%{size_download} type=%{content_type}\n" "https://apimelody.bankkertiawan.com:17072/"
curl -s --max-time 12 -o /dev/null -w "http code=%{http_code} size=%{size_download}\n" "http://apimelody.bankkertiawan.com:17072/"
echo "=== apimelody :17072 body head ==="
curl -sk --max-time 12 "https://apimelody.bankkertiawan.com:17072/" | head -c 600
echo ""
echo "=== cpanel 2083 title ==="
curl -sk --max-time 10 "https://cpanel.bankkertiawan.com:2083/" | grep -ioE "<title>[^<]*|<meta[^>]*name=\"description\"[^>]*>" | head -3
echo "=== esurvei detail ==="
curl -sk --max-time 12 -o /dev/null -w "code=%{http_code} size=%{size_download} type=%{content_type}\n" "https://esurvei.bankkertiawan.com/"
curl -sk --max-time 12 -D - -o /dev/null "https://esurvei.bankkertiawan.com/" | grep -iE "x-powered|server:|generator|set-cookie" | head -6
