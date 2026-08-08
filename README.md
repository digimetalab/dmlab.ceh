# DMLab CEH — Agentic Multi-Agent Ethical Hacking & OSINT Framework

<p align="center">
  <img src="https://img.shields.io/badge/Python-3.8%20%7C%203.9%20%7C%203.10%20%7C%203.11%20%7C%203.12-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python Versions" />
  <img src="https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20macOS-0078D6?style=for-the-badge&logo=linux&logoColor=white" alt="Cross-Platform" />
  <img src="https://img.shields.io/badge/Skills-58%20Standard%20Skills-brightgreen?style=for-the-badge&logo=shield&logoColor=white" alt="58 Skills" />
  <img src="https://img.shields.io/badge/Architecture-Agentic%20Orchestrator-blueviolet?style=for-the-badge&logo=diagram-next&logoColor=white" alt="Agentic Architecture" />
  <img src="https://img.shields.io/badge/Agent%20Agnostic-Claude%20%7C%20OpenCode%20%7C%20Cursor%20%7C%20Codex-orange?style=for-the-badge" alt="Agent Agnostic" />
  <img src="https://img.shields.io/badge/Compliance-Authorized%20Testing%20Only-red?style=for-the-badge&logo=securityscorecard&logoColor=white" alt="Compliance" />
</p>

---

## 📌 Executive Overview

**DMLab CEH** is an open, modular, and agent-agnostic **Ethical Hacking & OSINT framework** built to bridge the gap between autonomous AI coding agents and real-world penetration testing methodologies. 

By orchestrating **58 standardized offensive security skills** (structured in YAML frontmatter `SKILL.md` format) alongside battle-tested OSINT engines ([**Prism**](tools/prism) and [**SpiderFoot**](tools/spiderfoot)), DMLab CEH enables an AI **Commander Agent** to dynamically plan, dispatch specialized agents, correlate vulnerabilities across a shared blackboard, and generate audit-ready CVSS v3.1/v4.0 deliverables.

> [!IMPORTANT]
> **Authorization & Compliance Notice**  
> This project is designed strictly for **educational research, authorized red teaming, and lawful penetration testing** within explicitly defined scopes (private labs, CTFs, and documented Bug Bounty/client engagements). **No authorization → strictly no execution.**

---

## 🏗️ Architecture & Multi-Agent Lifecycle

The framework follows a decoupled **Orchestrator-Specialist** design where the Commander manages workflow states while specialist agents load granular attack-surface skills on demand.

```mermaid
graph TD
    User([User / Security Analyst]) -->|Target & Authorization Scope| Commander[Commander Orchestrator Agent]
    
    subgraph Core Lifecycle
        Commander -->|1. Authorization Gate| AuthCheck{Authorized Scope?}
        AuthCheck -->|No| Stop([Halt Execution])
        AuthCheck -->|Yes| DAG[Build Dynamic Assessment DAG]
        
        DAG -->|Dispatch Phase 1| ReconLayer[Layer 1: Passive OSINT & Recon]
        DAG -->|Dispatch Phase 2| FastTriage[Layer 2: Fast Triage & Quick Wins]
        DAG -->|Dispatch Phase 3| AssessmentLayer[Layer 3: Targeted Assessment]
        DAG -->|Dispatch Phase 4| DeepLayer[Layer 4: Exploit & Verification]
        
        ReconLayer -->|Store Raw Artifacts| Blackboard[(Shared Blackboard: results/)]
        FastTriage -->|Correlate Findings| Blackboard
        AssessmentLayer -->|Enrich Evidence| Blackboard
        DeepLayer -->|Validate Impact| Blackboard
    end
    
    subgraph Tooling & Specialist Skills
        ReconLayer -.->|Executes| PrismCLI[Prism CLI & Modules]
        ReconLayer -.->|Executes| SpiderFoot[SpiderFoot Engine]
        AssessmentLayer -.->|Loads on Demand| WebSkills[16 Web Skills: SQLi, XSS, SSRF...]
        AssessmentLayer -.->|Loads on Demand| NetSkills[14 Wireless & RF Skills]
        AssessmentLayer -.->|Loads on Demand| IAMSkills[Auth & Active Directory Skills]
        DeepLayer -.->|Loads on Demand| ExploitSkills[Exploit Dev & Fuzzing Skills]
    end
    
    Blackboard -->|Phase 5: Compile Findings| ReportAgent[Reporting Agent]
    ReportAgent -->|Generates Deliverable| OutputDoc[Standard Report: report/web_target_timestamp.md]
```

