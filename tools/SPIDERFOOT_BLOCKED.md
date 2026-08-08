# SpiderFoot setup - blocked
Status: NOT INSTALLED (2026-08-08)
Reason: WSL default python3 = 3.14.4; dependency `lxml` punya build issue di 3.14 (no wheel, build dari source gagal di sandbox tanpa build-essential/root). cherrypy 18.10.0 terinstall OK (user-space, --break-system-packages).
Attempts:
  1. apt python3-pip -> butuh sudo (interactive auth tidak tersedia)
  2. ensurepip -> modul tidak ada
  3. get-pip --user -> PEP 668 externally-managed block
  4. --break-system-packages -> pip OK, spiderfoot 0.0.1 (package salah, bukan OSINT tool) -> uninstalled
  5. git clone smicallef/spiderfoot -> lxml build fail di py3.14
Fix path (masa depan):
  - Install python3.11/3.12 + venv (deadsnakes PPA) lalu pip install di venv
  - ATAU jalankan SpiderFoot via Docker: docker run -p 5001:5001 blacktop/spiderfoot
Note: SpiderFoot hanya alat enumerasi tambahan; seluruh scope passive recon+OSINT sudah selesai via Prism/crt.sh/Wayback/websearch tanpa tool ini.
