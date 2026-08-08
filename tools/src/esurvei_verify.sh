#!/bin/bash
BASE="https://esurvei.bankkertiawan.com"
for p in "config.php" "app/models/config.php" "app/models/db.php" "app/models/user.php" "db.sql" "README.md" "composer.json" ".env" "phpinfo.php" "info.php" "app/models/login.php" "nonexistent-file-xyz.php" "nonexistent-dir-xyz/"; do
  sz=$(curl -sk --max-time 10 "$BASE/$p" | wc -c)
  first=$(curl -sk --max-time 10 "$BASE/$p" | head -c 80 | tr '\n' ' ')
  printf '%-28s size=%-7s %s\n' "$p" "$sz" "$first"
done
