#!/bin/bash
T="bankkertiawan.com"
for sub in corebanking ibank apimelody sandbox scoring secure mcl ez esurvei undangan webmail mail cpanel; do
  h="$sub.$T"
  code=$(curl -s --max-time 8 -o /dev/null -w "%{http_code}" -L "https://$h/" 2>/dev/null)
  ip=$(curl -s --max-time 8 -o /dev/null -w "%{remote_ip}" "https://$h/" 2>/dev/null)
  title=$(curl -s --max-time 8 -L "https://$h/" 2>/dev/null | grep -ioE "<title>[^<]*" | head -1 | sed 's/<title>//i' | head -c 60)
  printf '%-45s HTTP=%-4s IP=%-15s %s\n' "$h" "$code" "$ip" "$title"
done
