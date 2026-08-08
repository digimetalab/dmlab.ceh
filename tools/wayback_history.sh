#!/bin/bash
T="bankkertiawan.com"
echo "=== wayback CDX all historical URLs (passive) ==="
curl -s --max-time 30 "https://web.archive.org/cdx/search/cdx?url=$T*&output=text&fl=timestamp,original,statuscode,mimetype&collapse=urlkey&limit=200" | head -60
