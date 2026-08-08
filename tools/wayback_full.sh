#!/bin/bash
# Full Wayback CDX harvest for bankkertiawan.com with backoff + pagination
OUT=/mnt/d/Projects/ceh/results/recon/bankkertiawan_cdx.txt
: > "$OUT"
BASE="https://web.archive.org/cdx/search/cdx?url=bankkertiawan.com*&output=text&fl=timestamp,original,statuscode&collapse=urlkey"
PAGE=0
for i in 1 2 3 4 5 6 7 8; do
  sleep $((RANDOM % 12 + 8))
  TMP=/tmp/cdx_page_$i.txt
  curl -s --max-time 90 "${BASE}&from=2005&to=2026&page=${PAGE}" -o "$TMP"
  N=$(wc -l < "$TMP")
  echo "page $i -> $N lines"
  if [ "$N" -eq 0 ]; then
    # rate limited or empty page; try once more after longer sleep
    sleep 45
    curl -s --max-time 90 "${BASE}&from=2005&to=2026&page=${PAGE}" -o "$TMP"
    N=$(wc -l < "$TMP")
    echo "  retry -> $N lines"
  fi
  if [ "$N" -eq 0 ]; then break; fi
  cat "$TMP" >> "$OUT"
  PAGE=$((PAGE + 1))
done
echo "=== TOTAL ==="
wc -l "$OUT"
echo "=== UNIQUE PATHS ==="
awk '{print $2}' "$OUT" | sed 's/^http[s]*:\/\///' | sed 's/\?.*//' | sort -u
