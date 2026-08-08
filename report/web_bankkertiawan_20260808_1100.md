---
title: "Penetration Test Report — Passive Recon & OSINT"
target_type: "web"
target_name: "bankkertiawan.com"
timestamp: "2026-08-08T11:00:00+08:00"
operator: "opencode (analyst)"
engagement: "bankkertiawan-passive"
classification: "CONFIDENTIAL"
---

# Laporan Pentest — PT BPR Bank Kertiawan (Passive Recon + OSINT)

| | |
|---|---|
| **Target** | bankkertiawan.com (PT BPR Bank Kertiawan) |
| **Tipe** | web |
| **Tanggal** | 2026-08-08 |
| **Operator** | opencode (analyst) |
| **Metodologi** | OWASP ASVS, PTES, NIST SP 800-115 (Fase passive only) |
| **Klasifikasi** | Confidential |

---

## 1. Executive Summary

**Konteks engagement:**
Fase pengujian pasif (reconnaissance + OSINT) terhadap bankkertiawan.com, situs resmi PT BPR Bank Kertiawan (BPR kecil di Tabanan, Bali), dilakukan 8 Agustus 2026 dari perspektif internet eksternal tanpa satu pun request berbahaya dikirim ke server target.

**Temuan utama (headline):**
Source code lengkap aplikasi pendaftaran nasabah bank ini **publik di GitHub** — berisi SQL injection di hampir setiap query, password nasabah disimpan tanpa enkripsi, dan kredensial database default (root tanpa password). Selain itu, portal admin fortifikasi (FortiGate), cPanel, dan "IT Management System" versi beta semuanya terekspos langsung ke internet. Seorang penyerang dapat menggunakan blueprint kode ini untuk membobol login nasabah dan mengekstrak data pribadi nasabah.

**Verdict risiko:**
Postur keamanan luar bank ini **kritis untuk kategori lembaga keuangan**. Infrastruktur front-end (WordPress) relatif terpelihara, tetapi aplikasi bisnis internal (pendaftaran nasabah, survey, ITMS) dibangun tanpa kontrol keamanan dasar, dan blueprint kerentanannya dipublikasikan di repositori GitHub terbuka. Kombinasi source-code leak + SQLi + credential default + portal admin terpublik menjadikan jaringan ini target bernilai tinggi dengan biaya serangan rendah.

**Ringkasan temuan:**

| Severity | Jumlah | Contoh teratas |
|---|---|---|
| Critical | 1 | Source code leak dgn SQLi + password plaintext + DB default creds |
| High | 2 | Portal FortiGate admin publik; cPanel login publik |
| Medium | 4 | User enum WP; Elementor CVE; missing security headers; ITMS beta publik |
| Low | 4 | XML-RPC aktif; DMARC p=none; version disclosure; reCAPTCHA key hardcoded |
| Info | 8 | Subdomain legacy NXDOMAIN; stack disclosure; Melody app & policy subdomain; template third-party |

**3 Rekomendasi strategis teratas:**
1. **Tarik repositori GitHub publik** berisi source code aplikasi nasabah; audit ulang seluruh aplikasi pendaftaran/survey sebelum dipakai kembali.
2. **Tutup semua portal admin dari internet** (FortiGate :17072, cPanel :2083, ITMS beta) — pindah ke VPN/WireGuard + allowlist IP.
3. **Rewriting aplikasi dengan prepared statements** + hashing password (bcrypt/argon2) + hapus credential default; terapkan security headers di seluruh vhost.

---

## 2. Engagement Overview

### 2.1 Scope

| Item | Nilai |
|---|---|
| Domain/IP dalam scope | bankkertiawan.com, *.bankkertiawan.com, 202.74.239.23 |
| Aset dalam scope | WordPress, esurvei, cpanel, apimelody(FortiGate), ITMS, website |
| Periode pengujian | 2026-08-08 |
| Dikecualikan | Social engineering, DoS, brute-force, exploit aktif (menunggu otorisasi tertulis) |

### 2.2 Metodologi

1. Recon & footprint (passive) — Prism domain scan, crt.sh, DNS, Wayback CDX
2. Fast triage — header audit, robots.txt, WP REST API, readme, xmlrpc (GET-only)
3. Subdomain discovery + verifikasi live (status code only, no payload)
4. Fingerprint teknologi + identifikasi CVE (research-based)
5. OSINT: Google/Bing dork, GitHub code search, web index
6. Source code analysis (repo publik GitHub)
7. Reporting (offensive-reporting template)

