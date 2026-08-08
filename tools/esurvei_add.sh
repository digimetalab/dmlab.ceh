#!/bin/bash
BASE="https://esurvei.bankkertiawan.com"
echo "=== add.php GET ==="
curl -sk --max-time 10 -w "\ncode=%{http_code}\n" "$BASE/app/models/add.php?act=respon"
echo "=== add.php POST empty ==="
curl -sk --max-time 10 -X POST -w "\ncode=%{http_code}\n" "$BASE/app/models/add.php?act=respon"
echo "=== add.php other act values ==="
for a in respon login logout user list; do
  curl -sk --max-time 8 -o /dev/null -w "%{http_code} act=$a size=%{size_download}\n" "$BASE/app/models/add.php?act=$a"
done
echo "=== forms.js content (endpoint logic) ==="
curl -sk --max-time 10 "$BASE/resources/assets/js/forms.js" | head -c 2500
