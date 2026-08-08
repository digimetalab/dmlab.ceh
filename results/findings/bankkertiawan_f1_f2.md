# Findings - Fase 1&2 (Recon + Fast Triage)

Target: https://bankkertiawan.com - PT BPR Bank Kertiawan (BPR kecil, Indonesia)
Date: 2026-08-08
Authorization: Tertulis (user-confirmed)

## INFRASTRUCTURE
- IP: 202.74.239.23 shared hosting (sharedserver103.extremhost.net), AS131775 PT. Jupiter Jala Arta, Jakarta
- Web server: LiteSpeed, HTTP/2, HTTP/3 (alt-svc h3)
- Stack: WordPress + PHP 8.2.32 + jQuery + Elementor (rest meta menunjukkan elementor_introduction)
- NS: Cloudflare (chris/mckenzie). No proxy (A record langsung ke 202.74.239.23)
- Mail: Zoho (mx 10/20/50), SPF include:zohomail.com + include:spf.nusa.id, DMARC p=none
- Wildcard cert (crt.sh), DigiCert + Google Trust Services issuers

## SUBDOMAINS - LIVE
| subdomain | status |
|---|---|
| bankkertiawan.com (root) | 200, WordPress |
| esurvei | 200, app survey custom, cookie sec_session_id (secure; HttpOnly) |
| cpanel | 2083/2087 cPanel login EXPOSED, 80 = default page |
| apimelody | 302 -> https://apimelody:17072/login - CUSTOM LOGIN PORTAL |

## SUBDOMAINS - NXDOMAIN (dead, sejarah crt.sh)
corebanking, ibank, sandbox, scoring, mcl, ez, undangan, webmail, mail, secure(103.178.16.242 down)
- Note: corebanking/ibank sudah tidak ada A record - bekas internet banking/core banking system

## FINDINGS F2
- [MED-HIGH] REST API user enumeration: /wp-json/wp/v2/users -> admin1 (id 2)
- [MED] author enumeration: ?author=1 -> /author/bkertiawanadmin/ (username leak)
- [MED] Users exposed in sitemap: wp-sitemap-users-1.xml -> admin1, bkertiawanadmin
- [LOW-MED] readme.html accessible (200, 7406B) - WP version disclosure potential
- [LOW-MED] xmlrpc.php active (405) - pingback/bruteforce vector
- [MED] Missing security headers: HSTS, X-Frame-Options, X-Content-Type-Options, CSP, Referrer-Policy
- [LOW] X-Powered-By: PHP/8.2.32 exposed
- [LOW-MED] DMARC p=none
- [INFO] LiteSpeed cache hit header, ETag present

## USERS (confirmed)
- admin1 (id 2) - gravatar hash 1c103c71afe6f387b6730c49d9c41708e9a2dbe3ea4b3e938ad1afe5ca90f484
- bkertiawanadmin

## SERVICES TO DEEP-DIVE
1. apimelody:17072 - **Fortinet FortiOS admin portal** (firewall/border device) EXPOSED on non-standard port
2. cpanel:2083 - control panel login
3. esurvei - custom survey app
4. WP admin: admin1 / bkertiawanadmin usernames