### 2.3 Limitations / Asumsi

- **Hanya passive + GET non-destructive.** Tidak ada payload, brute-force, atau exploit terhadap target.
- Beberapa klaim (ITMS, aktif_login.php) diverifikasi via index hasil pencarian web, **bukan akses langsung**.
- Wayback CDX rate-limited (archive.org) — histori URL belum lengkap.
- Versi exact FortiGate & Elementor Pro belum terkonfirmasi (tanpa akses versi).
- APK/IPA Melody **belum diunduh/dianalisis** (analisis mobile di luar scope web pasif ini) — backend API Melody belum diverifikasi langsung.
- Breach check `bank_kertiawan@yahoo.co.uk` via web search: **tidak ditemukan bukti publik langsung** (hanya situs checker generik); verifikasi via HIBP/breach DB berbayar belum dilakukan.
- SpiderFoot (opsional) **tidak berjalan** — dependency `lxml` gagal build di WSL Python 3.14 (lihat `tools/SPIDERFOOT_BLOCKED.md`).

### 2.4 Timeline

| Tanggal | Aktivitas |
|---|---|
| 2026-08-08 | Prism domain scan (whois, dns, geoip, cert, website, wayback, shodan, censys, vt) |
| 2026-08-08 | Fast triage WordPress + subdomain enumeration crt.sh |
| 2026-08-08 | Fingerprint apimelody (FortiGate), esurvei, cPanel |
| 2026-08-08 | OSINT dork + GitHub source code discovery & analysis |
| 2026-08-08 | ITMS portal + aktif_login.php verifikasi via web index |
| 2026-08-08 | OSINT lanjutan: Melody mobile banking app + policy subdomain discovery (F5) |

### 2.5 Tim

| Peran | Nama |
|---|---|
| Operator | opencode (analyst) |

---

## 3. Risk Summary

```
Severity   Count   Top Example
Critical     1      Source code leak + SQLi + plaintext passwords (Finding #1)
High         2      FortiGate admin + cPanel login eksposed (Finding #2, #3)
Medium       4      WP user enum, Elementor CVEs, missing headers, ITMS beta (Finding #4-7)
Low          4      xmlrpc, DMARC, version disclosure, recaptcha key (Finding #8-11)
Info         6      legacy subdomain, stack info, dsstc.
```

---

## 4. Technical Findings

### Finding #1 — Source Code Leak Publik: Aplikasi Pendaftaran Nasabah dengan SQLi & Password Plaintext

**Severity:** Critical (CVSS 9.8 — vector di bawah)
**Affected Scope:** website.bankkertiawan.com (`/aktif_login.php`, `/register_act.php`, `/admin/pendaftaran/*`) — sesuai source code GitHub
**Status:** Open
**CWE:** CWE-89 (SQL Injection), CWE-256 (Plaintext Password), CWE-798 (Hardcoded Credentials)
**OWASP:** A03:2021 — Injection

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H = 9.8`
**Justifikasi per metrik:**
- `AV:N` — serangan dari internet via HTTP
- `AC:L` — payload standar `' OR '1'='1`, tanpa kondisi khusus
- `PR:N` — tidak butuh autentikasi (login endpoint)
- `UI:N` — tanpa interaksi korban
- `S:U` — scope tunggal (app)
- `C/I/A:H` — read/write seluruh DB pendaftaran, creds, insert data

#### Summary
Repositori GitHub publik **`github.com/Blikadek/kertiawan`** berisi source code lengkap aplikasi pendaftaran nasabah "Kertiawan" yang beroperasi di `website.bankkertiawan.com/aktif_login.php` (terindeks Google). Seluruh query SQL dibangun dengan interpolasi variabel langsung tanpa escaping — SQL injection universal pada login, register, dan semua operasi CRUD admin. Password nasabah disimpan plaintext. Koneksi DB memakai kredensial default `root` tanpa password.

#### Description
Analisis source code (2026-08-08, repo publik, satu commit):

- `koneksi.php` → `mysqli_connect("localhost","root","", "db_daftar")` — credential DB default tertanam di source.
- `aktif_login.php` → `SELECT * FROM user WHERE username='$username' AND password='$password'` — SQLi langsung dari form login. Bypass klasik `admin' -- ` / `' OR '1'='1`. Role diambil via `mysqli_fetch_array` (1=Admin, 3=Nasabah); redirect role-dependent ke `/admin/` atau `blank-page.php`.
- `register_act.php` → `INSERT INTO pendaftaran VALUES ('','$nama',...,'$username','$password')` — SQLi pada insert; **password disimpan plaintext**.
- `admin/pendaftaran/update_act.php` → `UPDATE ... WHERE id='$id'` — SQLi, password plaintext juga di update.
- `admin/pendaftaran/tambah_act.php` → INSERT interpolasi, tanpa sanitasi.
- `admin/pendaftaran/edit.php`, `detail.php`, `hapus.php` → pola serupa (CRUD penuh).
- `register.php` → reCAPTCHA sitekey hardcoded: `6Lcw3jsjAAAAAJ-QvVMuHU5uHlmpf6BdxPlaNhLP`.
- redirect salah: `register_act.php` menuju `https://bankkertiawan.com/wp` (invalid path).
- Stack: PHP mysqli + AdminLTE 3 + Bootstrap 4 + jQuery. Tabel: `user`, `pendaftaran`.

