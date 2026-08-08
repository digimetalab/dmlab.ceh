#!/bin/bash
BASE="https://esurvei.bankkertiawan.com"
echo "=== survey page - forms/inputs/endpoints ==="
grep -ioE "<form[^>]*>" /tmp/esurvey.html | sort -u
echo "--- inputs ---"
grep -ioE "<input[^>]*>" /tmp/esurvey.html | sort -u | head -30
echo "--- select/textarea ---"
grep -ioE "<select[^>]*>|<textarea[^>]*>" /tmp/esurvey.html | sort -u | head
echo "--- ajax/action hints ---"
grep -ioE "(action|url|href)=\"[^\"]+\"" /tmp/esurvey.html | grep -iE "php|api|ajax|submit|survey" | sort -u | head -20
echo "--- script srcs ---"
grep -ioE "src=\"[^\"]+\"" /tmp/esurvey.html | grep -iE "\.js" | sort -u | head -20
