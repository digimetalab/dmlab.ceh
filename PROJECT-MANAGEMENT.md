# PROJECT-MANAGEMENT — Manajemen Engagement & Task

Cara mengelola engagement pentest/OSINT di DMLab CEH: dari intake target, alur kerja Commander, hingga deliverable. Berlaku lintas agent — siapa pun yang jadi orchestrator memakai aturan ini.

---

## 1. Intake Target

Sebelum mulai, kunci 4 hal ini di engagement:

```yaml
target:
  nama: "bankkertiawan"          # nama pendek tanpa spasi/karakter aneh
  tipe: domain | ip | email | phone | username | person | web | wireless | infra
  scope: ["*.domain.com", "1.2.3.0/24"]
  izin: "bug-bounty-<id> | kontrak-<no> | lab"    # WAJIB tertulis
```

Authorization gate: **jika izin tidak jelas → berhenti, minta klarifikasi.** Tidak ada fase eksekusi tanpa scope + izin tervalidasi.

## 2. Alur Commander (DAG)

Commander menyusun rencana DAG dan mencatat progres di `results/engagement.json` (blackboard):

```
recon -> fast-triage -> assessment -> deep (escalation) -> reporting
```

Setiap node berisi: agent tujuan, skill yang di-load, workflow yang dijalankan. Setelah selesai, temuan ditulis ke `results/findings/<fase>.json`.

| Perintah user | Fase yang di-activate |
|---|---|
| "scan target domain X" | recon -> fast-triage -> assessment web |
| "tes SQLi di endpoint ini" | assessment web (agent sqli) -> reporting |
| "pentest wireless" | recon wireless -> assessment wireless -> reporting |
| "laporin hasil scan" | reporting |

## 3. Escalation Rules

Commander memutuskan eskalasi dari output fase sebelumnya:

| Temuan | Dispatch ke |
|---|---|
| Web app aktif | web-agent -> fast-triage |
| Params menerima input user | sqli-agent, xss-agent, ssti-agent, xxe-agent |
| Endpoint `/graphql` | graphql-agent |
| Upload form | file-upload-agent |
| Header/behavior aneh (CL.TE) | smuggling-agent |
| Token JWT/OAuth | auth-agent |
| Infra Windows + domain | ad-agent, redteam-agent |
| Target wireless/RF | wireless-agent |
| Cloud aset | cloud-agent |
| CVE/pattern fuzzable | fuzzing-agent -> exploit-agent |

## 4. Evidence Hygiene (Skill `offensive-reporting`)

Setiap temuan wajib punya:

1. **Timestamp** — kapan aksi dilakukan.
2. **Tool** — tool/perintah yang dipakai.
3. **Bukti mentah** — output/payload/response yang bisa direproduksi.

Contoh entri findings JSON:

```json
{
  "id": "SQ-001",
  "fase": "assessment-web",
  "tgl": "2026-08-08T07:43:00+08:00",
  "tool": "sqlmap -u <url>?id=1 --batch",
  "bukti": "Response 200, error: 'MySQL syntax ... near '1''",
  "severity": "high",
  "cvss": "8.1"
}
```

## 5. Blackboard & Output

```
results/
├── engagement.json        <- status seluruh engagement (Commander)
├── recon/<target>.json    <- output recon (osint-agent, spiderfoot-agent)
└── findings/              <- temuan per specialist (per fase)

report/                    <- deliverable akhir (reporting-agent)
└── <tipe>_<namatarget>_<yyyymmdd>_<hhmm>.md
```

## 6. Pelaporan

1. Konsumsi seluruh `results/findings/*.json` + `results/recon/*`.
2. Susun laporan sesuai skill `offensive-reporting`: executive summary (risk-led), per-finding (severity, CVSS + vector, scope, langkah reproduksi, impact, remediasi, referensi), evidence hygiene.
3. Simpan ke `report/<tipe>_<namatarget>_<yyyymmdd>_<hhmm>.md` (template: `template/TEMPLATE.md`).

## 7. Review & Retest

- **Review:** pastikan tidak ada permukaan yang terlewat (cross-check MINDMAP.md).
- **Retest:** verifikasi temuan yang diklaim sudah diremediasi; catat bukti retest di laporan.
- **Closing:** ringkas engagement di changelog project (lihat `CHANGELOG.md`) jika relevan.

## 8. Hygiene Git

- Hanya commit SOURCE (`skills/`, `tools/src/`, `template/`, docs) + referensi gitlink `tools/prism`, `tools/spiderfoot`.
- Jangan pernah commit: `report/`, `results/`, `.agents/`, `source/`, `graphify-out/`, `.venv/` (semua di `.gitignore`).
- Tidak ada data target di repositori publik.