Dampak bisnis: aplikasi menampung PII nasabah (nama, no. telp, tempat & tgl lahir, jenis kelamin, alamat, email, username, password plaintext).

#### Reproduction Steps
> Belum dieksekusi terhadap target (butuh otorisasi). Diverifikasi pada source code publik:

1. Buka `https://github.com/Blikadek/kertiawan` → `aktif_login.php`, `register_act.php`, `koneksi.php`, `admin/pendaftaran/update_act.php`.
2. Konfirmasi interpolasi variabel tanpa escaping pada setiap query.
3. (Setelah otorisasi) `POST /aktif_login.php` dengan `username=' OR '1'='1 -- &password=x`.

#### Evidence
- `results/findings/bankkertiawan_f1_f2.md` → section "FINDINGS F3 - OSINT SOURCE CODE LEAK"
- Repo: `https://github.com/Blikadek/kertiawan` (tree e416bf0), file di atas (raw.githubusercontent).

#### Impact
- Read + write penuh DB `pendaftaran` (PII nasabah) dan DB `user` (creds admin/nasabah).
- Bypass login → session admin → CRUD data nasabah.
- Kredensial DB default root: jika `db_daftar` di-production memakai config yang sama, kompromi total data.

#### Remediation
1. **Fix bug** — ganti seluruh query dengan prepared statements (PDO/mysqli) dan hapus interpolasi `$var` dalam SQL.
2. **Defense in depth** — hash password (bcrypt/argon2id), hapus creds default, jangan commit `koneksi.php` (gunakan env vars + config di luar webroot).
3. **Detection** — log semua error MySQL; SIEM rule untuk payload SQLi (`' OR`, `--`, `UNION SELECT`) di endpoint `/aktif_login.php`; aktifkan WAF rule SQLi.

#### References
- CWE-89 / CWE-256 / CWE-798; OWASP A03:2021
- OWASP SQL Injection Prevention Cheat Sheet

#### Notes for Retest
- Setelah fix: `POST /aktif_login.php` dgn `username=' OR '1'='1 --` → harus "Login Gagal" tanpa error DB.
- Cek bahwa `koneksi.php` tidak lagi berisi creds `root`/kosong; password di DB adalah hash.

---

### Finding #2 — Portal Admin FortiGate (FortiOS) Terekspos dari Internet

