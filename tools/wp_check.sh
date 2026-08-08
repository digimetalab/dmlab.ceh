#!/bin/bash
T="bankkertiawan.com"
echo "=== raw crt.sh ==="
curl -s --max-time 25 -A "Mozilla/5.0" "https://crt.sh/?q=%.$T&output=json" | head -c 500
echo ""
echo "=== WP REST users ==="
curl -s --max-time 15 "https://$T/wp-json/wp/v2/users" | head -c 800
echo ""
echo "=== wp-sitemap head ==="
curl -s --max-time 15 "https://$T/wp-sitemap.xml" | head -c 800
echo ""
echo "=== wp-login status ==="
curl -s --max-time 15 -o /dev/null -w "HTTP %{http_code} size=%{size_download}\n" "https://$T/wp-login.php"
echo "=== readme.html ==="
curl -s --max-time 15 -o /dev/null -w "HTTP %{http_code} size=%{size_download}\n" "https://$T/readme.html"
echo "=== xmlrpc.php ==="
curl -s --max-time 15 -o /dev/null -w "HTTP %{http_code} size=%{size_download}\n" "https://$T/xmlrpc.php"
echo "=== index.php?author=1 ==="
curl -s --max-time 15 -o /dev/null -w "HTTP %{http_code} size=%{size_download} redirect=%{redirect_url}\n" "https://$T/?author=1"
