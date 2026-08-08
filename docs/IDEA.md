# Framework Concept, Vision & Technical Roadmap

## 1. The Core Problem

Comprehensive penetration testing is inherently complex, multi-phase, and iterative:
```
Reconnaissance -> Fast Triage -> Surface Assessment -> Verification / PoC -> Reporting
```

In traditional manual assessments, analysts must constantly context-switch across dozens of attack methodologies, CLI tools, and specialized scripts. Conversely, monolithic AI agents operating without structured domain skills often lose phase context, miss critical attack surfaces, and produce unverified, non-standardized reports.

---

## 2. The Core Solution

**DMLab CEH** solves this challenge by decoupling high-level campaign orchestration from specialized technical execution:

1. **Standardized Specialist Skills**: Each skill in `skills/` is a granular, expert specification formatted for AI ingestion (`SKILL.md`).
2. **Dynamic Commander Orchestrator**: An autonomous Commander builds an assessment Directed Acyclic Graph (DAG) based on the target type and dispatches specialists on demand.
3. **Real-World Engine Integration**: Directly utilizes battle-tested OSINT engines ([Prism CLI](../tools/prism) and [SpiderFoot](../tools/spiderfoot)) without reinventing foundational tools.
4. **Shared Blackboard**: Intermediate findings and evidence are synchronized in `results/` in standardized JSON format for downstream agents.

---

## 3. Key Advantages

| Advantage | Technical Implementation |
|---|---|
| **Comprehensive Coverage** | 58 specialized skills spanning Web, Auth, Active Directory, Wireless, Cloud, Mobile, IoT, Red Team, and Exploit Dev. |
| **Deep Methodology** | Agents do not depend on generic LLM memory; they load curated `SKILL.md` playbooks at runtime. |
| **Tooling Reuse** | Seamless execution of production OSINT tools via unified Python virtual environment. |
| **Evidence-Driven Escalation** | Reconnaissance findings dynamically determine which specialized assessment subagent is dispatched next. |
| **Auditable Deliverables** | Strict evidence hygiene, UTC timestamps, and standardized CVSS v3.1/v4.0 scoring. |

---

## 4. Development Roadmap

- **v1 (Current Architecture)**: Multi-agent schema and skill-to-agent mapping documented in [`AGENTS.md`](AGENTS.md); Commander coordinates execution across Claude Code, OpenCode, Cursor, and Codex.
- **v2 (Structured Blackboard)**: Standardized `results/` blackboard schema (`engagement.json`, findings per phase) providing persistent state across multi-day sessions.
- **v3 (Programmatic Autonomous Escalation)**: Commander autonomously evaluates `results/findings/*.json` to dynamically trigger deep verification and reporting agents.
- **v4 (Native API Wrappers)**: Native Python SDK integrating Prism, SpiderFoot, and custom scanners directly into CI/CD pipelines.

---

## 5. Ethical Standards & Legal Disclaimer

- Target data and scan outputs (`report/`, `results/`) are strictly kept local and gitignored.
- This documentation and all associated skills are published exclusively for **lawful security research, defensive engineering, and authorized penetration testing**.
