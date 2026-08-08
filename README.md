# CEH Lab — Pentest & OSINT Workspace

Workspace untuk belajar **CEH (Certified Ethical Hacker)** dan membangun **agentic AI pentest** yang mengorkestrasi skill + tooling OSINT yang sudah ada.

> **Penting:** Gunakan hanya untuk target yang sudah Anda miliki izin (lab, CTF, bug bounty resmi). Lihat `AGENT-SCHEMA.md` — bagian Authorization.

---

## Struktur Folder

```
ceh/
├── .agents/
│   └── skills/            # 58 skill offensive security (format SKILL.md)
├── AGENT-SCHEMA.md        # Arsitektur multi-agent pentest
├── WORKFLOW-WEB-PENTEST.md # Alur pentest website lengkap (fase 0-7)
├── IDEA.md                # Visi & ide di balik proyek
├── ceh/                   # Python virtualenv (Python 3.14, via WSL)
├── tools/
│   ├── Prism-platform/    # Platform OSINT self-hosted (FastAPI + Next.js)
│   │   ├── cli.py         #   CLI scan: python cli.py scan <target> --json
│   │   └── modules/       #   22+ modul OSINT (WHOIS, DNS, Shodan, dll)
│   └── spiderfoot/        # SpiderFoot OSINT automation
│       └── sf.py          #   CLI: python sf.py -s <target> -u all -o json
├── report/                # Semua laporan pentest/OSINT (format: tipe_namatarget_yyyymmdd_hhmm.md)
```

## Konvensi Penamaan Report

Semua report disimpan di folder `report/` dengan format:

```
report/<tipe>_<namatarget>_<yyyymmdd>_<hhmm>.md
```

- **tipe** — kategori target: `web`, `person`, `domain`, `ip`, `email`, `phone`, `username`, `wireless`, `infra`, dst.
- **namatarget** — nama target (tanpa karakter aneh, tanpa ekstensi), mis. `bprlestaribali`, `cgyudistira`.
- **yyyymmdd_hhmm** — timestamp lokal saat report dibuat.

Contoh:

```
report/web_bprlestaribali_20260808_0743.md
report/person_cgyudistira_20260808_0743.md
report/domain_example-com_20260808_1005.md
```

---

## Quick Start

Semua perintah Python dijalankan lewat **WSL** memakai venv project (`ceh/`).
Path WSL proyek ini: `/mnt/d/Projects/ceh`.

### 1. Recon OSINT via Prism CLI

```bash
# di dalam WSL
cd /mnt/d/Projects/ceh/tools/Prism-platform
/mnt/d/Projects/ceh/ceh/bin/python cli.py scan example.com --type domain --json --verbose
/mnt/d/Projects/ceh/ceh/bin/python cli.py scan example.com --html
/mnt/d/Projects/ceh/ceh/bin/python cli.py scan someone@example.com --type email --json
/mnt/d/Projects/ceh/ceh/bin/python cli.py scan cgyudistira --type username --json
```

Auto-detect tipe: `python cli.py scan example.com --json`

### 2. Recon via SpiderFoot

```bash
# pasang dependensi sekali (venv belum punya pip)
/mnt/d/Projects/ceh/ceh/bin/python -m ensurepip
/mnt/d/Projects/ceh/ceh/bin/python -m pip install -r /mnt/d/Projects/ceh/tools/spiderfoot/requirements.txt

# scan footprint penuh
cd /mnt/d/Projects/ceh/tools/spiderfoot
/mnt/d/Projects/ceh/ceh/bin/python sf.py -s example.com -u all -o json

# list modul
/mnt/d/Projects/ceh/ceh/bin/python sf.py -M
```

### 3. Multi-agent pentest

Ikuti skema di [`AGENT-SCHEMA.md`](AGENT-SCHEMA.md):

1. **Commander agent** — terima target, validasi izin, susun rencana.
2. **Recon agents** — jalankan Prism CLI + SpiderFoot untuk footprint.
3. **Assessment agents** — load skill sesuai permukaan serangan (SQLi, XSS, SSRF, ...).
4. **Reporting agent** — susun laporan (CVSS, bukti, remediasi) via skill `offensive-reporting`.

Skill aktif otomatis dikenali opencode dari `.agents/skills/` — sebut topiknya di perintah (contoh: "tes SQL injection") dan skill terkait akan di-load.

### 4. Pentest website lengkap

Ikuti [`WORKFLOW-WEB-PENTEST.md`](WORKFLOW-WEB-PENTEST.md) — pipeline 8 fase dari izin → recon → triage → assessment per-attack-surface → auth → exploit → reporting, memaksimalkan pemakaian skill.

---

## Workflow yang Tersedia

| Workflow | Perintah (dalam WSL, di folder tool) | Output |
|---|---|---|
| Prism scan domain/IP/email/phone/username/telegram | `/mnt/d/Projects/ceh/ceh/bin/python cli.py scan <target> --type <t>` | JSON/HTML/PDF |
| Prism scheduled re-scan | `/mnt/d/Projects/ceh/ceh/bin/python cli.py watchlist add <target> --interval 6` | entri watchlist |
| SpiderFoot footprint | `/mnt/d/Projects/ceh/ceh/bin/python sf.py -s <target> -u all -o json` | tab/CSV/JSON |
| Prism web dashboard | `docker compose up --build` (di `tools/Prism-platform`) | http://localhost |

---

## Catatan Environment

- Proyek memakai **WSL** (Ubuntu) — opencode berjalan di WSL, dan venv dibuat via WSL.
- Virtualenv ada di `ceh/` (path WSL: `/mnt/d/Projects/ceh/ceh`), Python 3.14.4, dibuat `--without-pip`.
- Jalankan semua perintah Python melalui WSL, pakai interpreter venv langsung:
  ```bash
  wsl -e /mnt/d/Projects/ceh/ceh/bin/python --version
  ```
- Untuk tool yang butuh install dependency (mis. SpiderFoot butuh `cherrypy`), aktifkan pip di venv lalu install di dalam venv WSL:
  ```bash
  /mnt/d/Projects/ceh/ceh/bin/python -m ensurepip
  /mnt/d/Projects/ceh/ceh/bin/python -m pip install <package>
  ```