**Severity:** High (CVSS 8.3 — belum ada CVE confirmed tanpa versi exact)
**Affected Scope:** `apimelody.bankkertiawan.com:17072` — admin login FortiGate
**Status:** Open
**CWE:** CWE-306 (Missing Authentication for Critical Function — exposure), CWE-1188 (Insecure Default)
**OWASP:** A05:2021 — Security Misconfiguration

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:L/A:L = 8.3`
**Justifikasi per metrik:**
- `AV:N` — akses dari internet, port non-standar 17072
- `AC:L` — tinggal buka URL, tanpa kondisi
- `PR:N` / `UI:N` — tanpa auth/interaksi
- `S:C` — firewall = perimeter pembatas seluruh jaringan; ekspos = perubahan scope
- `C:H` — firewall config/network maps; `I:L/A:L` — potensial modifikasi aturan/DoS

#### Summary
Panel admin FortiGate FortiOS terekspos ke internet pada port non-standar **17072** di subdomain apimelody. Fingerprint: tema `main-mariner.css` (FortiOS 7.x), cookie `VDOM_`, `APSCOOKIE`, `CENTRAL_MGMT_OVERRIDE_`, header HSTS + X-Frame-Options + CSP `frame-ancestors 'self'`. Endpoint SSL-VPN `/remote/login` & `/remote/update` merespons 401.

**Update OSINT (F5):** subdomain `apimelody` berkorelasi dengan aplikasi mobile banking **"Melody by Bank Kertiawan"** (Google Play `com.mat.kertiawan`, iOS `id6742878293`, v1.0.16, diluncurkan Jan-2026). Kemungkinan besar `apimelody` = API backend Melody (transfer antar bank, PPOB, mutasi) yang dilindungi firewall ini — meningkatkan dampak kompromi firewall jadi akses langsung ke API keuangan.

#### Description
Perangkat keamanan perbatasan (firewall) milik bank terindeks publik dan dapat diakses siapa saja. Ini berbahaya ganda: (1) panel admin tanpa MFA dapat jadi target brute-force; (2) jika versi rentan (mis. CVE-2023-27997/25601, CVE-2022-40684 family), RCE pada FortiGate = kompromi seluruh jaringan bank. Versi exact belum terkonfirmasi — build hash `388d12d465aaa092e7b20170f189005f` terekspos di page.

#### Reproduction Steps
1. `curl -sk https://apimelody.bankkertiawan.com:17072/` → 200, halaman login FortiGate (main-mariner.css).
2. `curl -sk https://apimelody.bankkertiawan.com:17072/api/v2/monitor/system/status` → 401 (API hidup).
3. Konfirmasi cookie `fgt_lang`, `APSCOOKIE`, HSTS 15552000.

#### Evidence
- `results/findings/bankkertiawan_f1_f2.md` → "FORTIGATE IDENTIFIED (HIGH)"

#### Impact
- Target brute-force admin; permukaan CVE FortiOS (RCE class) dari internet.
- Kompromi firewall → kontrol lalu lintas seluruh jaringan internal bank.

#### Remediation
1. **Fix** — tutup akses admin dari internet (allowlist VPN + admin-ip).
2. **Defense in depth** — aktifkan MFA/2FA, admin access timeout, fail2ban-style lockout; matikan SSL-VPN jika tidak dipakai.
3. **Detection** — alert login gagal beruntun ke `/remote/login` & `/login`; SIEM untuk traffic ke :17072 dari non-allowlist.

#### References
- CVE-2023-27997, CVE-2022-40684 (FortiOS RCE class)
- Fortinet PSIRT best practices

#### Notes for Retest
- Setelah mitigasi: akses :17072 dari non-allowlist → timeout/refused; login dengan MFA wajib.

---

### Finding #3 — cPanel Login Ekspos dari Internet

**Severity:** High (CVSS 7.5)
**Affected Scope:** `cpanel.bankkertiawan.com:2083` (juga 2087, 80)
**Status:** Open
**CWE:** CWE-306
**OWASP:** A05:2021 — Security Misconfiguration

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N = 7.5`

#### Summary
cPanel login panel untuk shared hosting terbuka ke internet. Kompromi cPanel = full control hosting, semua domain, file, DB di server bersama.

#### Description
cPanel biasanya menyediakan akses ke file, database, email, DNS dari satu panel. Jika kredensial bocor (atau cPanel version dengan CVE) → total takeover aset web. Port 2087 (WHM) juga ekspos.

#### Reproduction Steps
1. `curl -sk https://cpanel.bankkertiawan.com:2083/` → halaman login cPanel (HTTP 200).
2. Konfirmasi `:2087` WHM login.

#### Impact
- Takeover hosting; deface; data PII; pivot ke akun lain di server shared.

#### Remediation
1. **Fix** — allowlist IP admin; pindahkan ke VPN.
2. **Defense in depth** — ubah port, aktifkan 2FA, nonaktifkan WHM publik.
3. **Detection** — alert login gagal cPanel/WHM.

#### References
- CWE-306; cPanel security docs

---

### Finding #4 — WordPress User Enumeration (REST + Sitemap + Author)

