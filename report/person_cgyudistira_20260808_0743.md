---
title: "OSINT Digital Footprint Report"
target_type: "person"
target_name: "cgyudistira"
timestamp: "2026-08-08 07:43"
operator: "cgyudistira"
engagement: "self-assessment"
classification: "CONFIDENTIAL"
---

# Laporan Footprint Digital — cgyudistira

> Contoh report terisi (dummy) berdasarkan footprint username `cgyudistira`. Dipakai sebagai referensi bentuk akhir laporan.

| | |
|---|---|
| **Target** | cgyudistira (username) |
| **Tipe** | person |
| **Tanggal** | 2026-08-08 |
| **Operator** | cgyudistira |
| **Metodologi** | OSINT passive via Prism (Blackbird/Maigret) |
| **Klasifikasi** | Confidential |

---

## 1. Executive Summary

**Konteks engagement:**
Footprint pasif atas username `cgyudistira` dilakukan pada 2026-08-08 untuk menilai jejak digital pribadi.

**Temuan utama (headline):**
Username terdeteksi di 32 platform. Beberapa akun berisiko terhubung ke konten berbayar/komersial, sehingga jejak digital bersifat lintas-platform dan mudah dihubungkan antarlayanan.

**Verdict risiko:**
Postur exposure moderat. Tidak ditemukan data sensitif (kredensial/alamat), namun konsistensi username memudahkan agregasi profil oleh pihak ketiga.

**Ringkasan temuan:**

| Severity | Jumlah | Contoh teratas |
|---|---|---|
| Critical | 0 | — |
| High | 1 | Username identik di 32 platform (enumerasi mudah) |
| Medium | 1 | Akun komersial terhubung (AudioJungle, ThemeForest, Freelancer) |
| Low | 2 | Email/gravatar terhubung, profil teknis terbuka |
| Info | 28 | — |

**3 Rekomendasi strategis teratas:**
1. Gunakan alias berbeda per kategori layanan untuk memutus linkage lintas-platform.
2. Audit pengaturan privasi pada akun komersial & portofolio.
3. Hapus akun tidak terpakai untuk mempersempit permukaan OSINT.

---

## 2. Engagement Overview

### 2.1 Scope

| Item | Nilai |
|---|---|
| Target | username `cgyudistira` |
| Metode | Passive OSINT (tanpa interaksi target) |
| Periode | 2026-08-08, 07:43 |
| Dikecualikan | Deep web, social engineering, brute force |

### 2.2 Metodologi

1. Blackbird search (50+ situs) via Prism `username` scan
2. Agregasi hasil scan (32 situs terdeteksi)
3. Klasifikasi berdasarkan tipe layanan
4. Reporting (`offensive-reporting`)

### 2.3 Limitations / Asumsi

- Hanya layanan yang didukung Blackbird/Maigret yang terdeteksi; tidak lengkap 100%.
- Status akun (aktif/hapus) tidak diverifikasi satu per satu.

### 2.4 Timeline

| Tanggal | Aktivitas |
|---|---|
| 2026-08-08 | Scan username, agregasi hasil |

### 2.5 Tim

| Peran | Nama |
|---|---|
| Operator | cgyudistira |

---

## 3. Risk Summary

```
Severity   Count   Top Example
Critical     0     —
High         1     Username di 32 platform (Finding #1)
Medium       1     Akun komersial terhubung (Finding #2)
Low          2     Email terhubung / profil teknis terbuka (Finding #3, #4)
Info        28     —
```

---

## 4. Technical Findings

### Finding #1 — Username Konsisten di 32 Platform (Enumeration Friendly)

