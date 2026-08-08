# Onboarding & Environment Setup Guide

Welcome to **DMLab CEH**. This guide covers the complete step-by-step setup process across **Windows, Linux, and macOS**. 

The framework is **agent-agnostic**: all 58 offensive security skills use the standardized `SKILL.md` format (YAML frontmatter with `name` and `description`), natively supported by **Claude Code, OpenCode, Cursor, Codex**, and other AI coding assistants.

---

## 1. Prerequisites

- **Python 3.8+** (recommended: Python 3.10, 3.11, or 3.12)
- **Git** (with submodule support)
- **C/C++ Build Tools** (optional, for native Python packages if wheels are not pre-built)
- An AI coding agent or terminal environment of your choice

---

## 2. Clone Repository & Submodules

Clone the repository recursively to pull all integrated tools ([Prism](../tools/prism) and [SpiderFoot](../tools/spiderfoot)):

```bash
git clone --recurse-submodules https://github.com/digimetalab/dmlab.ceh.git
cd dmlab.ceh
```

> [!NOTE]
> If you cloned without `--recurse-submodules`, initialize them anytime using:
> ```bash
> git submodule update --init --recursive
> ```

---

## 3. Local Virtual Environment (`.venv`) & Unified Dependencies

Create a local virtual environment to ensure complete dependency isolation:

### Linux / macOS
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### Windows (PowerShell)
```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install -r requirements.txt
```

### Windows (Command Prompt)
```cmd
python -m venv .venv
.venv\Scripts\activate.bat
pip install -r requirements.txt
```

---

## 4. Install 58 Offensive Skills to Local Workspace

By default, the installer copies all 58 standardized skills into `.agents/skills/` **locally within the project directory** (gitignored), ensuring that your global machine environment remains clean.

```bash
# Universal Python Installer (All Operating Systems):
python tools/src/install_skills.py

# Optional: Preview the installation plan
python tools/src/install_skills.py --dry-run

# Optional: Install only a specific subset of skills
python tools/src/install_skills.py --only offensive-sqli offensive-xss offensive-jwt

# Optional: List all recognized agent target directories
python tools/src/install_skills.py --list
```

### Optional: Global Agent Installation
If you want to install skills into your global agent configuration (e.g., `~/.claude/skills` or `~/.config/opencode/skills`):

```bash
python tools/src/install_skills.py --global
python tools/src/install_skills.py --agent opencode --global
```

---

## 5. Verification & Health Check

Verify that the local environment and tools are properly configured:

```bash
# 1. Verify that the 58 skills exist in the local workspace:
# Linux/macOS:
ls .agents/skills | wc -l
# Windows PowerShell:
(Get-ChildItem .agents/skills).Count

# 2. Verify Python version & environment:
python --version

# 3. Test Prism OSINT scanner CLI (dry-run/help):
cd tools/prism
python cli.py --help

# 4. Test SpiderFoot scanner:
cd ../spiderfoot
python sf.py -M
```

---

## 6. Golden Rules & Engagement Hygiene

1. **Local Isolation:** Never commit runtime artifacts (`report/`, `results/`, `.venv/`, `.agents/`) to public git branches.
2. **Evidence Integrity:** Retain full, reproducible HTTP request/response payloads for all findings.