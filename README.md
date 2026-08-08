# DMLab CEH — Agentic AI Pentest & OSINT Workspace

Workspace untuk belajar **CEH (Certified Ethical Hacker)** dan membangun **agentic AI pentest** yang mengorkestrasi skill + tooling OSINT. Berjalan di atas **58 skill offensive security** (format `SKILL.md`, agnostic terhadap AI agent) + workflow nyata (Prism CLI, SpiderFoot).

> **Penting:** Gunakan hanya untuk target yang sudah Anda miliki izin tertulis (lab, CTF, bug bounty resmi). Lihat [AGENTS.md](AGENTS.md) bagian Authorization. Dokumen & skill ini untuk **pengujian keamanan yang sah**.

---

## Model "Terinstall vs Source"

Project ini membedakan dua kondisi:

| Kondisi | Lokasi | Di GitHub? | Contoh |
|---|---|---|---|
| **TERINSTALL (dev/local)** | `.agents/`, `.venv/`, `report/`, `results/`, `graphify-out/`, `source/` | ❌ gitignored | skill ter-install di project, venv Python, laporan & data target, repo vendor yang di-clone |
| **SOURCE (milik project)** | `skills/`, `tools/src/`, `tools/prism`*, `tools/spiderfoot`*, `template/`, docs | ✅ di-commit | skill library, script pendukung, template report, dokumentasi |

\* `tools/prism` & `tools/spiderfoot` di-track sebagai **gitlink** (submodule embedded): kontennya tidak ikut di-commit, tetapi referensi versi tercatat. Clone lalu `git submodule update --init` atau clone manual ke path tersebut.

Saat agent (opencode/Claude/Cursor) berjalan, ia meng-install/menyalin skill ke `.agents/` secara lokal — **boleh ada di local, jangan di-commit**. `source/` menampung repo pihak ketiga yang di-clone untuk dipelajari (mis. `source/Claude-Red`). Keduanya aman di `.gitignore`.

---

## Struktur Folder

```
dmlab.ceh/
├── skills/                    # 58 skill offensive security (source, di-commit)
│   ├── offensive-sqli/SKILL.md
│   ├── offensive-xss/SKILL.md
│   ├── offensive-file-upload/SKILL.md
│   └── ...                    # (13 kategori coverage, lihat MINDMAP)
├── tools/
│   ├── prism/                 # Paket OSINT self-hosted (gitlink)
│   ├── spiderfoot/            # Paket SpiderFoot (gitlink)
│   └── src/                   # Script pendukung (bash/python one-off, di-commit)
├── template/                  # Template laporan (di-commit)
├── report/                    # Laporan pentest/OSINT (terinstall, gitignored)
├── results/                   # Blackboard findings (terinstall, gitignored)
├── source/                    # Repo vendor yang di-clone untuk studi (terinstall, gitignored)
├── .venv/                     # Python virtualenv lokal (terinstall, gitignored)
├── .agents/                   # Skill ter-install saat setup (terinstall, gitignored)
├── AGENTS.md                  # Arsitektur multi-agent pentest (Commander schema)
├── WORKFLOW.md                # Alur pentest website lengkap (fase 0-7)
├── ONBOARDING.md              # Panduan mulai pakai project ini
├── MINDMAP.md                 # Peta coverage skill per attack surface
├── PROJECT-MANAGEMENT.md      # Manajemen engagement & task
└── IDEA.md                    # Visi & ide di balik project
```

## Konvensi Penamaan Report

Semua laporan disimpan di `report/` (gitignored) dengan format:

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

Template tersedia di `template/TEMPLATE.md`.

---

## Quick Start

Project ini **cross-platform** (Windows, Linux, macOS). Semua dependensi di-install ke virtualenv lokal project **`.venv/`** — tidak pernah global.

### 0. Setup (satu kali)

```bash
# 1. Tarik gitlink tools (Prism, SpiderFoot)
git submodule update --init --recursive

# 2. Buat virtualenv lokal + install skills ke .agents project
python3 -m venv .venv          # Linux/macOS
# atau:  py -3 -m venv .venv   # Windows
# atau:  python -m venv .venv   # Windows (jika py launcher tak ada)

# Windows:
.venv\Scripts\activate
# Linux/macOS:
source .venv/bin/activate

pip install -r tools/spiderfoot/requirements.txt

# 3. Install 58 skill ke .agents/ project (lokal, bukan global)
./tools/src/install_skills.sh
```

> **Prinsip:** `.venv/` dan `.agents/` = kondisi terinstall lokal project, gitignored. Tidak ada yang menyentuh environment global.

### 1. Install skills ke agent Anda

Installer default menyalin skill ke `.agents/` **di dalam project ini** (lokal), agar orang yang clone project ini langsung mendapat skill tanpa menyentuh global:

```bash
./tools/src/install_skills.sh                     # ke .agents/ project (lokal)
./tools/src/install_skills.sh --only offensive-sqli offensive-xss   # subset
./tools/src/install_skills.sh --dry-run           # preview tanpa install
./tools/src/install_skills.sh --dir <path>        # target kustom
./tools/src/install_skills.sh --global            # (opsional) ke agent global
```

