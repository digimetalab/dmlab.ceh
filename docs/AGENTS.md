# Multi-Agent Penetration Testing Architecture

This document defines the **Multi-Agent Orchestration Architecture** of DMLab CEH. The framework decouples high-level campaign orchestration from granular technical execution: each specialist agent represents a modular capability driven by one or more standardized skills from `skills/`, backed by real-world tooling engines ([Prism CLI](../tools/prism) and [SpiderFoot](../tools/spiderfoot)).

---

## 1. Core Design Principles

| Principle | Specification |
|---|---|
| **One Skill = One Specialist** | Agents do not rely on implicit model memory; they dynamically ingest dedicated `SKILL.md` specifications upon activation. |
| **Decoupled Orchestrator** | A centralized **Commander Agent** governs the assessment Directed Acyclic Graph (DAG), while specialist subagents execute scoped domain tasks. |
| **Direct Tooling Integration** | Practical execution leverages real CLI tools (`python tools/prism/cli.py`, `sf.py`) rather than mock simulations. |
| **Shared Evidence Blackboard** | Inter-agent communication and intermediate findings are persisted in `results/` as structured JSON artifacts. |
| **Evidence & Reporting Hygiene** | All findings are timestamped, attributed to specific tools/payloads, and formatted per CVSS v3.1/v4.0 standards. |

---

## 2. Multi-Layer Hierarchy

```
+-------------------------------------------------------------------------+
|                       COMMANDER (Orchestrator Agent)                    |
|   Intent Parsing -> DAG Plan Construction -> Specialist Dispatch ->     |
|        Evidence Correlation -> Status Sync                              |
+------------------------------------+------------------------------------+
                                     |
                +--------------------+--------------------+
                v                                         v
+-------------------------------+       +-------------------------------+
|     RECONNAISSANCE LAYER      |       |       ASSESSMENT LAYER        |
|  - Passive OSINT Agent        |       |  - Web Application Agent      |
|  - SpiderFoot Footprint Agent |       |  - Authentication & IAM Agent |
|  - Fast Triage Agent          |       |  - Active Directory Agent     |
+---------------+---------------+       |  - Cloud & Infrastructure     |
                |                       |  - Wireless & RF Agent        |
                |                       +---------------+---------------+
                |                                       |
                +-------------------+-------------------+
                                    |
                                    v
+-------------------------------------------------------------------------+
|                     DEEP EXPLOITATION & VERIFICATION                    |
|  - Exploit Development Agent  - Red Team Operations  - Fuzzing Agent    |
+-----------------------------------+-------------------------------------+
                                    |
                                    v
+-------------------------------------------------------------------------+
|                             REPORTING AGENT                             |
|       Consolidates Blackboard Findings -> Generates Standard Deliverable|
+-------------------------------------------------------------------------+
```

---

## 3. Commander Agent (Orchestrator Lifecycle)

The **Commander Agent** is the single entry point for every engagement and is responsible for managing the end-to-end testing lifecycle:

1. **Intent Parsing**: Extracts target identifier, target category (Domain, IP, CIDR, Web Application, Identity), scope boundaries, and operational constraints from the analyst's prompt.
2. **DAG Plan Construction**: Generates a phased execution graph:
   ```
   Reconnaissance -> Fast Triage -> Surface Assessment -> Deep Verification -> Reporting
   ```
3. **Specialist Dispatch**: Activates targeted specialist subagents, supplying relevant blackboard context.
4. **Dynamic Escalation**: Inspects intermediate findings (e.g., an exposed GraphQL endpoint triggers the `graphql-agent`; discovered domain credentials trigger the `ad-agent`).
5. **Blackboard Synchronization**: Maintains operational state in `results/engagement.json`.

---

## 4. Specialist Agents & Skill Mapping

### Reconnaissance Layer

| Agent | Loaded Skills | Execution Tooling |
|---|---|---|
| **osint-agent** | `offensive-osint`, `offensive-osint-methodology` | `python tools/prism/cli.py scan <target> --type <domain\|email\|phone\|username> --json` |
| **spiderfoot-agent** | `offensive-osint-methodology` | `python tools/spiderfoot/sf.py -s <target> -u all -o json` |
| **fast-triage-agent** | `offensive-fast-checking` | Automated header inspection, quick-win checklists, and exposure audits |

### Assessment Layer (Attack Surface Specialists)

| Agent | Loaded Skills |
|---|---|
| **web-agent** | `offensive-fast-checking`, `offensive-business-logic`, `offensive-parameter-pollution`, `offensive-idor`, `offensive-race-condition` |
| **sqli-agent** | `offensive-sqli`, `offensive-waf-bypass` |
| **xss-agent** | `offensive-xss`, `offensive-waf-bypass` |
| **ssrf-agent** | `offensive-ssrf`, `offensive-open-redirect` |
| **ssti-agent** | `offensive-ssti` |
| **xxe-agent** | `offensive-xxe` |
| **file-upload-agent** | `offensive-file-upload` |
| **rce-agent** | `offensive-rce` |
| **deserialization-agent** | `offensive-deserialization` |
| **smuggling-agent** | `offensive-request-smuggling` |
| **graphql-agent** | `offensive-graphql` |
| **auth-agent** | `offensive-jwt`, `offensive-oauth` |
| **ad-agent** | `offensive-active-directory` |
| **wireless-agent** | `offensive-wifi`, `offensive-wifi-recon`, `offensive-wpa2-psk`, `offensive-wpa3-sae`, `offensive-wpa-enterprise`, `offensive-wps`, `offensive-evil-twin`, `offensive-deauth-disassoc`, `offensive-bluetooth-ble`, `offensive-bluetooth-classic`, `offensive-zigbee-thread-matter`, `offensive-z-wave`, `offensive-lorawan-sub-ghz` |
| **cloud-agent** | `offensive-cloud` |
| **mobile-agent** | `offensive-mobile` |
| **iot-agent** | `offensive-iot` |
| **ai-agent** | `offensive-ai-security` |

### Deep Verification & Exploit Layer

| Agent | Loaded Skills |
|---|---|
| **exploit-agent** | `offensive-exploit-development`, `offensive-basic-exploitation`, `offensive-crash-analysis`, `offensive-toctou` |
| **redteam-agent** | `offensive-initial-access`, `offensive-advanced-redteam`, `offensive-edr-evasion`, `offensive-shellcode`, `offensive-keylogger-arch`, `offensive-windows-boundaries`, `offensive-windows-mitigations` |
| **fuzzing-agent** | `offensive-fuzzing`, `offensive-bug-identification`, `offensive-vuln-classes` |

### Reporting Layer

| Agent | Loaded Skills | Output |
|---|---|---|
| **reporting-agent** | `offensive-reporting`, `offensive-fast-checking` | Generates standardized Markdown/HTML/PDF audit reports in `report/` |

---

## 5. Agent Invocation & Inter-Agent Communication

When operating with AI coding assistants (Claude Code, OpenCode, Cursor, Codex), specialist agents are invoked either via subagent tools or by referencing their domain keyword:

- Prompt example: `"Execute passive reconnaissance on target example.com"` → Dispatches `osint-agent` with `tools/prism`.
- Prompt example: `"Analyze the GraphQL endpoint for authorization bypass and introspection issues"` → Activates `graphql-agent` with `offensive-graphql`.
- Prompt example: `"Generate the final pentest report from blackboard findings"` → Dispatches `reporting-agent` with `offensive-reporting`.
