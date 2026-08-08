#!/bin/bash
BASE="https://esurvei.bankkertiawan.com"
echo "=== README.md FULL ==="
curl -sk --max-time 10 "$BASE/README.md"
echo ""
echo "=== login.php POST test (no creds) ==="
curl -sk --max-time 10 -X POST -d "username=test&password=test" -o /dev/null -w "code=%{http_code} size=%{size_download} redirect=%{redirect_url}\n" "$BASE/app/models/login.php"
echo "=== login.php GET verbose ==="
curl -sk --max-time 10 -D - "$BASE/app/models/login.php"