Format `SKILL.md` (YAML frontmatter `name` + `description`) didukung **Claude Code, opencode, Cursor, Codex**, dan agent lain.

### 2. Recon OSINT via Prism CLI

```bash
# pastikan gitlink tools/prism sudah ditarik (step 0.1)
cd tools/prism
python cli.py scan example.com --type domain --json --verbose
python cli.py scan example.com --html
python cli.py scan someone@example.com --type email --json
python cli.py scan cgyudistira --type username --json
```

### 3. Recon via SpiderFoot

```bash
# step 0.2 sudah install dependency-nya ke .venv
cd tools/spiderfoot
python sf.py -s example.com -u all -o json

# list modul
python sf.py -M
```

### 4. Multi-agent pentest

Ikuti skema di [AGENTS.md](AGENTS.md):

1. **Commander agent** — terima target, validasi izin, susun rencana.
2. **Recon agents** — jalankan Prism CLI + SpiderFoot untuk footprint.
3. **Assessment agents** — load skill sesuai permukaan serangan (SQLi, XSS, SSRF, ...).
4. **Reporting agent** — susun laporan (CVSS, bukti, remediasi) via skill `offensive-reporting`.

Sebut topiknya di perintah (contoh: "tes SQL injection") dan skill terkait akan di-load.

### 5. Pentest website lengkap

Ikuti [WORKFLOW.md](WORKFLOW.md) — pipeline 8 fase dari izin → recon → triage → assessment per-attack-surface → auth → exploit → reporting, memaksimalkan pemakaian skill.

---

## Skill Library (58)

Semua skill memakai format standar `SKILL.md`:

```yaml
---
name: offensive-sqli
description: "..."
---
```

| Kategori | Skill |
|---|---|
| **Web (16)** | sqli, xss, ssrf, ssti, xxe, idor, file-upload, rce, deserialization, race-condition, request-smuggling, open-redirect, parameter-pollution, graphql, waf-bypass, business-logic |
| **Auth (2)** | jwt, oauth |
| **Active Directory (1)** | active-directory |
| **Wireless (14)** | wifi, wifi-recon, wpa2-psk, wpa3-sae, wpa-enterprise, wps, evil-twin, krack-fragattacks, deauth-disassoc, bluetooth-ble, bluetooth-classic, zigbee-thread-matter, z-wave, lorawan-sub-ghz |
| **Cloud (1)** | cloud |
| **Mobile (1)** | mobile |
| **IoT (1)** | iot |
| **Infrastructure (7)** | initial-access, advanced-redteam, edr-evasion, shellcode, keylogger-arch, windows-mitigations, windows-boundaries |
| **Exploit Dev (6)** | exploit-development, exploit-dev-course, basic-exploitation, crash-analysis, mitigations, toctou |
| **Fuzzing (4)** | fuzzing, fuzzing-course, bug-identification, vuln-classes |
| **Recon (2)** | osint, osint-methodology |
| **AI (1)** | ai-security |
| **Utility (2)** | fast-checking, reporting |

Coverage per attack surface dengan referensi OWASP/MITRE: lihat [MINDMAP.md](MINDMAP.md).

---

## Workflow yang Tersedia

> Aktifkan venv dulu (`.venv`), lalu jalankan dari folder tool. Path relatif ke `tools/prism` / `tools/spiderfoot`.

| Workflow | Perintah (setelah `cd tools/prism` / `cd tools/spiderfoot`) | Output |
|---|---|---|
| Prism scan domain/IP/email/phone/username/telegram | `python cli.py scan <target> --type <t>` | JSON/HTML/PDF |
| Prism scheduled re-scan | `python cli.py watchlist add <target> --interval 6` | entri watchlist |
| SpiderFoot footprint | `python sf.py -s <target> -u all -o json` | tab/CSV/JSON |
| Prism web dashboard | `docker compose up --build` (di `tools/prism`) | http://localhost |

---

## Catatan Environment

- **Cross-platform** — berjalan di Windows, Linux, dan macOS. Tidak bergantung pada WSL.
- Virtualenv lokal di **`.venv/`** (gitignored). Python 3.8+ disarankan (Prism & SpiderFoot mendukung Python 3).
- Aktifkan venv lalu jalankan semua perintah Python dari dalamnya:
  - Windows: `.venv\Scripts\activate`
  - Linux/macOS: `source .venv/bin/activate`
- Dependency tool di-install ke `.venv/`, tidak pernah global:
  ```bash
  pip install -r tools/spiderfoot/requirements.txt
  ```
- Semua setup otomatis bisa dicek via [ONBOARDING.md](ONBOARDING.md).

---

## Etika & Batasan

- Hanya untuk target dengan izin resmi (lab, CTF, bug bounty). **No authz → no execution.**
- Tidak mem-publish data target; semua output lokal di `report/` & `results/` (gitignored).
- Dokumentasi dan seluruh skill ditujukan untuk **pengujian keamanan yang sah**.
