---
title: "Penetration Test Report"
target_type: "web"
target_name: ""
timestamp: ""
operator: ""
engagement: ""
classification: "CONFIDENTIAL"
---

# Laporan Pentest — <Nama Target>

> Template sesuai metodologi `offensive-reporting`. Isi semua bagian bertanda `<...>`. Hapus bagian yang tidak relevan. Naming convention: `report/<tipe>_<namatarget>_<yyyymmdd>_<hhmm>.md`

| | |
|---|---|
| **Target** | `<nama target>` |
| **Tipe** | `<web / person / domain / ip / email / phone / username / wireless / infra>` |
| **Tanggal** | `<yyyy-mm-dd>` |
| **Operator** | `<nama/alias>` |
| **Metodologi** | OWASP ASVS, PTES, NIST SP 800-115 |
| **Klasifikasi** | Confidential |

---

## 1. Executive Summary

> Tulis TERAKHIR, dibaca PERTAMA. Maksimal 1 halaman, untuk CISO/board. Hindari istilah teknis (RCE, XSS, SQLi, payload). Fokus dampak bisnis.

**Konteks engagement:**
<Satu kalimat: apa yang diuji, kapan, oleh siapa>

**Temuan utama (headline):**
<2-3 kalimat: hal terburuk yang ditemukan, dalam bahasa bisnis. Contoh: "Penyerang tanpa login dapat membaca seluruh data nasabah lewat celah pada endpoint laporan.">

**Verdict risiko:**
<1 paragraf: postur keamanan keseluruhan dalam bahasa sederhana>

**Ringkasan temuan:**

| Severity | Jumlah | Contoh teratas |
|---|---|---|
| Critical | | |
| High | | |
| Medium | | |
| Low | | |
| Info | | |

**3 Rekomendasi strategis teratas:**
1. <programmatic fix, bukan "patch CVE-X">
2. <programmatic fix>
3. <programmatic fix>

---

## 2. Engagement Overview

### 2.1 Scope

| Item | Nilai |
|---|---|
| Domain/IP dalam scope | |
| Aset dalam scope | |
| Periode pengujian | `<mulai> s.d. <selesai>` |
| Dikecualikan | `<SaaS pihak ketiga, social engineering, DoS, dst>` |

### 2.2 Metodologi

1. Recon & footprint (passive) — Prism, SpiderFoot
2. Fast triage — checklist quick-win (`offensive-fast-checking`)
3. Mapping permukaan serangan
4. Assessment per attack surface (`offensive-sqli`, `offensive-xss`, ...)
5. Auth & identity (`offensive-jwt`, `offensive-oauth`)
6. Deep / exploit (jika relevan)
7. Reporting (`offensive-reporting`)

### 2.3 Limitations / Asumsi

- `<batasan: hanya dari internet, tanpa akses internal>`
- `<asumsi: staging mencerminkan production, dst>`

### 2.4 Timeline

| Tanggal | Aktivitas |
|---|---|
| | |

### 2.5 Tim

| Peran | Nama |
|---|---|
| Operator | |

---

## 3. Risk Summary

```
Severity   Count   Top Example
Critical     n      <finding #x>
High         n      <finding #x>
Medium       n      <finding #x>
Low          n      <finding #x>
Info         n      —
```

---

## 4. Technical Findings

> Satu bagian per temuan, urut berdasarkan severity. Salin blok template di bawah untuk tiap temuan.

### Finding #1 — <Judul Singkat Deskriptif>

**Severity:** `<Critical/High/Medium/Low> (CVSS x.x — vector di bawah)`
**Affected Scope:** `<host/URL/komponen + versi>`
**Status:** `Open`
**CWE:** `<CWE-ID (contoh: CWE-89 SQL Injection)>`
**OWASP:** `<A03:2021 — Injection>`

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H = 9.8`
**Justifikasi per metrik:**
- `AV:N` — <alasan>
- `AC:L` — <alasan>
- `PR:N` — <alasan>
- `UI:N` — <alasan>
- `S:U` — <alasan>
- `C/I/A` — <alasan>

#### Summary
<1 paragraf: apa temuannya, kenapa penting, worst case>

#### Description
<Akar masalah, bukan sekadar gejala. Root cause + konteks teknis>

#### Reproduction Steps
1. <Langkah copy-paste-ready>
2. <Sertakan request/response persis, sudah di-redact>
3. <Pembaca tanpa konteks harus bisa reproduksi <15 menit>

```
# contoh request/response
```

#### Evidence
- `<path/timestamp>`
- `<screenshots/requests/evidence-log>`

#### Impact
- <Konkret, terukur. Contoh: "Akses baca seluruh tabel nasabah (~2.3M records)">

#### Remediation
1. **Fix bug** — <perubahan kode/config spesifik>
2. **Defense in depth** — <WAF rule, input validation>
3. **Detection** — <log line / SIEM rule>

#### References
- CWE / OWASP / CAPEC
- <advisory CVE jika ada>

#### Notes for Retest
- <Request spesifik + response yang diharapkan untuk verifikasi fix>

---

## 5. Attack Narratives / Chains

> Hanya jika ada chain kritis. Kombinasi temuan sering lebih berbahaya dari temuan individu.

```
1. <langkah> (Finding #x, severity)
2. <langkah> (Finding #x, severity)
...
Total time: n jam. Detection points missed: n.
```

---

## 6. Strategic Recommendations

> 3-5 rekomendasi programatik yang menjawab banyak temuan sekaligus.

1. <rekomendasi> (mengatasi n finding)
2. <rekomendasi> (mengatasi seluruh chain)
3. <rekomendasi>

---

## 7. Appendices

### A. Tools Used

| Tool | Versi | Penggunaan |
|---|---|---|
| Prism CLI | 2.6.0 | OSINT recon |
| SpiderFoot | | footprint |
| <tool lain> | | |

### B. Raw Evidence Pointers

- `<path evidence mentah, di luar report>`

### C. Glossary

- **CVSS** — Common Vulnerability Scoring System
- **<istilah lain>** — <definisi>

---

## Retest Summary

| Finding | Severity Asli | Status Retest | Tanggal Verifikasi |
|---|---|---|---|
| #1 | | | |
| #2 | | | |