## FORTIGATE IDENTIFIED (HIGH)- apimelody.bankkertiawan.com:17072 = FortiGate/FortiOS admin login
- Fingerprint: fgt_lang, ftnt-fortinet-grid icons, VDOM_/CENTRAL_MGMT_OVERRIDE_/APSCOOKIE cookies, main-mariner.css (FortiOS 7.x theme), X-Frame-Options SAMEORIGIN, HSTS 15552000, CSP frame-ancestors
- Version exact: NOT exposed (build hash 388d12d465aaa092e7b20170f189005f)
- API endpoints /api/v2/monitor/* return 401 (unauth = access denied, expected)
- /remote/login, /remote/update 401 - SSL-VPN portal endpoints present
- Risk: admin panel of security appliance reachable from internet. Brute-force target. Version-dependent CVEs unconfirmed until version known.
- Security headers present here (contrast with WP): HSTS, XFO, CSP frame-ancestors

## ESURVEI APP (custom PHP)
- URL: https://esurvei.bankkertiawan.com - "ESurvey - PT. BPR Bank Kertiawan"
- Login form POST -> app/models/login.php, SHA512 client-side hash (formhash via sha512.js)
- Cookie sec_session_id (secure; HttpOnly) - signature of "Secure PHP Login" tutorial script
- login.php returns "Invalid Request" on direct GET/POST (auth logic present, need valid session/params)
- README.md accessible (200) - reveals theme "Portal" free Bootstrap 5 admin template by 3rdwavemedia v3.0
- All other .php/.env/db.sql paths = 10987 bytes fallback to index (NOT real files) - no LFI/confusion confirmed
- Pages: index, survey (91KB), #login
- WhatsApp: 6285119327809

## WORDPRESS VERSION + PLUGINS (confirmed)
- WP version: 7.0.3 (generator meta). Note: plugins "Tested up to: 6.9" - WP core ahead of plugin testing
- Elementor 4.0.1 (readme.txt 200, version disclosure)
- LiteSpeed Cache 7.8.1
- fluent-smtp 2.2.95
- header-footer-elementor (hfe) 2.8.6
- Astra theme 4.12.7
- Other plugins present: contentviews, ea11y (wp-accessibility), akismet, nps-survey
- Elementor Pro present (elementor-pro/v1 namespace) - pro version known CVE surface
- Themes endpoint /wp-json/wp/v2/themes = 401 (blocked)

## CVE ANALYSIS (as of 2026-08-08)
- LiteSpeed Cache 7.8.1: NOT vulnerable (CVE-2024-28000 fixed 6.4; CVE-2026-3375 fixed 7.8). PATCHED
- Elementor 4.0.1: VULNERABLE
  - CVE-2026-6127 (CVSS 6.4): Stored XSS via _elementor_data, form-encoded REST PATCH bypasses sanitize. Needs Contributor+. Elementor references tag 4.0.1 directly
  - CVE-2026-49782 (CVSS 5.4, Low): Broken Access Control. Needs Contributor. Patched 4.1.1
  - Note: both need low-priv account - impact limited without credential
- Elementor Pro present (version unconfirmed) - separate CVE surface (CVE-2023-35050 etc.)

## AUTH-USERS PATH (need credentials)
- WP: admin1, bkertiawanadmin (enum'd). No brute force attempted (scope decision)
- esurvei: custom login (SHA512 hash), peredur.net script pattern
- FortiGate admin: apimelody:17072
- cPanel: cpanel:2083

## FINDINGS F3 - OSINT SOURCE CODE LEAK (github.com/Blikadek/kertiawan)
Repo publik berisi source code app pendaftaran nasabah "Kertiawan" (AdminLTE 3 template) - aktif_login.php terindeks Google di website.bankkertiawan.com/aktif_login.php. Tidak ada bukti komit berisi kredensial .env, tapi source code = blueprint exploit.

- [HIGH] SQL Injection (blind/auth): aktif_login.php - `SELECT * FROM user WHERE username='$username' AND password='$password'` tanpa escaping/param. Login by-pass ' OR '1'='1'. Plaintext password check.
- [HIGH] SQL Injection: register_act.php - INSERT dengan interpolasi $username/$password tanpa sanitasi. Password disimpan PLAINTEXT.
- [HIGH] SQL Injection: admin/pendaftaran/update_act.php (UPDATE, password PLAINTEXT), tambah_act.php (INSERT), dan (inferred) edit/hapus/detail - semua interpolasi langsung.
- [HIGH] Default DB creds di source: koneksi.php = mysqli_connect("localhost","root","","db_daftar") - dev default, menandakan pola admin "root" tanpa password pada deployment internal. db name = db_daftar.
- [MED-HIGH] Session fixation / weak auth: aktif_login.php mengecek role (1=Admin, 3=Nasabah) via mysqli_fetch_array, redirect admin -> /admin/, nasabah -> blank-page.php. No password hashing.
- [MED] reCAPTCHA sitekey hardcoded: 6Lcw3jsjAAAAAJ-QvVMuHU5uHlmpf6BdxPlaNhLP (register.php) - key mungkin valid, dapat di-test (tanpa mengirim).
- [INFO] Blank redirect: register_act.php header() ke https://bankkertiawan.com/wp (bukan /wp/) - typo, potensi open redirect/berantakan.
- [INFO] Stack: PHP mysqli, AdminLTE 3, Bootstrap 4, jQuery; file map: login.php, register.php, blank-page.php, admin/{header,footer,index,logout}.php, admin/pendaftaran/{index,detail,edit,hapus,tambah,tambah_act,update_act}.php
- [INFO] README.md repo kosong; owner "Blikadek" (Kadek pattern - Bali, sesuai alamat Jl. Ida Bagus Mantra).
- Correlation: Google cache/index menampilkan website.bankkertiawan.com/aktif_login.php + itms.bankkertiawan.com (ITMS = IT Management System) - konfirmasi kehadiran subdomain/asset via dork.

## ITMS PORTAL VERIFIED (OSINT via websearch, NOT touched directly)
- URL terindeks: https://itms.bankkertiawan.com/ -> "ITMS - PT BPR Bank Kertiawan"
- Fingerprint (dari index snippet): "IT Management System", login form (Username + Show Password toggle), "Version 1.0.0 Beta", copyright "IT PT BPR Bank Kertiawan"
- Status: BETA software, login portal admin-class, terindeks publik = attack surface yang tidak terdaftar di crt.sh (subdomain lama/different issuer)
- website.bankkertiawan.com/aktif_login.php juga terindeks (Login "Kertiawan") - konsisten dengan repo GitHub source code
- Note: subdomain "website" dan "itms" TIDAK muncul di hasil crt.sh scan - blind spot enumerasi (crt.sh timeout)

Exploit path (future, NEED auth/consent): SQLi login by-pass -> admin session -> CRUD pendaftaran (data PII nasabah: nama, no_telp, tempat/tgl lahir, gender, alamat, email, username, password). Impact: data PII + creds plaintext + full DB.

## FINDINGS F4 - WAYBACK CDX FULL HISTORY (2026-08-08, 403 entries, cleaned)
Sumber: web.archive.org CDX, collapse=urlkey, 2005-2026. File: results/recon/bankkertiawan_cdx.txt

### Legacy pre-WordPress site (2010-2012, static PHP/Flash)
- Halaman PHP custom lama: Sejarah.php, SyaratdanKetentuan.php, TabunganKertiawan.php, TinggalkanPesan.php, session.php?kategori=&produk=&page=&kd=&jum=1&flg=2 (2010-05-13)
- transDropDown/ menu JS (2011), Scripts/swfobject_modified.js (Flash, 2013)
- => Ada aplikasi PHP custom SEBELUM WP. session.php menerima param kategori/produk/page - pola parameterized app lama

### WP Version Timeline (dari ver= wp-emoji-release)
- 4.6.1 -> 4.9.8 -> 5.4.1 -> 5.4.2 -> 5.5.7 -> (saat ini 7.0.3)
- Migration ke HTTPS terlihat 2022 (301 cluster Nov-2022: http->https)

### Plugin history
- contact-form-7: ver 4.5, 4.5.1, 5.0.1, 5.1.9, 5.3 (HISTORIC - tidak aktif di triage terbaru)
- Jetpack: aktif 2015-2022 (ver 4/5/8/9), sudah dihapus
- share-this: pernah aktif
- Theme custom "bank-kertiawan" (bootstrap-based) 2015-2019 -> diganti Astra
- Sekarang: Elementor, LiteSpeed, fluent-smtp, hfe, contentviews, ea11y (F2)

### PII / Corporate info pages (via wp-json oembed referrer)
- Halaman org: pendiri-komisaris-direksi, direktur-bpr-bank-kertiawan, komisaris-bpr-bank-kertiawan, pendiri-bpr-bank-kertiawan
- wp-login redirect_to minta target ke halaman-halaman tsb (user enum via redirect)

### Public financial reports (PDF, uploads/)
- Laporan Tahunan 2014/2015/2016, Neraca Publikasi Triwulan 2014-2019, Grafik Rasio Keuangan 2014-2016, Laporan GCG 2018, PENG-4 DSPS 2024, BUKLET APPK
- => Data finansial publik lengkap di web (tidak sensitif, tapi menambah konteks OSINT)

### New post type "lelang" (auction)
- wp-sitemap-posts-lelang-1.xml - post type lelang hadir (BPR lelang jaminan?). Belum diverifikasi aktif.

### Status codes menarik
- wp-login.php 409 (2019-05-18) + 406 (2017-06-02, redirect_to ke halaman direktur) - brute-force protection aktif kala itu
- robots.txt status "-" (404/no capture) 2021-03-08
- sitemap.xml 302 (2024-07-02) - redirect WP

### Correlate: session.php legacy + aktif_login.php + ITMS = pola custom PHP app di beberapa generasi; kredensial default berulang (F3).

## FINDINGS F5 - MELODY MOBILE BANKING + POLICY SUBDOMAIN (2026-08-08, OSINT pasif)
Sumber: web search, Google Play, App Store, DNS, GET pasif.

### Melody by Bank Kertiawan (mobile banking app)
- Android: com.mat.kertiawan (Google Play), iOS: id6742878293 (App Store). v1.0.16 (63.57MB, min Android OS 10)
- Fitur: registrasi akun in-app, New CIF (pembukaan data nasabah baru online), buka rekening, pemindahbukuan, transfer ke bank lain, PPOB (pulsa/token PLN/e-money DANA GoPay LinkAja OVO ShopeePay/BPJS/tagihan), mutasi rekening, merchant, Melody Poin
- Limit transaksi: pemindahbukuan max Rp500jt/hari, transfer bank lain max Rp30jt/hari
- Halaman resmi: bankkertiawan.com/melody-mobile/ - "Riplay Produk Online" -> https://policy.bankkertiawan.com/
- Diluncurkan resmi Jan 2026 (berita bankkertiawan.com)
- Implikasi: "apimelody" (FortiGate :17072) kemungkinan besar = API backend Melody mobile banking. Kompromi FortiGate = akses ke API keuangan yang melayani transfer antar bank.

### policy.bankkertiawan.com (subdomain BARU, tidak di crt.sh)
- DNS: A 202.74.239.23 (sama shared hosting) - LIVE
- HTTP 200, LiteSpeed, h3/h2. HTML = "Term & Condition Produk Melody"
- Struktur path: /melody/{pemrek-melody, riplay-poin, riplay-mapan, riplay-deposito, riplay-deposito-miles, riplay-kredit}
- Tercatat modified: Wed, 12 Nov 2025
- Implikasi: subdomain ke-2 (setelah itms) yang luput dari crt.sh - blind spot enumerasi diperkuat. Aset Melody = permukaan serangan baru (mobile banking API + policy page).

### Blind spot enumerasi (confirmed)
- Subdomain yang luput dari crt.sh (wildcard cert tapi tidak semua A record terindex): itms, policy, website
- => Rekomendasi: kombinasikan crt.sh + websearch dork (site:bankkertiawan.com) + historical DNS untuk enumerasi

### Correlate: apimelody + Melody app = surface mobile banking. ITMS + aktif_login + policy = kumpulan custom PHP app internal yang diekspos. Pola kredensial default + beta software + source leak (F3) berlaku lintas seluruh stack.
