#!/bin/bash
for t in tor torsocks torbrowser-launcher protonvpn-cli protonvpn openvpn wg wireguard nyx curl; do
  printf '%-22s ' "$t"
  command -v "$t" || echo MISSING
done
echo "---"
echo "curl ip check (no vpn):"
curl -s --max-time 10 https://api.ipify.org 2>/dev/null || echo "no net"
echo ""
