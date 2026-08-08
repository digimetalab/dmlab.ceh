#!/bin/bash
BASE="https://esurvei.bankkertiawan.com"
echo "=== /survey ==="
curl -sk --max-time 12 -o /tmp/esurvey.html -w "code=%{http_code} size=%{size_download}\n" "$BASE/survey"
grep -ioE "<form[^>]*>|href=\"[^\"]+\"" /tmp/esurvey.html | grep -ivE "css|\.js|fonts" | sort -u | head -20
echo "=== login.php direct ==="
curl -sk --max-time 12 -o /dev/null -w "code=%{http_code} size=%{size_download}\n" "$BASE/app/models/login.php"
echo "=== common file paths ==="
for p in "config.php" "app/models/config.php" "app/models/db.php" "app/models/user.php" "db.sql" "README.md" "composer.json" ".env" "phpinfo.php" "info.php"; do
  curl -sk --max-time 8 -o /dev/null -w "%{http_code} /$p\n" "$BASE/$p"
done
echo "=== registration endpoint? ==="
for p in "register" "app/models/register.php" "app/controllers/register.php" "signup"; do
  curl -sk --max-time 8 -o /dev/null -w "%{http_code} /$p\n" "$BASE/$p"
done
