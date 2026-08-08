# Agent Configuration & Pre-Flight Workspace Bootstrap Protocol

This specification is automatically ingested by AI coding agents (**Claude Code, OpenCode, Codex, Cursor, Antigravity**) upon entering this workspace.

---

## ⚡ 1. Pre-Flight Verification & Automated Installation Protocol

Before accepting or executing any user tasks, reconnaissance, vulnerability assessments, or tool commands, the AI agent **MUST** verify whether the local workspace environment is fully initialized.

### Mandatory Pre-Flight Health Check
Run the fast verification command:

```bash
python install.py --check
```

### Automated Remediation Gate
- **If exit code is `0` (`[STATUS: 100% READY]`):** The workspace is fully installed and verified. Proceed directly to campaign planning or user request execution.
- **If exit code is `1` (`[STATUS: INCOMPLETE]`):** The local workspace has missing submodules, venv, or skills. The agent **MUST immediately run the automated bootstrap installer**:

```bash
# Universal (Windows, Linux, macOS):
python install.py

# or POSIX Shell (Linux, macOS, WSL):
./install.sh
```

> **Strict Rule:** No penetration testing tasks, tool scans (`tools/prism`, `tools/spiderfoot`), or specialist subagent dispatches may be executed until `python install.py --check` passes successfully.

---

## 🛡️ 2. Core Operational & Compliance Principles

1. **Authorization Gate:** Always verify written target authorization and scope boundaries in `results/engagement.json`. Never execute intrusive actions without explicit consent.
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
