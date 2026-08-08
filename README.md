# DMLab CEH — Agentic AI Pentest & OSINT Framework

Framework pembelajaran **CEH (Certified Ethical Hacker)** dan orkestrasi **Agentic AI Pentesting** berbasis **58 standard skills** (format `SKILL.md`, agent-agnostic) serta integrasi tooling OSINT (Prism CLI, SpiderFoot).

> **Pemberitahuan Kepatuhan & Etika:**
> Workspace ini dirancang khusus untuk keperluan edukasi, riset keamanan, dan **pengujian keamanan yang sah** (lab sendiri, CTF, dan program bug bounty / kontrak pentest dengan otorisasi tertulis). Penggunaan tanpa izin terhadap target di luar scope dilarang keras.

---

## Ringkasan Struktur Workspace

```
dmlab.ceh/
├── docs/                      # Dokumentasi lengkap & arsitektur
│   ├── AGENTS.md              # Arsitektur Multi-Agent (Commander & Specialist)
│   ├── WORKFLOW.md            # Alur kerja pentest 8-fase end-to-end
│   ├── ONBOARDING.md          # Panduan instalasi dan setup lengkap
│   ├── MINDMAP.md             # Peta cakupan 58 skill & referensi standar
│   ├── PROJECT-MANAGEMENT.md  # Manajemen engagement & evidence hygiene
│   └── IDEA.md                # Visi & arsitektur teknis
├── skills/                    # Library 58 standard skills (Source of Truth)
├── tools/
│   ├── prism/                 # OSINT & Footprinting Engine (Git Submodule)
│   ├── spiderfoot/            # OSINT Automation Engine (Git Submodule)
│   └── src/                   # Script otomasi instalasi & helper
├── template/                  # Template pelaporan teknis (TEMPLATE.md)
├── report/                    # Direktori deliverable laporan (Lokal / Gitignored)
├── results/                   # Shared blackboard hasil temuan (Lokal / Gitignored)
├── .agents/                   # Target instalasi skill lokal project (Gitignored)
└── .venv/                     # Python Virtual Environment lokal (Gitignored)
```

---

## Alur Instalasi & Setup Cepat

Framework ini **cross-platform** (Windows, Linux, macOS) dan menerapkan isolasi penuh (semua dependensi terpasang lokal di project tanpa mengotori sistem global).

### 1. Inisialisasi Repositori & Tooling

Tarik repository beserta submodule tools pendukung:

```bash
git clone --recurse-submodules https://github.com/digimetalab/dmlab.ceh.git
cd dmlab.ceh
```

*(Jika sudah ter-clone tanpa `--recurse-submodules`, jalankan: `git submodule update --init --recursive`)*

### 2. Konfigurasi Virtual Environment (`.venv`) & Dependensi

**Linux / macOS:**
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

**Windows (PowerShell):**
```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### 3. Instalasi Skills ke Agent Lokal

Pasang 58 skills langsung ke direktori lokal project (`.agents/skills/`):

- **Universal (Windows, Linux, macOS):**
  ```bash
  python tools/src/install_skills.py
  ```

- **Linux / macOS / Shell:**
  ```bash
  ./tools/src/install_skills.sh
  ```

---

## Alur Kerja Multi-Agent (Agentic Workflow)

Arsitektur agentic framework ini memisahkan peran antara **Commander (Orchestrator)** dan **Specialist Agents**:

```
+----------------------------------------------------------------+
|                   COMMANDER (Orchestrator)                     |
|  1. Scope & Auth Check -> 2. Build DAG Plan -> 3. Dispatch     |
+-------------------------------+--------------------------------+
                                |
        +-----------------------+-----------------------+
        v                       v                       v
+---------------+       +---------------+       +---------------+
|     RECON     |       |  ASSESSMENT   |       | DEEP EXPLOIT  |
|  OSINT Agents |  -->  |  Vuln Agents  |  -->  | Specialized   |
+---------------+       +---------------+       +---------------+
        |                       |                       |
        +-----------------------+-----------------------+
                                v
                    +-----------------------+
                    |    REPORTING AGENT    |
                    |  Hasil -> Markdown/PDF|
                    +-----------------------+
```

1. **Commander Agent**: Menganalisis intent, memvalidasi otorisasi target, dan menyusun rencana pengujian (DAG).
2. **Reconnaissance**: Menjalankan pengumpulan informasi permukaan serangan via Prism & SpiderFoot.
3. **Targeted Assessment**: Mengaktifkan specialist agent sesuai temuan (SQLi, XSS, Auth, API, Wireless, Cloud, dsb.).
4. **Shared Blackboard (`results/`)**: Menyimpan temuan antar-agent secara terstruktur dalam format JSON.
5. **Reporting**: Mengompilasi laporan akhir berstandar CVSS v3.1/v4.0 dan panduan remediasi ke direktori `report/`.

---

## Cakupan Skill Library (58 Skills)

| Kategori | Jumlah | Cakupan Area |
|---|---|---|
| **Web Application** | 16 | SQLi, XSS, SSRF, SSTI, XXE, IDOR, File Upload, RCE, Deserialization, Race Condition, Smuggling, Open Redirect, Parameter Pollution, GraphQL, WAF Bypass, Business Logic |
| **Authentication & IAM** | 2 | JWT, OAuth 2.0 |
| **Active Directory** | 1 | Kerberoasting, ASREPRoasting, ACL Abuse, AD CS, Lateral Movement |
| **Wireless & RF** | 14 | Wi-Fi Recon, WPA2/WPA3, Enterprise (802.1X), Evil Twin, Bluetooth BLE/Classic, Zigbee, LoRaWAN, Z-Wave |
| **Infrastructure & Cloud** | 8 | Cloud Security, Initial Access, Red Team Ops, EDR Evasion, Shellcode, Windows Internals |
| **Vulnerability Research** | 10 | Exploit Development, Crash Analysis, Fuzzing, Vuln Classes, TOCTOU |
| **OSINT & Recon** | 2 | OSINT Methodology, Intelligence Gathering |
| **AI & Utilities** | 5 | AI Security, Fast Triage, Reporting & Evidence Hygiene |

Lihat pemetaan lengkap dan matriks OWASP/MITRE pada [MINDMAP.md](docs/MINDMAP.md).

---

## Dokumentasi Terkait

- [Panduan Onboarding & Setup Detail](docs/ONBOARDING.md)
- [Arsitektur & Skema Agent Multi-Layer](docs/AGENTS.md)
- [Alur Kerja Pentest 8-Fase](docs/WORKFLOW.md)
- [Tata Kelola Manajemen Project & Bukti](docs/PROJECT-MANAGEMENT.md)
- [Peta Navigasi & Hubungan Skill](docs/MINDMAP.md)
- [Konsep & Visi Teknis Framework](docs/IDEA.md)
- [Kebijakan Keamanan (Security Policy)](SECURITY.md)
- [Panduan Kontribusi](CONTRIBUTING.md)
- [Riwayat Perubahan (Changelog)](CHANGELOG.md)
