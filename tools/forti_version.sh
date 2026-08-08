#!/bin/bash
BASE="https://apimelody.bankkertiawan.com:17072"
echo "=== login page version markers ==="
curl -sk --max-time 12 "$BASE/login" -o /tmp/am_login2.html
grep -ioE "fortios[^\"'<]*|v7\.[0-9][^\"'<]*|v6\.[0-9][^\"'<]*|build[[:space:]]*[0-9]{4,}|mariner|fos[_-][0-9v]+|FortiGate[^<]*|FortiProxy" /tmp/am_login2.html | sort -u | head
echo "=== check assets dir listing ==="
curl -sk --max-time 8 -o /dev/null -w "%{http_code} /favicon.ico\n" "$BASE/favicon.ico"
curl -sk --max-time 8 -o /dev/null -w "%{http_code} /remote/login\n" "$BASE/remote/login"
curl -sk --max-time 8 -o /dev/null -w "%{http_code} /remote/update\n" "$BASE/remote/update"
echo "=== user agent based ==="
curl -sk --max-time 8 -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" "$BASE/login" -D - -o /dev/null | grep -iE "server|version" | head
