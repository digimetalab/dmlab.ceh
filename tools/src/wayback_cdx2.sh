#!/bin/bash
sleep 15
echo "=== CDX retry ==="
curl -s --max-time 60 "https://web.archive.org/cdx/search/cdx?url=bankkertiawan.com*&output=text&fl=timestamp,original,statuscode&collapse=urlkey&limit=300" -o /mnt/d/Projects/ceh/results/recon/bankkertiawan_cdx.txt
wc -l /mnt/d/Projects/ceh/results/recon/bankkertiawan_cdx.txt
awk '{print $2}' /mnt/d/Projects/ceh/results/recon/bankkertiawan_cdx.txt | sed 's/^http[s]*:\/\///' | sed 's/\?.*//' | sort -u
