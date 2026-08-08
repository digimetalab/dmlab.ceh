#!/bin/bash
T="bankkertiawan.com"
echo "=== WP generator meta ==="
curl -sk --max-time 12 "https://$T/" | grep -ioE "content=\"WordPress[^\"]*\""
echo "=== REST plugin endpoint (often blocked) ==="
curl -sk --max-time 12 -o /dev/null -w "code=%{http_code}\n" "https://$T/wp-json/"
echo "=== wp-json root (namespaces) ==="
curl -sk --max-time 12 "https://$T/wp-json/" -o /tmp/wpjson.json
python3 -c "
import json
try:
    d=json.load(open('/tmp/wpjson.json'))
    ns=d.get('namespaces',[])
    print('namespaces:', ns)
    routes=[r for r in d.get('routes',{}) if any(x in r for x in ['wp/v2','wp/sites','eapi','elementor'])]
    for r in sorted(routes)[:60]: print(' ', r)
except Exception as e: print('ERR', e)
"
echo "=== themes leak ==="
curl -sk --max-time 12 "https://$T/wp-json/wp/v2/themes" -o /dev/null -w "code=%{http_code}\n"
echo "=== check elementor / wp-content plugins guess ==="
for plug in elementor wordfence wp-file-manager all-in-one-wp-security really-simple-ssl; do
  curl -sk --max-time 8 -o /dev/null -w "%{http_code} /wp-content/plugins/$plug/readme.txt\n" "https://$T/wp-content/plugins/$plug/readme.txt"
done
