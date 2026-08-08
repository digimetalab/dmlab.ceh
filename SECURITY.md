# Security Policy — DMLab CEH

## Konteks

Project ini adalah workspace **etical hacking / CEH** — skill & dokumentasi untuk **pengujian keamanan yang sah**. Kontennya sensitif tapi legal: metodologi, checklist, dan workflow yang dipakai pentester profesional terhadap target dengan izin.

## Pelaporan Kerentanan

Kode project (script `tools/src/`, installer, template, docs) bisa punya bug. Laporkan:

- **Email/issue:** laporkan via GitHub Issues dengan label `security`, atau hubungi maintainer repo.
- **Sertakan:** langkah reproduksi, dampak, versi, file & baris yang terpengaruh.
- **Jangan** mempublish PoC yang bisa menyakiti target riil di tempat umum.

## Scope Keamanan

Yang kami perhatikan:

1. **Script injection / path traversal** di `tools/src/*.sh` & installer `install_skills.sh` — mis. argumen user di-eval tanpa sanitasi.
2. **Hardcoded secrets** — pastikan tidak ada credential/key di source.
3. **Data target bocor** — pastikan `report/`, `results/` selalu gitignored dan tidak pernah di-commit.
4. **Skill menyesatkan** — skill yang mengajarkan aktivitas ilegal/tanpa izin akan di-review dan dihapus/diarahkan ke upstream.

## Responsible Disclosure

- Laporkan dulu ke maintainer sebelum publish.
- Beri waktu wajar (≥ 90 hari) untuk perbaikan sebelum disclosure publik.

## Penggunaan

Konten repo **hanya untuk pengujian resmi**: bug bounty dengan scope tertulis, kontrak pentest, lab milik sendiri, atau CTF. Penyalahgunaan di luar itu bukan tanggung jawab project ini.
