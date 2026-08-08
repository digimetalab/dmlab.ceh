#!/bin/bash
T="bankkertiawan.com"
for plug in elementor fluent-smtp content-views-query-and-display-post-page litespeed-cache header-footer-elementor wp-accessibility easy-accessibility; do
  echo "=== $plug ==="
  curl -sk --max-time 8 "https://$T/wp-content/plugins/$plug/readme.txt" | grep -iE "stable tag|tested up to" | head -2
done
echo "=== astra theme version ==="
curl -sk --max-time 8 "https://$T/wp-content/themes/astra/readme.txt" | grep -iE "stable tag|tested up to" | head -2
echo "=== elementor readme head ==="
curl -sk --max-time 8 "https://$T/wp-content/plugins/elementor/readme.txt" | head -c 400
