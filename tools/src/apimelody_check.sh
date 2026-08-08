#!/bin/bash
echo "=== apimelody redirect ==="
curl -s --max-time 10 -o /dev/null -w "code=%{http_code} loc=%{redirect_url}\n" "http://apimelody.bankkertiawan.com/"
curl -s --max-time 10 -o /dev/null -w "follow code=%{http_code} final=%{url_effective} size=%{size_download}\n" -L "http://apimelody.bankkertiawan.com/"
echo "=== apimelody content ==="
curl -s --max-time 10 -L "http://apimelody.bankkertiawan.com/" | head -c 1000
echo ""
echo "=== cpanel 2083 ==="
curl -sk --max-time 10 -o /dev/null -w "code=%{http_code} size=%{size_download}\n" "https://cpanel.bankkertiawan.com:2083/"
curl -sk --max-time 10 -o /dev/null -w "code=%{http_code} size=%{size_download}\n" "https://cpanel.bankkertiawan.com:2087/"
echo "=== cpanel 80 content ==="
curl -s --max-time 10 "http://cpanel.bankkertiawan.com/" | head -c 500
echo ""