**Severity:** High (CVSS 5.3 — vector di bawah)
**Affected Scope:** username `cgyudistira` di 32 layanan
**Status:** Open
**CWE:** CWE-200 (Exposure of Sensitive Information)
**OWASP:** A01:2021 — Broken Access Control (profil publik)

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N = 5.3`
**Justifikasi per metrik:**
- `AV:N` — dapat diakses dari internet
- `AC:L` — tanpa kondisi khusus
- `PR:N` — tanpa autentikasi
- `UI:N` — tanpa interaksi pengguna
- `S:U` — tidak lintas scope
- `C:L` — exposure metadata profil, bukan data sensitif

#### Summary
Username identik di 32 platform memungkinkan agregasi profil secara otomatis (name-squatting, sosial engineering, doxxing).

#### Description
Konsistensi handle lintas layanan (dev.to, GitHub, Medium, TradingView, dst.) membuat seluruh jejak digital terhubung via satu pencarian.

#### Reproduction Steps
1. Jalankan scan username: `python cli.py scan cgyudistira --type username --json`
2. Amati 32 hasil di `results["blackbird"]`
3. Bandingkan profil di 3 platform acak untuk memverifikasi kesamaan handle

#### Evidence
- Hasil scan Blackbird: 32 situs terdeteksi

#### Impact
- Agregasi profil oleh penyerang: osint-agent dapat memetakan minat, teknologi, kontak, dan aktivitas lintas platform dalam hitungan menit.

#### Remediation
1. **Fix** — gunakan handle berbeda per kategori layanan
2. **Defense in depth** — aktifkan privasi profil di tiap platform
3. **Detection** — pantau mention handle sendiri via Google Alerts / Brandfetch

#### References
- CWE-200, OWASP A01:2021

#### Notes for Retest
- Jalankan scan ulang; target: penurunan jumlah platform dengan handle identik.

---

### Finding #2 — Akun Komersial Terhubung (Exposure Profesional)

**Severity:** Medium (CVSS 4.3 — vector di bawah)
**Affected Scope:** AudioJungle, ThemeForest, Freelancer, Envato (themeforest)
**Status:** Open
**CWE:** CWE-200
**OWASP:** A01:2021

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N = 4.3`

#### Summary
Akun di marketplace berbayar (portofolio desain/kode) mengekspos konten dan riwayat aktivitas komersial.

#### Description
Profil di AudioJungle/ThemeForest/Freelancer umumnya menampilkan portofolio publik. Ini membocorkan niche pekerjaan, skill, dan potensi klien.

#### Impact
- Target rekayasa sosial via kepura-puraan klien; profil profesional menjadi vektor phishing.

#### Remediation
1. Sembunyikan portofolio/riwayat dari publik bila tidak diperlukan
2. Gunakan alamat email terpisah untuk marketplace

#### Notes for Retest
- Verifikasi pengaturan visibilitas profil di masing-masing marketplace.

---

### Finding #3 — Email / Gravatar Terhubung

**Severity:** Low (CVSS 3.1 — vector di bawah)
**Affected Scope:** gravatar, wordpress.com, medium.com
**Status:** Open
**CWE:** CWE-200

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N = 3.1`

#### Summary
Gravatar terhubung mengekspos email hash yang dapat di-resolve.

#### Remediation
1. Ganti gravatar dengan avatar lokal tanpa hash email publik
2. Gunakan alamat email berbeda per layanan

---

### Finding #4 — Profil Teknis Terbuka (GitHub, Docker Hub, HuggingFace)

**Severity:** Low
**Affected Scope:** github.com/cgyudistira, hub.docker.com, huggingface.co
**Status:** Open

#### Summary
Repositori dan image publik mengekspos stack teknologi, library, dan kemungkinan konfigurasi.

#### Remediation
1. Audit repo publik: hapus secret, key, `.env`
2. Gunakan scanner secret sebelum push (gitleaks/trufflehog)

---

## 5. Attack Narratives / Chains

```
1. OSINT handle cgyudistira (Finding #1, High)
2. Profil teknis GitHub + image Docker (Finding #4, Low)
   → kemungkinan ekstraksi secret/library lama
3. Akun komersial → phishing sebagai klien (Finding #2, Medium)
```

---

## 6. Strategic Recommendations

1. Standardisasi tata kelola handle: alias terpisah per kategori layanan (menangani Finding #1, #2).
2. Audit kebocoran secret di seluruh repo/image publik (menangani Finding #4).
3. Minimalkan metadata email lintas platform (menangani Finding #3).

---

## 7. Appendices

### A. Tools Used

| Tool | Versi | Penggunaan |
|---|---|---|
| Prism CLI | 2.6.0 | scan username (Blackbird) |
| Blackbird | — | enumerasi 50+ situs |

### B. Raw Evidence Pointers

- Hasil scan Blackbird: 32 situs terdeteksi

### C. Glossary

- **OSINT** — Open Source Intelligence
- **Gravatar** — avatar global terhubung ke email

---

## Retest Summary

| Finding | Severity Asli | Status Retest | Tanggal Verifikasi |
|---|---|---|---|
| #1 | High | | |
| #2 | Medium | | |
| #3 | Low | | |
| #4 | Low | | |
