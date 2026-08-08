# Contributing Guidelines

Thank you for contributing to **DMLab CEH**. This repository provides an ethical hacking and multi-agent orchestration framework strictly designed for **lawful security research and authorized penetration testing**.

---

## 1. Contribution Scope

We welcome contributions from security analysts, red/purple/blue teamers, and AI tool developers:

| Contribution Category | Target Directory |
|---|---|
| Documentation & Architecture Fixes | `README.md`, `docs/`, `SECURITY.md` |
| Automation & Cross-Platform Utilities | `tools/src/` (Python scripts and POSIX shell wrappers) |
| Standardized Report Templates | `template/` |
| Framework Governance & Specs | `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md` |

---

## 2. Contribution Workflow

1. **Fork & Clone**: Fork the repository and create a descriptive feature branch:
   ```bash
   git checkout -b feat/enhance-installer
   # or
   git checkout -b fix/workflow-documentation
   ```
2. **Modify Only Source Files**:
   - Only modify source assets (`skills/`, `tools/src/`, `template/`, `docs/`).
   - Never modify or commit local runtime artifacts (`report/`, `results/`, `.agents/`, `.venv/`, `graphify-out/`).
   - Do not commit changes inside submodule directories (`tools/prism/`, `tools/spiderfoot/`) unless contributing upstream.
3. **Validate Code & Syntax**:
   - Python code must be formatted and clean (`python -m py_compile tools/src/*.py`).
   - Shell scripts must pass syntax checks (`bash -n tools/src/*.sh`).
   - All internal markdown links must be valid.
4. **Commit with Conventional Messages**:
   - Example: `feat: add parallel skill verification to install_skills.py`
   - Example: `docs: update attack surface mapping in docs/MINDMAP.md`
5. **Open a Pull Request**: Submit the PR to the `master` branch with a clear description of your changes.

---

## 3. Non-Negotiable Standards

- **Strict Authorization:** No content may encourage or facilitate unauthorized or unlawful testing.
- **Zero Target Data:** Never commit target metadata, client credentials, or raw findings from `results/` or `report/`.
- **Zero Hardcoded Secrets:** Never commit `.env` files, API keys, or private tokens.
- **Immaculate Git Hygiene:** Ensure that gitignored directories remain untracked.