---

## 📂 Repository Structure

```
dmlab.ceh/
├── docs/                      # Central technical documentation & guides
│   ├── AGENTS.md              # Multi-Agent Architecture & Specialist Schema
│   ├── WORKFLOW.md            # End-to-End 8-Phase Pentesting Lifecycle
│   ├── ONBOARDING.md          # Step-by-Step Installation & Setup Guide
│   ├── MINDMAP.md             # 58 Skills Catalog & OWASP/MITRE Cross-Matrix
│   ├── PROJECT-MANAGEMENT.md  # Engagement Management & Evidence Hygiene
│   └── IDEA.md                # Framework Technical Vision & Roadmap
├── skills/                    # 58 Standardized Offensive Skills (Source of Truth)
│   ├── offensive-sqli/SKILL.md
│   ├── offensive-xss/SKILL.md
│   ├── offensive-active-directory/SKILL.md
│   └── ...                    # (13 specialized attack surface categories)
├── tools/
│   ├── prism/                 # Self-hosted OSINT & Reconnaissance Engine (Submodule)
│   ├── spiderfoot/            # Automated Footprinting & Intelligence Gathering (Submodule)
│   └── src/                   # Universal installer & utility scripts
│       ├── install_skills.py  # Universal Python installer (Windows/Linux/macOS)
│       └── install_skills.sh  # POSIX Shell installer wrapper
├── template/                  # Standardized audit reporting templates (TEMPLATE.md)
├── report/                    # Generated engagement reports (Gitignored)
├── results/                   # Shared findings blackboard & evidence (Gitignored)
├── .agents/                   # Local workspace skills installation directory (Gitignored)
├── .venv/                     # Project-isolated Python virtual environment (Gitignored)
├── requirements.txt           # Unified dependency manifest for all tools
├── .gitattributes             # GitHub Linguist overrides & line ending policies
├── README.md                  # Project overview, quick start & reference guide
├── SECURITY.md                # Vulnerability disclosure policy
├── CONTRIBUTING.md            # Community contribution guidelines
└── CHANGELOG.md               # Version history and release notes
```

---

## ⚡ Quick Start & Installation

DMLab CEH is **100% cross-platform** (Windows, Linux, macOS) and maintains strict runtime isolation: all dependencies and installed skills reside locally in the project without altering your global machine environment.

### Step 1: Clone Repository with Submodules

```bash
git clone --recurse-submodules https://github.com/digimetalab/dmlab.ceh.git
cd dmlab.ceh
```

*(If cloned without `--recurse-submodules`, initialize them with: `git submodule update --init --recursive`)*

### One-Command Automated Setup (Recommended)

Run the root installer to automatically initialize submodules, create `.venv`, install all Python libraries, and deploy the 58 skills:

```bash
# Universal (Windows, Linux, macOS):
python install.py

# Linux / macOS / POSIX Shell:
./install.sh
```

---

### Step-by-Step Manual Setup

If you prefer manual, granular control:

```bash
# 1. Initialize Git Submodules
git submodule update --init --recursive

# 2. Create Virtual Environment & Install Dependencies
python -m venv .venv
# Linux/macOS: source .venv/bin/activate
# Windows:     .venv\Scripts\Activate.ps1
pip install -r requirements.txt

# 3. Install 58 Skills to .agents/skills/
python tools/src/install_skills.py
```

---

## 🎯 58 Standardized Skills Catalog

All 58 specialized offensive security skills are maintained as standardized `SKILL.md` specifications in the [`skills/`](skills/) source directory and installed locally to [`.agents/skills/`](.agents/skills/):

