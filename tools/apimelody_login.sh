#!/bin/bash
echo "=== apimelody /login ==="
curl -sk --max-time 12 -D /tmp/am_headers.txt "https://apimelody.bankkertiawan.com:17072/login" -o /tmp/am_login.html
head -20 /tmp/am_headers.txt
echo "--- body ---"
head -c 2500 /tmp/am_login.html
echo ""
