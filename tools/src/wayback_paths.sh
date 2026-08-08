#!/bin/bash
echo "=== all historical URLs with status (passive CDX) ==="
curl -s --max-time 40 "https://web.archive.org/cdx/search/cdx?url=bankkertiawan.com*&output=text&fl=timestamp,original,statuscode&collapse=urlkey&limit=300" > /tmp/cdx.txt
wc -l /tmp/cdx.txt
echo "--- unique paths (sorted) ---"
awk '{print $2}' /tmp/cdx.txt | sed 's/^http[s]*:\/\///' | sed 's/\?.*//' | sort -u | head -80
