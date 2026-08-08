# End-to-End Web & Infrastructure Penetration Testing Workflow

This document outlines the standard **8-Phase Penetration Testing Lifecycle** implemented in DMLab CEH, maximizing the orchestration of all **58 offensive security skills** and integrated OSINT engines ([Prism CLI](../tools/prism) and [SpiderFoot](../tools/spiderfoot)).

All Python commands and tools must execute inside the project's local virtual environment (`.venv`).

> [!IMPORTANT]
> **Prerequisite:** Written authorization and verified rules of engagement (RoE) must be established before executing Phase 1. Without authorization → **HALT IMMEDIATELY**.

---

## Phase 0 — Scope, Authorization & Blackboard Setup

| Action | Skill / Tool | Description & Output |
|---|---|---|
| Define target scope, boundaries, and exclusions | Manual / Commander | Record target scope in `results/engagement.json` |
| Confirm written legal authorization | Compliance Gate | Mandatory validation before proceeding |
| Initialize blackboard structure | Filesystem | Create directories: `results/{recon,findings,evidence}` |

---

## Phase 1 — Passive Reconnaissance & OSINT

Objective: Enumerate attack surface, assets, subdomains, email exposure, and tech stack without generating active intrusive traffic.

| Target Element | Loaded Skill | Workflow / Tool Execution |
|---|---|---|
| Domain Footprint: WHOIS, DNS, crt.sh, GeoIP | `offensive-osint`, `offensive-osint-methodology` | Prism: `python cli.py scan <domain> --type domain --json` |
| Subdomain & Certificate Transparency | `offensive-osint-methodology` | Prism `cert_transparency` module (automated in scan) |
| Web Stack & Infrastructure Fingerprint | `offensive-osint-methodology` | Prism `website` module (headers, CMS, server tech) |
| Email & Identity Exposure | `offensive-osint` | Prism: `python cli.py scan <email> --type email --json` |
| Deep Correlation Footprint | `offensive-osint-methodology` | SpiderFoot: `python sf.py -s <target> -u all -o json` |
| Historical Endpoints & Wayback Snapshots | `offensive-osint` | Prism `wayback` module |
| Threat Intelligence & Reputation | `offensive-osint` | Prism: `shodan`, `virustotal`, `abuseipdb`, `censys` |

**Artifact Output:** `results/recon/<target>.json`

---

## Phase 2 — Fast Triage & Quick-Win Discovery

Objective: Rapidly detect high-risk, low-complexity misconfigurations and exposed sensitive resources.

| Audit Vector | Loaded Skill | Execution Technique |
|---|---|---|
| Quick-Win Checklist: Default creds, exposed backups, robots.txt, header misconfigurations | `offensive-fast-checking` | Automated inspection of recon data |
| Open Redirect Checks | `offensive-open-redirect` | Parameter review on identified redirect parameters |
| Parameter Pollution Baseline | `offensive-parameter-pollution` | Review duplicated parameters across query/body |

**Artifact Output:** `results/findings/fast-triage.json`

---

## Phase 3 — Attack Surface Mapping & Targeted Assessment

Objective: Map identified endpoints to specialized vulnerability assessment subagents.

| Discovered Surface | Dispatched Agent & Skill | Focus Areas |
|---|---|---|
| User Input Parameters | `sqli-agent` (`offensive-sqli`, `offensive-waf-bypass`) | Error-based, UNION, Blind, Time-based, JSON injection |
| Dynamic Reflection Points | `xss-agent` (`offensive-xss`, `offensive-waf-bypass`) | Stored, Reflected, DOM XSS, Context-specific payloads |
| Webhook / URL Fetching | `ssrf-agent` (`offensive-ssrf`, `offensive-open-redirect`) | Internal service access, Cloud metadata (IMDSv1/v2) |
| Template Engines | `ssti-agent` (`offensive-ssti`) | Jinja2, Twig, Freemarker, Velocity code execution |
| XML Parsing Endpoints | `xxe-agent` (`offensive-xxe`) | External entity injection, Out-of-band extraction |
| File Upload Handlers | `file-upload-agent` (`offensive-file-upload`) | Extension bypass, MIME spoofing, Polyglots, Webshells |
| Complex State Workflows | `web-agent` (`offensive-business-logic`) | Logic boundaries, Race conditions, Price manipulation |

---

## Phase 4 — Identity, Authentication & API Auditing

Objective: Evaluate authentication strength, session management, and authorization controls.

| Surface | Loaded Skill | Audit Objectives |
|---|---|---|
| JWT Implementations | `offensive-jwt` | `alg:none`, Key confusion (RS256→HS256), `kid` injection |
| OAuth 2.0 / OIDC | `offensive-oauth` | Redirect URI manipulation, State fixation, Token theft |
| Multi-Tenant / Object ID | `offensive-idor` | Horizontal/vertical privilege escalation across entities |
| GraphQL Endpoints | `offensive-graphql` | Introspection leakage, Batching attacks, Deep nesting DoS |
| HTTP Smuggling | `offensive-request-smuggling` | CL.TE / TE.CL desynchronization, Request hijacking |

---

## Phase 5 — Exploitation Verification & Impact Proof

Objective: Safely prove real-world business risk through controlled, minimal-impact Proof of Concept (PoC).

```
1. Craft safe, non-destructive demonstration payload (e.g., SELECT user(), read harmless file).
2. Validate WAF bypass requirements via `offensive-waf-bypass`.
3. Capture exact HTTP request/response payloads with full headers.
4. Record timestamps and remediation requirements to blackboard.
```

---

## Phase 6 — Post-Exploitation & Infrastructure Assessment (If Scoped)

| Scope | Loaded Skill | Objective |
|---|---|---|
| Active Directory / Hybrid | `offensive-active-directory` | Kerberoasting, ASREPRoasting, ADCS abuse, ACL paths |
| Cloud Environments | `offensive-cloud` | IAM privilege escalation, Storage exfiltration, Metadata abuse |
| Wireless / Physical Boundaries | `offensive-wifi`, `offensive-bluetooth-ble` | 802.1X inspection, BLE GATT analysis, Rogue AP audits |

---

## Phase 7 — Audit Reporting & Evidence Compilation

Objective: Consolidate blackboard findings into executive and technical deliverables.

```bash
# Invoked via Reporting Agent with skill offensive-reporting
# Generates report formatted as report/<type>_<target>_<yyyymmdd>_<hhmm>.md
```

Deliverable Requirements:
1. **Executive Summary**: Business risk narrative tailored for C-level leadership.
2. **CVSS Scoring**: Standard CVSS v3.1 / v4.0 vector string and justification.
3. **Reproducible Proof of Concept**: Exact steps, redacted request/response dumps.
4. **Remediation Plan**: Strategic hardening and tactical developer-level code fixes.
