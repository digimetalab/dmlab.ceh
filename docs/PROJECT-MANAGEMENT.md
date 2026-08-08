# Engagement Management & Evidence Governance

This guide defines the standards for managing penetration testing engagements, operating the shared blackboard, maintaining evidence hygiene, and adhering to strict Git repository policies in DMLab CEH.

---

## 1. Engagement Lifecycle Management

Every penetration testing campaign managed by DMLab CEH follows a structured lifecycle from initiation to final remediation tracking:

```
[1. Initiation & Scope] -> [2. Authorization Gate] -> [3. Reconnaissance] 
  -> [4. Assessment & PoC] -> [5. Deliverable Synthesis] -> [6. Remediation & Retest]
```

### Key Milestones
1. **Scope Definition**: Target boundaries, IP/domain ranges, excluded systems, and authorized test windows recorded in `results/engagement.json`.
2. **Authorization Sign-off**: Explicit, written rules of engagement (RoE) confirmed.
3. **Blackboard Tracking**: Real-time status updates per target asset.
4. **Deliverable Finalization**: Generating standardized audit reports in `report/`.
5. **Engagement Close**: Archiving deliverables and performing evidence cleanup.

---

## 2. Shared Blackboard Architecture (`results/`)

The `results/` directory acts as a non-volatile, shared state blackboard across all dispatched agents. It is structured into designated subdirectories:

```
results/
├── engagement.json            # Target metadata, authorization scope, and overall status
├── recon/                     # Output from Prism CLI, SpiderFoot, and DNS footprints
│   ├── target_cdx.txt         # Wayback historical endpoints
│   └── target_domain.json     # Passive reconnaissance aggregation
├── findings/                  # Validated vulnerability findings with PoC details
│   ├── target_sqli_f1.json    # Structured JSON finding artifact
│   └── target_auth_f2.json
└── evidence/                  # Raw HTTP request/response payloads, screenshots, and logs
```

### Finding JSON Schema
All specialist agents persist discoveries using a standardized schema:

```json
{
  "finding_id": "FINDING-2026-001",
  "title": "SQL Injection in User Profile Lookup Endpoint",
  "severity": "HIGH",
  "cvss_v31": "CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N",
  "cvss_score": 8.1,
  "affected_component": "/api/v1/profile?user_id=123",
  "discovered_by": "sqli-agent",
  "timestamp": "2026-08-08T13:30:00Z",
  "evidence_file": "results/evidence/sqli_proof_001.http",
  "remediation": "Implement parameterized prepared statements using SQLAlchemy ORM."
}
```

---

## 3. Evidence Hygiene & Data Governance

1. **Credential Redaction**: Sensitive client credentials, session tokens, and passwords captured during proof-of-concept must be masked (e.g., `Bearer eyJ...[REDACTED]`).
2. **Payload Non-Destructiveness**: Verification must always utilize safe, read-only proof payloads (e.g., `SELECT CURRENT_USER()`, harmless file reads) rather than destructive alterations.
3. **Precise Timestamps**: Every action and request payload must record UTC timestamps for audit reconciliation with client server logs.
4. **Data Isolation**: Never transfer client telemetry outside the local assessment workspace.

---

## 4. Git Repository & Commit Hygiene

To ensure zero leakage of client target telemetry and maintain an immaculate codebase:

### What Gets Committed (Source of Truth)
- `skills/**/SKILL.md` (Standardized skill specifications)
- `tools/src/` (Universal installer scripts and helpers)
- `template/` (Reporting templates)
- `docs/` (Architecture and user documentation)
- `requirements.txt`, `.gitattributes`, `README.md`, `SECURITY.md`, `CONTRIBUTING.md`, `CHANGELOG.md`
- Submodule references (`tools/prism`, `tools/spiderfoot`)

### What is Strictly Gitignored (Local Runtime Artifacts)
- `report/` (Generated client deliverables)
- `results/` (Blackboard findings, recon datasets, and raw evidence)
- `.agents/` (Locally installed skills)
- `.venv/` (Local Python virtual environment)
- `source/` (Third-party repositories cloned for reference)
- `graphify-out/` (Knowledge graph generated artifacts)
