#!/bin/bash
CDX=/mnt/d/Projects/ceh/results/recon/bankkertiawan_cdx.txt
# clean junk lines
grep -vE '^(Service|server|No|)($| )' "$CDX" | grep -E '^[0-9]{14} ' > /tmp/cdx_clean.txt
mv /tmp/cdx_clean.txt "$CDX"
echo "=== CLEAN LINES ==="
wc -l "$CDX"
echo ""
echo "=== STATUS CODE DIST (col3) ==="
awk '{print $3}' "$CDX" | sort | uniq -c | sort -rn
echo ""
echo "=== NON-200 (interesting) ==="
awk '$3 != 200 {print}' "$CDX" | head -40
echo ""
echo "=== OLD CUSTOM PHP / SESSION PAGES (legacy pre-WP site) ==="
awk '{print $2}' "$CDX" | grep -iE '\.php|session|sejarah|syarat|tinggalkan' | sort -u
echo ""
echo "=== LELANG + INTERESTING POST TYPES ==="
awk '{print $2}' "$CDX" | grep -iE 'lelang|mcl|undangan|ez-|ibank|corebanking' | sort -u
echo ""
echo "=== HISTORIC PLUGINS (old vs current) ==="
awk '{print $2}' "$CDX" | grep -oE 'plugins/[a-z0-9-]+' | sort -u