| Domain / Category | Count | Direct Links to Skills Source (`skills/**/SKILL.md`) |
|---|:---:|---|
| **Web Applications & APIs** | 16 | [`sqli`](skills/offensive-sqli/SKILL.md), [`xss`](skills/offensive-xss/SKILL.md), [`ssrf`](skills/offensive-ssrf/SKILL.md), [`ssti`](skills/offensive-ssti/SKILL.md), [`xxe`](skills/offensive-xxe/SKILL.md), [`idor`](skills/offensive-idor/SKILL.md), [`file-upload`](skills/offensive-file-upload/SKILL.md), [`rce`](skills/offensive-rce/SKILL.md), [`deserialization`](skills/offensive-deserialization/SKILL.md), [`race-condition`](skills/offensive-race-condition/SKILL.md), [`request-smuggling`](skills/offensive-request-smuggling/SKILL.md), [`open-redirect`](skills/offensive-open-redirect/SKILL.md), [`parameter-pollution`](skills/offensive-parameter-pollution/SKILL.md), [`graphql`](skills/offensive-graphql/SKILL.md), [`waf-bypass`](skills/offensive-waf-bypass/SKILL.md), [`business-logic`](skills/offensive-business-logic/SKILL.md) |
| **Authentication & IAM** | 2 | [`jwt`](skills/offensive-jwt/SKILL.md), [`oauth`](skills/offensive-oauth/SKILL.md) |
| **Active Directory & Enterprise** | 1 | [`active-directory`](skills/offensive-active-directory/SKILL.md) *(Kerberoasting, AS-REP Roasting, ACL Abuse, ADCS, Lateral Movement)* |
| **Wireless, RF & Physical IoT** | 14 | [`wifi`](skills/offensive-wifi/SKILL.md), [`wifi-recon`](skills/offensive-wifi-recon/SKILL.md), [`wpa2-psk`](skills/offensive-wpa2-psk/SKILL.md), [`wpa3-sae`](skills/offensive-wpa3-sae/SKILL.md), [`wpa-enterprise`](skills/offensive-wpa-enterprise/SKILL.md), [`wps`](skills/offensive-wps/SKILL.md), [`evil-twin`](skills/offensive-evil-twin/SKILL.md), [`krack-fragattacks`](skills/offensive-krack-fragattacks/SKILL.md), [`deauth-disassoc`](skills/offensive-deauth-disassoc/SKILL.md), [`bluetooth-ble`](skills/offensive-bluetooth-ble/SKILL.md), [`bluetooth-classic`](skills/offensive-bluetooth-classic/SKILL.md), [`zigbee-thread-matter`](skills/offensive-zigbee-thread-matter/SKILL.md), [`z-wave`](skills/offensive-z-wave/SKILL.md), [`lorawan-sub-ghz`](skills/offensive-lorawan-sub-ghz/SKILL.md) |
| **Cloud Security** | 1 | [`cloud`](skills/offensive-cloud/SKILL.md) *(AWS, Azure, GCP IAM escalation, IMDSv2, S3/Blob exfiltration)* |
| **Mobile Security** | 1 | [`mobile`](skills/offensive-mobile/SKILL.md) *(Android APK & iOS IPA static/dynamic analysis, Frida, IPC redirection)* |
| **IoT & Embedded Hardware** | 1 | [`iot`](skills/offensive-iot/SKILL.md) *(Firmware extraction, UART/JTAG, SPI/I2C flash dumps, RTOS)* |
| **Infrastructure & Red Team** | 7 | [`initial-access`](skills/offensive-initial-access/SKILL.md), [`advanced-redteam`](skills/offensive-advanced-redteam/SKILL.md), [`edr-evasion`](skills/offensive-edr-evasion/SKILL.md), [`shellcode`](skills/offensive-shellcode/SKILL.md), [`keylogger-arch`](skills/offensive-keylogger-arch/SKILL.md), [`windows-mitigations`](skills/offensive-windows-mitigations/SKILL.md), [`windows-boundaries`](skills/offensive-windows-boundaries/SKILL.md) |
| **Exploit Development** | 6 | [`exploit-development`](skills/offensive-exploit-development/SKILL.md), [`exploit-dev-course`](skills/offensive-exploit-dev-course/SKILL.md), [`basic-exploitation`](skills/offensive-basic-exploitation/SKILL.md), [`crash-analysis`](skills/offensive-crash-analysis/SKILL.md), [`mitigations`](skills/offensive-mitigations/SKILL.md), [`toctou`](skills/offensive-toctou/SKILL.md) |
| **Fuzzing & Vulnerability Research** | 4 | [`fuzzing`](skills/offensive-fuzzing/SKILL.md), [`fuzzing-course`](skills/offensive-fuzzing-course/SKILL.md), [`bug-identification`](skills/offensive-bug-identification/SKILL.md), [`vuln-classes`](skills/offensive-vuln-classes/SKILL.md) |
| **OSINT & Intelligence** | 2 | [`osint`](skills/offensive-osint/SKILL.md), [`osint-methodology`](skills/offensive-osint-methodology/SKILL.md) |
| **AI & LLM Security** | 1 | [`ai-security`](skills/offensive-ai-security/SKILL.md) *(Prompt injection, jailbreaking, RAG poisoning, model extraction)* |
| **Audit, Fast Triage & Utilities** | 2 | [`fast-checking`](skills/offensive-fast-checking/SKILL.md), [`reporting`](skills/offensive-reporting/SKILL.md) *(CVSS v3.1/v4.0 scoring, deliverable synthesis)* |

