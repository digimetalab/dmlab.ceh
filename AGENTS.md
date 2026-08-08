# Agent Configuration & Workspace Bootstrap Rules

This file is automatically ingested by AI coding agents (Claude Code, OpenCode, Codex, Cursor, Antigravity) when entering this workspace.

---

## ⚡ 1. Automatic Workspace Bootstrap Directive

Before executing any penetration testing tasks, assessments, or running tools, you **MUST** verify whether the local workspace environment is initialized:

```bash
# Check if .venv and .agents/skills exist:
# If either .venv or .agents/skills/ is missing, run the automated installer:
python install.py
# or: ./install.sh
```

> **Rule:** If `.venv` or `.agents/skills/` does not exist in the project directory, automatically run `python install.py` (or `./install.sh` on POSIX systems) to initialize the local environment and install the 58 offensive skills before performing further actions.

---

## 🛡️ 2. Core Operational Principles

1. **Authorization Gate:** Always verify written target authorization and scope boundaries. Never execute intrusive actions without explicit consent.
2. **Local Isolation:** All runtime artifacts (`report/`, `results/`, `.venv/`, `.agents/`) are strictly local and gitignored. Never commit client data to git.
3. **Evidence Hygiene:** Format all discovered findings into `results/findings/` using the standard JSON schema with CVSS v3.1/v4.0 scoring and UTC timestamps.

---

## 🤖 3. Multi-Agent Architecture & Specialist Skills

- **Commander Orchestrator**: Builds the assessment Directed Acyclic Graph (DAG) and dispatches specialist subagents.
- **58 Standardized Skills**: Installed locally at `.agents/skills/` and sourced from `skills/`.
- **Integrated Tooling Engines**:
  - Passive OSINT & Scanning: `tools/prism` (`python tools/prism/cli.py scan <target> --type <type>`)
  - Automated Footprinting: `tools/spiderfoot` (`python tools/spiderfoot/sf.py -s <target> -u all -o json`)

Detailed specifications and architectural guides:
- [Multi-Agent Schema & Specialist Dispatching](docs/AGENTS.md)
- [End-to-End 8-Phase Pentesting Lifecycle](docs/WORKFLOW.md)
- [58 Skills Taxonomy & OWASP/MITRE Matrix](docs/MINDMAP.md)
- [Engagement Governance & Blackboard Conventions](docs/PROJECT-MANAGEMENT.md)
- [Complete Onboarding Guide](docs/ONBOARDING.md)
