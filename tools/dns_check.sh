#!/bin/bash
T="bankkertiawan.com"
for sub in corebanking ibank apimelody sandbox scoring secure mcl ez undangan webmail mail cpanel; do
  h="$sub.$T"
  dns=$(python3 -c "
import socket
try:
    print(socket.gethostbyname('$h'))
except Exception as e:
    print('NXDOMAIN')
" 2>/dev/null)
  printf '%-45s %s\n' "$h" "$dns"
done
echo "--- base ---"
python3 -c "import socket; print(socket.gethostbyname('$T'))"
