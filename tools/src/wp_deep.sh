#!/bin/bash
T="bankkertiawan.com"
echo "=== crt.sh subdomains ==="
curl -s --max-time 25 -A "Mozilla/5.0" "https://crt.sh/?q=%25.$T&output=json" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    subs = set()
    for e in d:
        for n in (e.get('name_value') or '').split('\n'):
            n = n.strip().lstrip('*.')
            if n and n.endswith('.$T'):
                subs.add(n)
    for s in sorted(subs):
        print(s)
    print(f'# total {len(subs)}', file=sys.stderr)
except Exception as ex:
    print('ERR', ex)
"
echo "=== readme.html (version) ==="
curl -s --max-time 15 "https://$T/readme.html" | grep -iE "version|wordpress" | head -5
echo "=== users sitemap ==="
curl -s --max-time 15 "https://$T/wp-sitemap-users-1.xml" | head -c 1500
echo ""
echo "=== user sitemap URLs ==="
curl -s --max-time 15 "https://$T/wp-sitemap-users-1.xml" | grep -oE "<loc>[^<]+</loc>" | head -20
