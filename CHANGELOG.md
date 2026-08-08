# Changelog

All notable changes to the **DMLab CEH** project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and adheres to [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Added
- **Rebrand to "DMLab CEH"** — Comprehensive overhaul of repository identity, architecture docs, and technical specifications.
- **Universal Python Installer (`tools/src/install_skills.py`)** — 100% cross-platform installer natively supporting Windows, Linux, and macOS.
- **Unified Root `requirements.txt`** — Consolidated all dependencies for Prism, SpiderFoot, reporting utilities, and core frameworks into a single root manifest.
- **Documentation Directory Organization (`docs/`)** — Centralized all architectural guides (`AGENTS.md`, `WORKFLOW.md`, `ONBOARDING.md`, `MINDMAP.md`, `PROJECT-MANAGEMENT.md`, `IDEA.md`) into `docs/`.
- **Linguist & Line Ending Configurations (`.gitattributes`)** — Added `.gitattributes` to enforce automatic LF normalization and accurately attribute Python language statistics on GitHub.
- **Complete 58 Offensive Skills Catalog** — Restored missing core skills (`offensive-sqli`, `offensive-rce`, `offensive-file-upload`) across 13 specialized domains.
- **Knowledge Graph Visualizer (`graphify-out/`)** — Built a comprehensive 7,330-node knowledge graph and aggregated community HTML visualization.
- **Governance & Policy Documents** — Updated `SECURITY.md`, `CONTRIBUTING.md`, and `CHANGELOG.md` to standard English.
- **MIT License (`LICENSE`)** — Added permissive MIT license (use at your own risk, no warranty) with upstream attribution for the skills derived from SnailSpoit/Claude-Red. Updated the ethics/legal disclaimers in `README.md` and `SECURITY.md` to state that responsibility for lawful use rests with the user.

### Changed
- **Tool Packaging & Git Submodules** — Structured `tools/prism` and `tools/spiderfoot` as embedded submodules while keeping one-off scripts in `tools/src/`.
- **Environment Isolation (`.venv/`)** — Transitioned from platform-dependent virtual environments to local cross-platform `.venv/`.
- **Local Skills Destination** — Configured default installation to project-isolated `.agents/skills/` (gitignored), preventing pollution of the global agent environment.

### Removed
- **PowerShell Dependency (`install_skills.ps1`)** — Eliminated PowerShell scripts in favor of universal Python and POSIX shell standards.
- **Platform Specificity** — Removed all hardcoded WSL path dependencies across all documentation and scripts.
- **Target Telemetry Data** — Removed and untracked all historical assessment findings in `results/`.

---

## [Initial Release] — 2cce4ce

- Initial repository structure with core reporting templates, helper scripts, 55 baseline offensive skills, and documentation.