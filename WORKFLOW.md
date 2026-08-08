# Workflow Pentest Website Lengkap

Alur end-to-end pentest website, memaksimalkan penggunaan 58 skill di `.agents/skills/` dan tooling yang sudah ada (`tools/Prism-platform`, `tools/spiderfoot`). Semua instalasi app/dependency diarahkan ke venv WSL project: `/mnt/d/Projects/ceh/ceh/bin/python`.

> **Syarat:** target harus punya izin tertulis (bug bounty scope, kontrak, atau lab milik sendiri). Tanpa izin -> STOP.

---

## Fase 0 - Persiapan & Izin

| Aksi | Skill | Workflow/Perintah |
|---|---|---|
| Tentukan scope, target, batasan (domain/IP range) | - | Catat di `results/engagement.json` |
| Konfirmasi izin tertulis | - | Wajib sebelum fase 1 |
| Setup blackboard | - | `mkdir -p results/{recon,findings,report}` |

---

## Fase 1 - Recon & Footprint (Passive)

Tujuannya: peta aset, teknologi, email, subdomain, exposure tanpa menyentuh target agresif.

| Aksi | Skill di-load | Workflow |
|---|---|---|
| Footprint domain: WHOIS, DNS, crt.sh, GeoIP | `offensive-osint`, `offensive-osint-methodology` | Prism: `python cli.py scan <domain> --type domain --json` |
| Subdomain + cert transparency | `offensive-osint-methodology` | Prism `cert_transparency` module (otomatis dalam scan) |
| Teknologi web stack (headers, fingerprint) | `offensive-osint-methodology` | Prism `website` module |
| Email & username exposure | `offensive-osint` | Prism: `scan <email> --type email`, `scan <user> --type username` |
| Deep footprint + correlations | `offensive-osint-methodology` | SpiderFoot: `python sf.py -s <target> -u all -o json` |
| Histori & endpoint tersembunyi | `offensive-osint` | Prism `wayback` module (snapshot + URLs) |
| Threat intel (IP/domain reputation) | `offensive-osint` | Prism: `shodan`, `virustotal`, `abuseipdb`, `censys` |

**Output:** `results/recon/<target>.json`

---

## Fase 2 - Fast Triage (Quick-Win)

Tujuannya: temuan cepat berisiko tinggi yang sering terlewat.

| Aksi | Skill di-load | Workflow |
|---|---|---|
| Checklist quick-win: default creds, error leakage, exposed files, header misconfig, robots.txt, backup files | `offensive-fast-checking` | Manual/Burp/curl dari output recon |
| Open redirect check | `offensive-open-redirect` | Manual |
| Parameter pollution scan awal | `offensive-parameter-pollution` | Manual |

**Output:** `results/findings/fast-triage.json`

---

## Fase 3 - Mapping & Identifikasi Permukaan Serangan

Dari output recon, tentukan endpoint yang masuk scope dan surface serangan:

| Terdeteksi | Dispatch skill |
|---|---|
| Params menerima input user | SQLi, XSS, SSTI, XXE |
| Endpoint `/graphql` | `offensive-graphql` |
| Form upload | `offensive-file-upload` |
| Token JWT/OAuth | `offensive-jwt`, `offensive-oauth` |
| Header aneh / proxy | `offensive-request-smuggling` |
| Objek ID langsung di URL | `offensive-idor` |

**Output:** `results/findings/mapping.json`

---

## Fase 4 - Assessment Web (Per Attack Surface)

### 4.1 Input Injection

| Attack surface | Skill di-load |
|---|---|
| SQL injection (error-based, blind, OOB, DB-specific, ORM) | `offensive-sqli` |
| Cross-site scripting (stored, reflected, DOM) | `offensive-xss` |
| Server-side template injection | `offensive-ssti` |
| XML external entity | `offensive-xxe` |
| Command injection / RCE | `offensive-rce` |
| Insecure deserialization (Java/PHP/.NET gadget) | `offensive-deserialization` |

### 4.2 Access Control & Logic

| Attack surface | Skill di-load |
|---|---|
| Insecure direct object references | `offensive-idor` |
| Business logic (harga, refund, workflow bypass, race) | `offensive-business-logic` |
| Race condition (TOCTOU, single-packet) | `offensive-race-condition` |
| Parameter pollution | `offensive-parameter-pollution` |

### 4.3 Request-Level

