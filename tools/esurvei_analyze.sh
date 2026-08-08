#!/bin/bash
echo "=== esurvei full page analysis ==="
curl -sk --max-time 12 "https://esurvei.bankkertiawan.com/" -o /tmp/esurvei.html
wc -c /tmp/esurvei.html
echo "--- forms ---"
grep -ioE "<form[^>]*>" /tmp/esurvei.html | head
echo "--- links ---"
grep -ioE "href=\"[^\"]+\"" /tmp/esurvei.html | grep -ivE "css|\.js|icon|fonts" | sort -u | head -30
echo "--- inputs ---"
grep -ioE "<input[^>]*>" /tmp/esurvei.html | head -15
echo "--- scripts ---"
grep -ioE "src=\"[^\"]+\"" /tmp/esurvei.html | head -15
echo "--- comments/tech hints ---"
grep -ioE "powered by[^<]{0,40}|version[^<]{0,20}|framework[^<]{0,30}" /tmp/esurvei.html | head
