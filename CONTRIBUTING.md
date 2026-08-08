# Contributing — DMLab CEH

Terima kasih sudah berkontribusi. Project ini workspace pentest/OSINT yang **hanya untuk pengujian keamanan yang sah** (izin tertulis, lab, CTF, bug bounty resmi).

## Siapa Bisa Berkontribusi?

Semua orang — red/white/blue team, pembelajar CEH, developer tooling. Prasyarat: hormati etika & scope.

## Jenis Kontribusi

| Jenis | Lokasi |
|---|---|
| Fix dokumen (typo, path, instruksi) | `README.md`, `WORKFLOW.md`, `AGENTS.md`, dll |
| Script pendukung baru | `tools/src/` |
| Template laporan | `template/` |
| Manajemen/tata kelola | `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md`, `PROJECT-MANAGEMENT.md` |
| Skill baru / perbaikan skill | **Bukan di repo ini** — skill bersumber dari `source/Claude-Red` (upstream). Perbaikan skill diajukan ke upstream, lalu disinkronkan ke sini. |

## Alur

1. **Fork & clone** repo, buat branch: `git checkout -b fix/<deskripsi>` atau `feat/<deskripsi>`.
2. **Ubah** hanya SOURCE — jangan sentuh kondisi terinstall (`report/`, `results/`, `source/`, `.agents/`, `graphify-out/`, `ceh/`). Jangan ubah isi gitlink `tools/prism` / `tools/spiderfoot` (kontennya berasal dari repo upstream, bukan project ini).
3. **Verifikasi**:
   - Path & perintah di docs benar (jalankan jika memungkinkan).
   - Script bash lolos `bash -n`.
   - Skill byte-identical dengan upstream (jika menyentuh sinkronisasi skill).
4. **Commit** dengan pesan jelas (Conventional Commits disarankan), mis. `docs: fix prism path di WORKFLOW`.
5. **Push & buat PR** ke `origin/master`.

## Aturan Non-Negosiasi

- **No authz → no execution.** Tidak ada konten yang mendorong aktivitas ilegal/tanpa izin.
- **No target data.** Jangan commit `report/` / `results/` / data target apa pun.
- **Jangan ubah skill langsung di repo ini** — sinkronisasi dari upstream, bukan fork manual.
- **Tidak ada secret.** Jangan commit `.env`, key, credential.

## Checklist PR

- [ ] Hanya menyentuh source (`skills/`, `tools/src/`, `template/`, docs).
- [ ] Path tool benar (`tools/prism`, `tools/spiderfoot`, `tools/src/...`).
- [ ] Tidak ada perubahan pada `.gitignore` yang membuat artifact dev ke-track.
- [ ] CHANGELOG di-update (bagian `[Unreleased]`).
- [ ] Bahasa konsisten (docs: Indonesia; kode/commit: Inggris atau Indonesia).