| Attack surface | Skill di-load |
|---|---|
| SSRF (cloud metadata, filter bypass) | `offensive-ssrf` |
| HTTP request smuggling (CL.TE, TE.CL, h2 desync) | `offensive-request-smuggling` |
| Open redirect (OAuth abuse, phishing pivot) | `offensive-open-redirect` |

### 4.4 Infra-Level

| Attack surface | Skill di-load |
|---|---|
| GraphQL (introspection, batching, IDOR via alias) | `offensive-graphql` |
| File upload (extension bypass, polyglot, webshell) | `offensive-file-upload` |
| WAF bypass (encoding, chunking, mutation) | `offensive-waf-bypass` |

**Output per surface:** `results/findings/<surface>.json`

---

## Fase 5 - Auth & Identity

| Aksi | Skill di-load |
|---|---|
| JWT: alg:none, key confusion, secret cracking | `offensive-jwt` |
| OAuth: redirect abuse, token leakage, PKCE bypass | `offensive-oauth` |

**Output:** `results/findings/auth.json`

---

## Fase 6 - Deep / Exploit (Opsional, sesuai temuan)

| Kondisi | Skill di-load |
|---|---|
| Ada CVE/pattern yang bisa di-fuzz | `offensive-fuzzing`, `offensive-bug-identification`, `offensive-vuln-classes` |
| Perlu exploit dev untuk PoC | `offensive-exploit-development`, `offensive-basic-exploitation`, `offensive-crash-analysis` |
| Target punya infrastruktur cloud | `offensive-cloud` |
| Infra AD/Windows terdeteksi | `offensive-active-directory`, `offensive-initial-access`, `offensive-advanced-redteam` |

---

## Fase 7 - Reporting

| Aksi | Skill di-load | Workflow |
|---|---|---|
| Susun laporan: exec summary, temuan (CVSS v3.1/v4), reproduksi, dampak, remediasi, bukti | `offensive-reporting`, `offensive-fast-checking` | Manual (struktur di skill) |
| Generate deliverable | `offensive-reporting` | Prism: `cli.py scan <target> --html --pdf` untuk report OSINT; rangkai temuan manual |

**Output:** `report/<tipe>_<namatarget>_<yyyymmdd>_<hhmm>.md`

Konvensi penamaan (lihat README): tipe + namatarget + timestamp lokal. Contoh:
- `report/web_bprlestaribali_20260808_0743.md`
- `report/person_cgyudistira_20260808_0743.md`

---

## Instalasi Tool Tambahan (via WSL venv project)

Semua dependency di-install di venv WSL, bukan global:

```bash
# Aktifkan pip di venv (dibuat tanpa pip)
/mnt/d/Projects/ceh/ceh/bin/python -m ensurepip

# Install di dalam venv project
/mnt/d/Projects/ceh/ceh/bin/python -m pip install <package>

# Contoh: dependency SpiderFoot (cherrypy, dll)
/mnt/d/Projects/ceh/ceh/bin/python -m pip install -r /mnt/d/Projects/ceh/tools/spiderfoot/requirements.txt

# Tool CLI yang diinstal via pip, panggil langsung dari venv
/mnt/d/Projects/ceh/ceh/bin/python -m tool_name ...
```

Tool berbasis repo (bukan pip) diletakkan di `tools/` — taruh dependency-nya di venv, jalankan interpreter venv terhadap kode tool:

```bash
cd /mnt/d/Projects/ceh/tools/<tool>
/mnt/d/Projects/ceh/ceh/bin/python main.py ...
```

---

## Ringkasan Pipeline

```
[0 Izin] -> [1 Recon OSINT: Prism + SpiderFoot]
         -> [2 Fast Triage] -> [3 Mapping Surface]
         -> [4 Assessment Web: SQLi/XSS/SSTI/XXE/RCE/SSRF/IDOR/Logic/Upload/GraphQL/WAF]
         -> [5 Auth: JWT/OAuth]
         -> [6 Deep/Exploit: fuzzing/AD/cloud (opsional)]
         -> [7 Reporting: offensive-reporting] -> report/<tipe>_<target>_<ts>.md
```

Skill yang terlibat minimal: `offensive-osint`, `offensive-osint-methodology`, `offensive-fast-checking`, seluruh skill web layer assessment, `offensive-jwt`, `offensive-oauth`, `offensive-reporting` — plus skill deep saat kondisi sesuai. Semua workflow dieksekusi via interpreter venv WSL (`/mnt/d/Projects/ceh/ceh/bin/python`).
