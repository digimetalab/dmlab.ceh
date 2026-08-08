#!/bin/bash
for t in curl dig host openssl whois httpx subfinder amass nuclei nmap whatweb wpscan nikto gobuster ffuf jq; do
  printf '%-12s ' "$t"
  command -v "$t" || echo MISSING
done
