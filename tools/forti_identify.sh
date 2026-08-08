#!/bin/bash
BASE="https://apimelody.bankkertiawan.com:17072"
echo "=== login.js version hints ==="
curl -sk --max-time 12 "$BASE/388d12d465aaa092e7b20170f189005f/js/login.js" -o /tmp/am_login.js
wc -c /tmp/am_login.js
grep -ioE "version[^,;\"]*|fortios[^,;\"]*|7\.[0-9]\.[0-9]|6\.[0-9]\.[0-9]|build[0-9]*|main-mariner" /tmp/am_login.js | head -20
echo "=== favicon / system info endpoints ==="
for ep in "login?redir=" "system/status" "api/v2/monitor/system/status" "api/v2/cmdb/system/global"; do
  curl -sk --max-time 8 -o /dev/null -w "%{http_code} $ep\n" "$BASE/$ep"
done
echo "=== check known fortios marker in css ==="
curl -sk --max-time 10 "$BASE/388d12d465aaa092e7b20170f189005f/css/main-mariner.css" | head -c 300
echo ""
