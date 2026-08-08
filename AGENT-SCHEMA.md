# Agent Pentest Schema

Arsitektur **multi-agent AI** untuk pentest web/infrastruktur yang lengkap. Setiap agent = satu otak specialist (di-drive oleh 1+ skill dari `.agents/skills/`) + satu workflow nyata (Prism CLI / SpiderFoot). Skill **tidak diubah** - hanya di-load on-demand sesuai fase.

---

## 1. Prinsip Inti

| Prinsip | Aturan |
|---|---|
| **1 skill = 1 specialist** | Agent tidak punya pengetahuan built-in; ia me-load SKILL.md yang relevan saat di-dispatch |
| **Orchestrator, bukan monolith** | Commander agent mengatur alur; specialist agent mengerjakan satu domain |
| **Workflow yang ada** | Eksekusi via Prism CLI (`python cli.py scan ...`) dan SpiderFoot (`sf.py -m ...`) - tidak reinvent tooling |
| **Shared blackboard** | Temuan antar agent disimpan di `results/` sebagai JSON, dibaca agent berikutnya |
| **Authorization gate** | Tidak ada fase eksekusi sebelum scope + izin tertulis divalidasi |
| **Evidence hygiene** | Setiap temuan diberi timestamp, tool, dan bukti mentah (aturan `offensive-reporting`) |

---

## 2. Struktur Layer

```
+-----------------------------------------------------------+
|              COMMANDER (Orchestrator Agent)               |
|  baca intent -> validasi izin -> susun rencana DAG ->     |
|  dispatch specialist -> agregasi temuan -> status          |
+---------------------------+-------------------------------+
                            | dispatch (load skill + panggil workflow)
            +---------------+-------------------+
            v               v                   v
      +------------+  +--------------+  +----------------+
      | RECON      |  | ASSESSMENT   |  | DEEP / EXPLOIT |
      | agents     |  | agents       |  | agents         |
      +------------+  +--------------+  +----------------+
            |               |                   |
            +---------------+-------------------+
                            v
                  +-------------------+
                  | REPORTING AGENT   |  -> deliverable (PDF/HTML/MD)
                  +-------------------+
```

---

## 3. Commander Agent (Orchestrator)

**Peran:** single entry point. Bertanggung jawab atas seluruh siklus hidup engagement.

**Alur kerja:**
1. **Parse intent** - ekstrak target, tipe (domain/ip/email/phone/username), scope, dan tujuan dari perintah user.
2. **Authorization gate** - wajib konfirmasi izin sebelum eksekusi. Jika tidak jelas -> berhenti, minta klarifikasi.
3. **Plan build** - susun DAG fase berdasarkan tipe target:
   ```
   recon -> fast-triage -> assessment -> deep -> reporting
   ```
   Setiap node berisi: agent tujuan, skill yang di-load, workflow yang dijalankan.
4. **Dispatch** - panggil specialist agent, beri konteks blackboard (target, scope, temuan sebelumnya).
5. **Aggregate & escalate** - hasil assessment menentukan apakah perlu agent deep (contoh: temuan SQLi -> dispatch agent sqli; endpoint GraphQL -> dispatch agent graphql).
6. **Status tracking** - simpan progress di `results/engagement.json`.

**Contoh perintah user -> plan:**

| Perintah | Fase yang di-activate |
|---|---|
| "scan target domain X" | recon -> fast-triage -> assessment web |
| "tes SQLi di endpoint ini" | assessment web (agent sqli) -> reporting |
| "pentest wireless" | recon wireless -> assessment wireless -> reporting |
| "laporin hasil scan" | reporting |

---

## 4. Specialist Agents & Skill Mapping

### Layer RECON

| Agent | Skill di-load | Workflow |
|---|---|---|
| **osint-agent** | `offensive-osint`, `offensive-osint-methodology` | `python tools/Prism-platform/cli.py scan <target> --type <domain\|email\|phone\|username> --json` |
| **spiderfoot-agent** | `offensive-osint-methodology` | `python tools/spiderfoot/sf.py -s <target> -u all -o json` |
| **fast-triage-agent** | `offensive-fast-checking` | Baca output recon, jalankan checklist quick-win |

### Layer ASSESSMENT (per attack surface)

