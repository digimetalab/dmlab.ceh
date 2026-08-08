#!/bin/bash
for h in apimelody secure cpanel; do
  echo "=== $h ==="
  for proto in http https; do
    out=$(curl -s --max-time 10 --connect-timeout 5 -o /dev/null -w "HTTP=%{http_code} conn=%{time_connect}s total=%{time_total}s" -L "$proto://$h.bankkertiawan.com/" 2>&1)
    echo "  $proto: $out"
  done
  # port scan basic
  echo "  ports: $(python3 -c "
import socket
for p in [80,443,2082,2083,2086,2087,3306,8080]:
    s=socket.socket(); s.settimeout(1.5)
    r=s.connect_ex(('$h.bankkertiawan.com', p)); s.close()
    if r==0: print(p, end=' ')
print('')
" 2>/dev/null)"
done
