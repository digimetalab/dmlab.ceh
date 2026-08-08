# Security Policy & Vulnerability Disclosure

## 1. Scope & Context

**DMLab CEH** provides modular offensive security skills, methodologies, and multi-agent orchestration workflows designed exclusively for **lawful penetration testing, authorized red teaming, and defensive cybersecurity education**.

While the methodologies documented within this repository reflect real-world attack vectors, the project codebase itself (including installer scripts, orchestration schemas, reporting templates, and tooling integrations) must adhere to rigorous security and safety standards.

---

## 2. Reporting a Vulnerability

If you discover a security vulnerability or implementation flaw within this repository's codebase (such as in `tools/src/`, installer scripts, or templates), please report it responsibly:

- **Method**: Open a confidential security advisory on GitHub or contact the repository maintainers directly.
- **Include**:
  - Detailed reproduction steps.
  - Potential impact and severity assessment.
  - Affected files, commit hash, and line numbers.
  - Suggested patch or mitigation (if available).
- **Public Disclosure**: Please allow a reasonable remediation window (typically 90 days) before any public discussion or disclosure.

---

## 3. Areas of Primary Concern

1. **Script Security & Path Traversal**: Ensuring installer scripts (`tools/src/install_skills.py`, `.sh`) strictly sanitize inputs and prevent arbitrary file overwrites.
2. **Credential & Secret Hygiene**: Ensuring zero hardcoded credentials, API tokens, or secrets exist within the repository source.
3. **Target Data Containment**: Ensuring all client telemetry, findings, and reports remain strictly isolated in gitignored directories (`report/`, `results/`).
4. **Methodology Integrity**: Reviewing skills to ensure they teach industry-standard, auditable ethical methodologies adhering strictly to legal testing boundaries.

---

## 4. Lawful Purpose & Compliance Disclaimer

All content in this repository is provided for authorized testing only:
- Documented Bug Bounty programs with explicit scope.
- Professional penetration testing engagements under signed client contracts.
- Private cybersecurity laboratories and CTF competitions.

The maintainers assume no liability for misuse or actions performed without explicit, documented authorization.
