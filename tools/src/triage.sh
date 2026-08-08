#!/bin/bash
# Fast triage bankkertiawan.com - Fase 2
T="bankkertiawan.com"
OUT=/mnt/d/Projects/ceh/results/recon/bankkertiawan_triage.txt
echo "=== crt.sh subdomains ===" | tee "$OUT"
curl -s --max-time 25 "https://crt.sh/?q=%25.$T&output=json" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    subs = set()
    for e in d:
        for n in (e.get('name_value') or '').split('\n'):
            n = n.strip().lstrip('*.')
            if n and '.' in n:
                subs.add(n)
    for s in sorted(subs):
        print(s)
    print(f'# total {len(subs)}', file=sys.stderr)
except Exception as ex:
    print('ERR', ex)
" | tee -a "$OUT"
echo "" | tee -a "$OUT"
echo "=== robots.txt ===" | tee -a "$OUT"
curl -s --max-time 15 "https://$T/robots.txt" | tee -a "$OUT"
echo "" | tee -a "$OUT"
echo "=== HTTP headers root ===" | tee -a "$OUT"
curl -sI --max-time 15 "https://$T/" | tee -a "$OUT"
echo "" | tee -a "$OUT"
echo "=== security headers root (GET) ===" | tee -a "$OUT"
curl -s --max-time 15 -D - -o /dev/null "https://$T/" | tee -a "$OUT"
