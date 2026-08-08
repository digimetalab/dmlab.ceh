# Changelog

Semua perubahan signifikan di DMLab CEH dicatat di sini. Format mengikuti [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) dan project menggunakan [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- **Rebrand ke "DMLab CEH"** — README, IDEA, docs diperbarui jadi identitas baru.
- **Model "Terinstall vs Source"** — `.gitignore` memisahkan artifact dev lokal (`.agents/`, `.venv/`, `source/`, `report/`, `results/`, `graphify-out/`) dari source yang di-commit (`skills/`, `tools/src/`, `tools/prism`*, `tools/spiderfoot`*, `template/`, docs). *gitlink.
- **Cross-platform support** — Windows, Linux, macOS. Tidak bergantung pada WSL. Virtualenv lokal `.venv/`.
- **Skill library lengkap 58 skill** — pulihkan 3 skill yang hilang dari `source/Claude-Red` (upstream): `offensive-sqli`, `offensive-rce`, `offensive-file-upload`. Semua 58 skill byte-identical dengan upstream.
- **`tools/src/install_skills.sh`** — installer lintas-agent (default: install ke `.agents/` **lokal project**, bukan global). Opsi `--global` untuk opt-in ke agent global. Mendukung opencode, Claude Code, Cursor, Codex, dir kustom.
- **`MINDMAP.md`** — peta coverage 58 skill per attack surface + cross-reference OWASP/MITRE.
- **`ONBOARDING.md`** — panduan setup lengkap cross-platform (`.venv/`, gitlink, dependency, install skills lokal).
- **`PROJECT-MANAGEMENT.md`** — manajemen engagement, escalation rules, evidence hygiene, blackboard, git hygiene.
- **`CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md`** — dokumen tata kelola project.

### Changed
- **Struktur `tools/` dirapikan** — paket app (`prism`, `spiderfoot`) pindah langsung ke `tools/` dan di-track sebagai **gitlink** (submodule embedded). `tools/src/` khusus script pendukung one-off.
- **`WORKFLOW.md`** — path paket app diperbaiki (`tools/<tool>/`), perintah cross-platform pakai `.venv/`.
- **README & ONBOARDING** — total rewrite cross-platform, `.venv/`, default skill install lokal `.agents/`, hapus semua referensi WSL/`ceh/`.
- **`.gitignore`** — update: `.venv/`, hapus `ceh/`, tools/prism & tools/spiderfoot diganti jadi gitlink entries.

### Removed
- **WSL dependency** — semua perintah sekarang cross-platform (Windows, Linux, macOS).
- **`ceh/` venv** — dihapus (WSL-only), diganti `.venv/` cross-platform.
- **Data target di-untrack dari git** — `results/` (findings/recon bankkertiawan) di-`git rm --cached`.

## [Initial commit] — 2cce4ce

Restrukturisasi awal: template report ke `template/`, script ke `tools/src/`, 55 skill ke `skills/`, `.agents` dihapus dari track, docs path diperbarui.