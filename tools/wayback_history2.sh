#!/bin/bash
CDX=/mnt/d/Projects/ceh/results/recon/bankkertiawan_cdx.txt
echo "=== WP VERSION HISTORY (from wp-emoji-release ver param) ==="
grep -oE 'wp-emoji-release.min.js\?ver=[0-9.]+' "$CDX" | sort -u
echo ""
echo "=== CONTACT-FORM-7 VERSION ==="
grep -oE 'contact-form-7[^?]*\?ver=[0-9.]+' "$CDX" | sort -u
echo ""
echo "=== JETPACK VERSION ==="
grep -oE 'jetpack[^?]*\?ver=[0-9]+' "$CDX" | sort -u
echo ""
echo "=== EARLIEST CAPTURES (2010-2012 = old static site) ==="
grep -E '^2010|^2011|^2012' "$CDX" | awk '{print $1, $2}'
echo ""
echo "=== DIRECTORS/KOMISARIS PAGES (PII-ish) ==="
awk '{print $2}' "$CDX" | grep -iE 'direktur|komisaris|pendiri|manajemen' | sort -u
echo ""
echo "=== FINANCIAL REPORT PDFs (public) ==="
awk '{print $2}' "$CDX" | grep -iE '\.pdf' | sort -u