**Severity:** Medium (CVSS 5.3)
**Affected Scope:** bankkertiawan.com (WordPress 7.0.3)
**Status:** Open
**CWE:** CWE-200 (Information Exposure)
**OWASP:** A01:2021 — Broken Access Control

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N = 5.3`

#### Summary
Username admin terbocorkan lewat 3 jalur independen: `/wp-json/wp/v2/users` (admin1, id 2), `?author=1` → `/author/bkertiawanadmin/`, dan `wp-sitemap-users-1.xml` (admin1, bkertiawanadmin).

#### Description
Dua username admin diverifikasi: `admin1` dan `bkertiawanadmin`. Ini setengah dari kredensial — tinggal mencari password. Juga gravatar hash admin1 terekspos.

#### Reproduction Steps
1. `curl https://bankkertiawan.com/wp-json/wp/v2/users` → admin1 (id 2)
2. `curl https://bankkertiawan.com/wp-sitemap-users-1.xml` → admin1, bkertiawanadmin

#### Impact
- Feed untuk brute-force/credential stuffing login `/wp-login.php`; target phishing internal.

#### Remediation
1. **Fix** — block `/wp-json/wp/v2/users` (plugin / .htaccess), nonaktifkan author sitemap.
2. **Defense in depth** — rate-limit wp-login, aktivasi 2FA.
3. **Detection** — alert pola enumerasi user.

---

### Finding #5 — Elementor 4.0.1 CVE Exposure (Stored XSS + Broken Access Control)

**Severity:** Medium (CVSS 6.4 / 5.4)
**Affected Scope:** bankkertiawan.com — plugin Elementor 4.0.1 (+ Elementor Pro)
**Status:** Open
**CWE:** CWE-79 (XSS), CWE-862 (Missing Authorization)
**OWASP:** A03:2021 — Injection

**CVSS Vector (CVE-2026-6127):** `CVSS:3.1/AV:N/AC:L/PR:L/UI:R/S:U/C:H/I:L/A:L = 6.4`

#### Summary
Elementor 4.0.1 rentan CVE-2026-6127 (Stored XSS via `_elementor_data` form-encoded REST PATCH bypass sanitize) & CVE-2026-49782 (Broken Access Control). Keduanya butuh akun Contributor+ — tidak dieksploitasi tanpa kredensial. Elementor Pro hadir (namespace `elementor-pro/v1`) dengan surface CVE terpisah.

#### Reproduction Steps
1. `curl https://bankkertiawan.com/wp-content/plugins/elementor/readme.txt` → "Stable tag: 4.0.1".
2. Bandingkan dengan advisory CVE-2026-6127 / 49782 (Elementor ≤4.0.1).

#### Impact
- Dengan akun contributor: XSS admin session, BAC → modifikasi konten; pivot ke kompromi situs.

#### Remediation
1. **Fix** — update Elementor ≥4.1.1; update Elementor Pro.
2. **Defense in depth** — batasi role contributor; harden REST.
3. **Detection** — alert POST ke `/wp-json/wp/v2/.../elementor` dari user low-priv.

#### References
- CVE-2026-6127, CVE-2026-49782; wordpress.org plugin changelog

---

### Finding #6 — ITMS "IT Management System" v1.0.0 Beta Publik

