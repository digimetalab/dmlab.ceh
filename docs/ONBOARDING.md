# ONBOARDING — Mulai Pakai DMLab CEH

Panduan langkah-demi-langkah untuk setup workspace. Project ini **agnostic AI agent** — semua skill berformat `SKILL.md` standar (YAML frontmatter `name` + `description`) yang didukung **Claude Code, opencode, Cursor, Codex**, dan agent lain.

**Cross-platform**: Windows, Linux, macOS. Tidak bergantung pada WSL.

---

## 1. Prasyarat

- **Python 3.8+** (recommended 3.10+)
- **Git**
- **Docker** (untuk Prism web dashboard, opsional)
- Salah satu AI agent CLI (opencode, Claude Code, Cursor, Codex, dll.)

---

## 2. Clone Project

```bash
git clone https://github.com/digimetalab/dmlab.ceh.git
cd dmlab.ceh
```

---

## 3. Setup Virtualenv Lokal `.venv/` & Install Dependensi

Buat `.venv/` di root project dan pasang seluruh dependensi tools (Prism, SpiderFoot, reporting, dsb.):

```bash
# Linux / macOS:
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Windows (PowerShell):
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt

# Windows (Command Prompt):
python -m venv .venv
.venv\Scripts\activate.bat
pip install -r requirements.txt

# Verifikasi
python --version
```

---

## 4. Setup Skills ke Agent Lokal

Jalankan installer untuk memasang 58 skill ke `.agents/skills/` **lokal project**:

```bash
# Linux / macOS / WSL:
./tools/src/install_skills.sh --dry-run   # preview dulu
./tools/src/install_skills.sh             # install ke .agents/ project

# Windows (PowerShell):
.\tools\src\install_skills.ps1 -DryRun    # preview
.\tools\src\install_skills.ps1            # install
```

> **Catatan:** Default installer menyalin skill ke `.agents/skills/` **di dalam project ini** (lokal), bukan ke environment global. Orang yang clone project ini langsung mendapat skill siap pakai.

---

## 5. Submodule Tooling (Prism & SpiderFoot)

Pastikan submodule tools pendukung telah diinisialisasi:

```bash
# Tarik isi repo submodule (Prism & SpiderFoot)
git submodule update --init --recursive
```

---

## 6. Install Skills ke Agent (Detail)

### Default: Lokal project (`.agents/skills/`)

```bash
./tools/src/install_skills.sh                    # semua 58 skill
./tools/src/install_skills.sh --only offensive-sqli offensive-xss
./tools/src/install_skills.sh --dry-run
```

### Opsional: Global agent (explicit opt-in)

```bash
./tools/src/install_skills.sh --global           # ke ~/.claude/skills, ~/.config/opencode/skills, dll.
./tools/src/install_skills.sh --agent opencode   # filter agent tertentu
./tools/src/install_skills.sh --dir ~/.agents    # custom dir
```

### Agent yang didukung

| Agent | Skill dir default (global) |
|---|---|
| **opencode** | `~/.config/opencode/skills/` atau `~/.agents/skills/` |
| **Claude Code** | `~/.claude/skills/` |
| **Cursor** | `.cursor/skills/` (di project) |
| **Codex** | `.agents/` atau konfigurasi custom |

---

## 7. Struktur & Dokumen Wajib Dibaca

| Dokumen | Isi |
|---|---|
| [README.md](../README.md) | Gambaran project, model terinstall-vs-source, quick start |
| [AGENTS.md](AGENTS.md) | Arsitektur multi-agent pentest (Commander schema, skill mapping, escalation) |
| [WORKFLOW.md](WORKFLOW.md) | Alur pentest website 8 fase end-to-end |
| [MINDMAP.md](MINDMAP.md) | Peta coverage skill per attack surface |
| [PROJECT-MANAGEMENT.md](PROJECT-MANAGEMENT.md) | Manajemen engagement, task, blackboard |
| [IDEA.md](IDEA.md) | Visi & roadmap project |

---

## 8. Verifikasi Setup

```bash
# 1. Skills tersedia di skills/ (source, 58 folder)
ls skills/ | wc -l

# 2. Skills terinstall di .agents/ project (target)
ls .agents/skills/ | wc -l

# 3. Venv aktif & interpreter jalan
python --version

# 4. Prism scan kering (target Anda sendiri)
cd tools/prism
python cli.py scan example.com --type domain --json
```

---

## 9. Aturan Emas

1. **No authz → no execution.** Target harus punya izin tertulis.
2. Skill TIDAK diubah — `skills/` adalah source of truth.
3. Data target (`report/` & `results/`) tidak pernah di-commit.
4. `.venv/`, `.agents/`, `source/` = kondisi dev lokal — boleh ada di mesin, jangan di-commit (sudah gitignored).