#!/bin/bash
echo "=== survey form inputs (full context around add.php) ==="
python3 - <<'EOF'
import re
html = open('/tmp/esurvey.html', encoding='utf-8', errors='ignore').read()
# find all form blocks
for m in re.finditer(r'<form[^>]*>(.*?)</form>', html, re.S):
    form = m.group(0)
    action = re.search(r'action="([^"]+)"', form)
    print('FORM action=', action.group(1) if action else '?')
    for inp in re.finditer(r'<input[^>]*>', form):
        print('  ', inp.group(0)[:150])
    print()
# also any inline JS referencing add.php
for m in re.finditer(r'[^"]*add\.php[^"\']*', html):
    print('JS REF:', m.group(0)[:120])
EOF
echo "=== survey.html forms complete count ==="
grep -c "<form" /tmp/esurvey.html
grep -c "<input" /tmp/esurvey.html