👉 *For full methodology walkthroughs, MITRE ATT&CK tactical matrices, and OWASP Top 10 cross-references, see [docs/MINDMAP.md](docs/MINDMAP.md).*

---

## 🛠️ Tooling & Footprinting Workflows (Full CLI Mode)

All tools operate natively within the local `.venv` environment and feature rich CLI capabilities:

```bash
# 1. Prism OSINT Platform CLI (Domain, Email, IP, Telegram, Username, Watchlists)
cd tools/prism
python cli.py scan example.com --type domain --json --verbose -o ../../results/recon/target.json
python cli.py scan someone@example.com --type email --json
python cli.py watchlist add example.com --interval 6 # Scheduled automated rescans

# 2. SpiderFoot Autonomous Intelligence CLI (200+ Specialized OSINT Modules)
cd tools/spiderfoot
python sf.py -s example.com -u all -o json > ../../results/recon/spiderfoot.json
python sf.py -s example.com -u passive -o json # Strictly non-intrusive reconnaissance
python sf.py -M # List all 200+ available footprinting modules
python sfcli.py -s http://127.0.0.1:5001 # Interactive CLI terminal & daemon client
```

👉 *For advanced switches, module filters, and daemon usage, consult the [Comprehensive CLI Tooling Guide](docs/TOOLING.md).*

---

## 📚 Documentation Index

| Guide | Description |
|---|---|
| 🚀 [**Onboarding Guide**](docs/ONBOARDING.md) | Comprehensive step-by-step setup and environment verification. |
| 🧰 [**CLI Tooling Manual**](docs/TOOLING.md) | Maximum CLI utilization guide for Prism and SpiderFoot. |
| 🤖 [**Agent Architecture**](docs/AGENTS.md) | In-depth breakdown of the Commander schema and specialist dispatch rules. |
| 🔄 [**End-to-End Workflow**](docs/WORKFLOW.md) | Standard 8-phase website and infrastructure assessment lifecycle. |
| 🗺️ [**Skills Mindmap**](docs/MINDMAP.md) | Complete taxonomy mapping skills to OWASP Top 10 and MITRE ATT&CK. |
| 📋 [**Project Management**](docs/PROJECT-MANAGEMENT.md) | Engagement tracking, evidence retention hygiene, and blackboard conventions. |
| 💡 [**Technical Vision**](docs/IDEA.md) | Core motivation and development roadmap. |
| 🛡️ [**Security Policy**](SECURITY.md) | Vulnerability disclosure and responsible reporting guidelines. |
| 🤝 [**Contributing Guide**](CONTRIBUTING.md) | Standards for adding new skills, tools, and documentation. |
| 📝 [**Changelog**](CHANGELOG.md) | Release notes and change history. |

---

## ⚖️ Ethics & Legal Disclaimer

- **Strict Authorization:** All assessments must be preceded by validated written authorization.
- **Data Privacy:** Raw target telemetry and scan outputs (`report/`, `results/`) are strictly gitignored and must never be committed to public version control.
- **Lawful Purpose:** DMLab CEH is distributed to enhance defensive security posture through rigorous, standardized ethical testing. Misuse of these tools against unauthorized systems is strictly illegal.