| Agent | Skill di-load |
|---|---|
| **web-agent** | `offensive-fast-checking`, `offensive-business-logic`, `offensive-parameter-pollution`, `offensive-idor`, `offensive-race-condition` |
| **sqli-agent** | `offensive-sqli`, `offensive-waf-bypass` |
| **xss-agent** | `offensive-xss`, `offensive-waf-bypass` |
| **ssrf-agent** | `offensive-ssrf`, `offensive-open-redirect` |
| **ssti-agent** | `offensive-ssti` |
| **xxe-agent** | `offensive-xxe` |
| **file-upload-agent** | `offensive-file-upload` |
| **rce-agent** | `offensive-rce` |
| **deserialization-agent** | `offensive-deserialization` |
| **smuggling-agent** | `offensive-request-smuggling` |
| **graphql-agent** | `offensive-graphql` |
| **auth-agent** | `offensive-jwt`, `offensive-oauth` |
| **ad-agent** | `offensive-active-directory` |
| **wireless-agent** | `offensive-wifi`, `offensive-wifi-recon`, `offensive-wpa2-psk`, `offensive-wpa3-sae`, `offensive-wpa-enterprise`, `offensive-wps`, `offensive-evil-twin`, `offensive-deauth-disassoc`, `offensive-bluetooth-ble`, `offensive-bluetooth-classic`, `offensive-zigbee-thread-matter`, `offensive-z-wave`, `offensive-lorawan-sub-ghz` |
| **cloud-agent** | `offensive-cloud` |
| **mobile-agent** | `offensive-mobile` |
| **iot-agent** | `offensive-iot` |
| **ai-agent** | `offensive-ai-security` |

### Layer DEEP / EXPLOIT

| Agent | Skill di-load |
|---|---|
| **exploit-agent** | `offensive-exploit-development`, `offensive-basic-exploitation`, `offensive-crash-analysis`, `offensive-toctou` |
| **redteam-agent** | `offensive-initial-access`, `offensive-advanced-redteam`, `offensive-edr-evasion`, `offensive-shellcode`, `offensive-keylogger-arch`, `offensive-windows-boundaries`, `offensive-windows-mitigations` |
| **fuzzing-agent** | `offensive-fuzzing`, `offensive-bug-identification`, `offensive-vuln-classes` |

### Layer REPORTING

| Agent | Skill di-load |
|---|---|
| **reporting-agent** | `offensive-reporting`, `offensive-fast-checking` |

---

## 5. Data Flow & Blackboard

```
results/
├── engagement.json      <- status seluruh engagement (Commander)
├── recon/<target>.json  <- output recon (osint-agent, spiderfoot-agent)
└── findings/            <- temuan tiap specialist agent (per fase)
    ├── fast-triage.json
    ├── sqli.json
    └── ...

report/                  <- deliverable akhir (reporting-agent)
    └── <tipe>_<namatarget>_<yyyymmdd>_<hhmm>.md
```

**Alur temuan:**
1. Specialist agent selesai -> tulis temuan JSON ke `results/findings/<phase>.json`.
2. Commander baca semua findings -> tentukan eskalasi.
3. Reporting-agent konsumsi seluruh findings + recon -> susun laporan sesuai `offensive-reporting` (CVSS, bukti, remediasi) ke `report/<tipe>_<namatarget>_<yyyymmdd>_<hhmm>.md`.

---

## 6. Escalation Rules (Logika Dispatch)

Commander memutuskan eskalasi dari output fase sebelumnya:

| Temuan | Dispatch ke |
|---|---|
| Target punya web app aktif | web-agent -> fast-triage |
| Params menerima input user | sqli-agent, xss-agent, ssti-agent, xxe-agent |
| Endpoint `/graphql` terdeteksi | graphql-agent |
| Upload form ditemukan | file-upload-agent |
| Header/behavior aneh (CL.TE) | smuggling-agent |
| Token JWT/OAuth dipakai | auth-agent |
| Infra Windows + domain | ad-agent, redteam-agent |
| Target wireless/scoped RF | wireless-agent |
| Cloud aset teridentifikasi | cloud-agent |
| CVE/pattern fuzzable | fuzzing-agent -> exploit-agent |

---

## 7. Authorization & Safety (WAJIB)

1. Hanya eksekusi terhadap target dengan **izin tertulis** (bug bounty scope, kontrak, atau lab milik sendiri).
2. Commander **wajib** konfirmasi scope sebelum dispatch fase eksekusi.
3. Semua output disimpan lokal; **tidak ada data target yang di-commit** ke repositori publik.
4. Dokumen ini untuk pendidikan & pengujian resmi saja.