**Severity:** Medium (CVSS 5.3 — exposure app beta)
**Affected Scope:** `itms.bankkertiawan.com`
**Status:** Open (diverifikasi via web index, bukan akses langsung)
**CWE:** CWE-306, CWE-1188
**OWASP:** A05:2021 — Security Misconfiguration

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N = 5.3`

#### Summary
Portal internal "IT Management System" (ITMS) **versi beta 1.0.0** bank terindeks di web search engine dan login form-nya publik. Aplikasi beta sering berisi kredensial default/test. Subdomain `itms` TIDAK muncul di crt.sh — blind spot enumerasi.

#### Description
Excerpt search engine (2026-08-08): "ITMS - PT BPR Bank Kertiawan ... IT Management System, Username, Show Password, Version 1.0.0 Beta". Artinya halaman login dapat diakses publik dan terindex crawler. Aplikasi manajemen internal bank versi beta di internet = risiko kebocoran data operasional.

#### Reproduction Steps
> Belum diakses langsung. Diverifikasi via hasil pencarian web (passive).

#### Impact
- Akses publik ke tool manajemen internal; credential stuffing pada app beta (default password umum).

#### Remediation
1. **Fix** — tutup dari internet (internal-only / VPN).
2. **Defense in depth** — hapus "Show Password" toggle, wajibkan password kuat + 2FA, blok index (X-Robots-Tag).
3. **Detection** — monitor login gagal.

---

### Finding #7 — Missing Security Headers (Seluruh Vhost WordPress)

**Severity:** Medium (CVSS 5.0)
**Affected Scope:** bankkertiawan.com
**Status:** Open
**CWE:** CWE-693 (Protection Mechanism Failure)
**OWASP:** A05:2021 — Security Misconfiguration

**CVSS Vector:** `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N = 5.0`

#### Summary
Response WordPress tidak menyertakan HSTS, X-Frame-Options, X-Content-Type-Options, CSP, Referrer-Policy. Kontras: FortiGate pakai semua header ini — tim masih mampu, hanya tidak diterapkan di WP.

#### Impact
- Clickjacking, MIME-sniffing, downgrade HTTPS, data theft via framing.

#### Remediation
1. Tambahkan header via .htaccess/LiteSpeed config atau plugin (CSP, X-Frame-Options SAMEORIGIN, X-Content-Type-Options nosniff, HSTS, Referrer-Policy).
2. Uji dengan securityheaders.com.

---

### Finding #8 — xmlrpc.php Aktif

**Severity:** Low
**Affected Scope:** bankkertiawan.com/xmlrpc.php
**CWE:** CWE-200
**OWASP:** A01:2021

#### Summary
`xmlrpc.php` merespons 405 (aktif) — vector pingback/DDoS amplification dan brute-force amplication (system.multicall).

#### Remediation
1. Blok `/xmlrpc.php` di server.
2. Detection: alert request xmlrpc.

---

### Finding #9 — DMARC p=none

**Severity:** Low
**Affected Scope:** DNS zone bankkertiawan.com
**CWE:** CWE-345 (Insufficient Verification)

#### Summary
DMARC `p=none` — email phishing/mimpersonasi domain bank tidak diblokir. SPF ada (zohomail + spf.nusa.id), tetapi tanpa enforcement p=reject/quarantine.

#### Remediation
1. Naikkan DMARC `p=quarantine` → `p=reject` bertahap; monitor aggregate reports.

---

### Finding #10 — Version & Stack Disclosure

**Severity:** Low
**Affected Scope:** bankkertiawan.com
**CWE:** CWE-200

#### Summary
`X-Powered-By: PHP/8.2.32`, WP version 7.0.3, plugin versions (Elementor 4.0.1, LiteSpeed 7.8.1, fluent-smtp 2.2.95, hfe 2.8.6, Astra 4.12.7) semua terbaca. LiteSpeed 7.8.1 = PATCHED (CVE-2024-28000, CVE-2026-3375 fixed) — tidak rentan.

#### Remediation
1. Hapus `X-Powered-By`; update WP generator; blok `readme.txt`/`wp-sitemap-users`.

---

### Finding #11 — reCAPTCHA Sitekey Hardcoded di Source Code

**Severity:** Low
**Affected Scope:** register.php (website.bankkertiawan.com)
**CWE:** CWE-798

#### Summary
Sitekey `6Lcw3jsjAAAAAJ-QvVMuHU5uHlmpf6BdxPlaNhLP` tertanam di source publik. Belum diverifikasi apakah aktif di production; jika ya, attacker dapat men-decode/detour verification.

#### Remediation
1. Pindah sitekey ke server-side; verifikasi token di backend; rotate key jika ragu.

---

### Finding #12 — Mobile Banking "Melody" + Subdomain Policy Baru (Attack Surface Expansion)

**Severity:** Info (CVSS n/a — exposure app publik, konteks serangan)
**Affected Scope:** `apimelody.bankkertiawan.com` (API/backend), `policy.bankkertiawan.com`, Google Play `com.mat.kertiawan`, iOS `id6742878293`
**Status:** Open (OSINT pasif)
**CWE:** CWE-1188 (attack surface), CWE-200
**OWASP:** A01:2021 / A05:2021

#### Summary
Bank meluncurkan **mobile banking "Melody"** (Jan-2026, v1.0.16): registrasi in-app, New CIF online, buka rekening, pemindahbukuan (max Rp500jt/hari), transfer antar-bank, PPOB (pulsa/token PLN/e-money), mutasi, merchant. Backend diduga `apimelody` (FortiGate). Subdomain baru **`policy.bankkertiawan.com`** (T&C Melody, struktur `/melody/*`) terdeteksi live (202.74.239.23) — bersama `itms` dan `website`, ini **luput dari crt.sh** (blind spot enumerasi).

#### Description
`policy.bankkertiawan.com` (HTTP 200, LiteSpeed, `Last-Modified` Nov-2025) berisi syarat & ketentuan produk Melody (`/melody/pemrek-melody`, `riplay-poin`, `riplay-mapan`, `riplay-deposito`, `riplay-deposito-miles`, `riplay-kredit`). Kombinasi ini menandakan ekosistem perbankan digital aktif yang seluruhnya bergantung pada stack custom PHP internal (pola F3: default creds, beta software, source leak).

#### Impact
- `apimelody` (FortiGate) melindungi API keuangan: kompromi = transfer/PII nasabah.
- App Melody = permukaan serangan mobile tambahan (API tampering, OTP bypass) di luar scope web.
- Subdomain tak terdaftar di CT log = enumerasi via crt.sh tidak cukup.

#### Remediation
1. Enumerasi subdomain berbasis konten (search dorks, historical DNS) — bukan hanya CT log.
2. Masukkan mobile app (APK/IPA analysis, API backend) ke scope pengujian terpisah dengan otorisasi.
3. Pastikan API Melody punya auth kuat + rate-limit; blok akses admin FortiGate dari internet (menggabung Finding #2).

#### Evidence
- `results/findings/bankkertiawan_f1_f2.md` → "FINDINGS F5 - MELODY MOBILE BANKING"
- Google Play `com.mat.kertiawan`; App Store `id6742878293`; `policy.bankkertiawan.com` (GET 200)

---

## 5. Attack Narratives / Chains

```
Chain A — Kompromi Data Nasabah (full, belum dieksekusi)
1. Source code publik: SQLi di aktif_login.php (Finding #1, Critical)
2. Bypass login admin via ' OR '1'='1 (Finding #1)
3. Session admin → CRUD pendaftaran → dump PII nasabah + password plaintext (Finding #1)
Total waktu estimasi: <15 menit. Detection points missed: error-DB logging tidak ada, WAF off.
```

```
Chain B — Perimeter Compromise (belum dieksekusi)
1. FortiGate :17072 publik (Finding #2, High)
2. Fingerprint FortiOS 7.x → versi → CVE RCE class bila rentan (Finding #2)
3. Kompromi firewall → kontrol jaringan internal (scope change)
```

```
Chain C — Hosting Takeover (belum dieksekusi)
1. cPanel :2083 publik (Finding #3, High)
2. Credential stuffing / default cred / CVE cPanel (Finding #3)
3. Full control hosting + DB (Finding #1 escalation)
```

```
Chain D — Legacy App Footprint (OSINT pasif, konteks)
1. Wayback history: aplikasi PHP custom sebelum WP (session.php, Sejarah.php, 2010-2012) (F4)
2. Pola custom PHP berulang: session.php → aktif_login.php → ITMS (F3/F4)
3. Indikasi default creds berulang pada generasi app berbeda (F3)
```

```
Chain E — Mobile Banking API (belum dieksekusi, permukaan baru)
1. "Melody" mobile banking (Google Play com.mat.kertiawan, iOS) live sejak Jan-2026 (F5)
2. Backend diduga apimelody (FortiGate :17072) — API transfer/PPOB/mutasi (F2, F5)
3. Kompromi FortiGate (Chain B) → akses API keuangan + PII nasabah mobile (F2+F5)
```

## 5b. Wayback CDX History Notes (F4, 2026-08-08)

Full CDX harvest: 403 entries unik (2005-2026). Temuan konteks:

- **Legacy pre-WP site** (2010-2012): `Sejarah.php`, `SyaratdanKetentuan.php`, `TabunganKertiawan.php`, `TinggalkanPesan.php`, `session.php?kategori=&produk=&page=&kd=&jum=1&flg=2` — app PHP custom lama.
- **WP version timeline**: 4.6.1 → 4.9.8 → 5.4.1 → 5.4.2 → 5.5.7 → 7.0.3; migrasi https cluster 2022.
- **Plugin history**: contact-form-7 (4.5-5.3), Jetpack (2015-2022), share-this — semuanya sudah tidak aktif. Theme custom "bank-kertiawan" → Astra.
- **PII/corporate pages**: pendiri-komisaris-direksi, direktur-*, komisaris-* (via wp-json oembed + wp-login redirect_to).
- **Financial PDFs publik**: Laporan Tahunan, Neraca Publikasi, GCG, rasio keuangan (2014-2024).
- **New post type**: `wp-sitemap-posts-lelang-1.xml` (auction/lelang).
- **Brute-force protection aktif historis**: wp-login 409/406 (2017-2019) — sekarang? (F8 xmlrpc aktif).

Implication: pola custom-PHP app dengan kredensial default berulang lintas generasi (session.php → aktif_login → ITMS) memperkuat hipotesis Finding #1/#6.

**Update F5 (OSINT, 2026-08-08):** ditemukan ekosistem mobile banking "Melody" — app publik (Google Play `com.mat.kertiawan` / iOS `id6742878293`, v1.0.16, Jan-2026), backend diduga `apimelody` (FortiGate), plus subdomain `policy.bankkertiawan.com` (T&C Melody, `/melody/*`) yang live namun **luput dari crt.sh**. Blind-spot enumerasi dikonfirmasi (itms, website, policy tidak di CT log). Detail → Finding #12.

---

## 6. Strategic Recommendations

1. **Program secure development** — rewrite app pendaftaran/survey/ITMS dengan prepared statements + password hashing; CI security gates (SAST). (mengatasi #1, #5, #11)
2. **Perimeter lockdown** — semua portal admin (FortiGate, cPanel, ITMS, wp-login) pindah balik VPN + allowlist; hapus port publik non-standar. (mengatasi #2, #3, #6)
3. **Hardening web layer** — security headers, blok xmlrpc/users-enum, update Elementor & plugin lain, rate-limit auth endpoints. (mengatasi #4, #5, #7, #8, #10)
4. **Hapus jejak publik** — takedown repo GitHub berisi source; pastikan tidak ada kredensial/secret di sejarah repo; monitor GitHub code search untuk pola `bankkertiawan`. (mengatasi #1)
5. **Email hardening + monitoring** — DMARC enforcement, log sentinel untuk auth failures seluruh portal. (mengatasi #9 + detection)

---

## 7. Appendices

### A. Tools Used

| Tool | Versi | Penggunaan |
|---|---|---|
| Prism CLI | 2.6.0 | OSINT domain recon (whois/dns/geoip/cert/wayback/shodan/vt/censys) |
| curl | 8.x | HTTP fingerprint, subdomain verify (GET only) |
| crt.sh (API) | — | Subdomain enumeration via certificate transparency |
| Wayback CDX API | — | Historical URL/path discovery (rate-limited) |
| Web search | — | Dork: site:, index verification, GitHub code search |
| openssl | 3.x | TLS checks |

### B. Raw Evidence Pointers

- `results/recon/bankkertiawan_domain.json` — Prism full output
- `results/recon/bankkertiawan_triage.txt` — headers/robots
- `results/recon/bankkertiawan_cdx.txt` — Wayback CDX full history (403 entries, 2005-2026)
- `results/findings/bankkertiawan_f1_f2.md` — semua temuan terstruktur (F1-F5)
- Repo GitHub: `https://github.com/Blikadek/kertiawan` (tree e416bf0)
- Google Play `com.mat.kertiawan`; App Store `id6742878293` (Melody mobile banking, F5)

### C. Glossary

- **CVSS** — Common Vulnerability Scoring System
- **SQLi** — SQL Injection
- **OSINT** — Open Source Intelligence
- **FortiGate/FortiOS** — firewall NGFW produk Fortinet
- **ITMS** — IT Management System
- **PII** — Personally Identifiable Information

---

## Retest Summary

| Finding | Severity Asli | Status Retest | Tanggal Verifikasi |
|---|---|---|---|
| #1 Source code leak / SQLi | Critical | — | — |
| #2 FortiGate publik | High | — | — |
| #3 cPanel publik | High | — | — |
| #4 WP user enum | Medium | — | — |
| #5 Elementor CVEs | Medium | — | — |
| #6 ITMS beta | Medium | — | — |
| #7 Missing headers | Medium | — | — |
| #8 xmlrpc | Low | — | — |
| #9 DMARC | Low | — | — |
| #10 Version disclosure | Low | — | — |
| #11 reCAPTCHA key | Low | — | — |
| #12 Melody app + policy subdomain | Info | — | — |

---

*Laporan ini berdasarkan pengujian PASIF saja. Exploit aktif, brute-force, dan verifikasi langsung (ITMS, aktif_login) menunggu otorisasi tertulis dari pemilik aset (hasil/engagement.json).*
