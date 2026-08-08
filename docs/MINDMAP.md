# Offensive Skills Taxonomy & Attack Surface Mindmap

This document provides a comprehensive mapping of all **58 offensive security skills** available in DMLab CEH, indexed by attack surface domain, OWASP Top 10 categories, and MITRE ATT&CK tactical matrices.

---

## 1. High-Level Mindmap

```
DMLab CEH (58 Standard Skills)
├── 1. Web Applications & APIs (16 Skills)
│   ├── Injection: offensive-sqli, offensive-xss, offensive-ssti, offensive-xxe
│   ├── Access Control: offensive-idor, offensive-business-logic
│   ├── Server Flaws: offensive-ssrf, offensive-rce, offensive-deserialization, offensive-file-upload
│   ├── Protocol & State: offensive-race-condition, offensive-request-smuggling, offensive-open-redirect, offensive-parameter-pollution
│   └── Modern Stacks: offensive-graphql, offensive-waf-bypass
├── 2. Identity & Access Management (2 Skills)
│   └── offensive-jwt, offensive-oauth
├── 3. Enterprise & Active Directory (1 Skill)
│   └── offensive-active-directory (Kerberoasting, ASREPRoasting, ADCS, ACL Abuse)
├── 4. Wireless, RF & IoT Physical (14 Skills)
│   ├── Wi-Fi: offensive-wifi, offensive-wifi-recon, offensive-wpa2-psk, offensive-wpa3-sae, offensive-wpa-enterprise, offensive-wps, offensive-evil-twin, offensive-krack-fragattacks, offensive-deauth-disassoc
│   ├── Bluetooth: offensive-bluetooth-ble, offensive-bluetooth-classic
│   └── Mesh & Sub-GHz: offensive-zigbee-thread-matter, offensive-z-wave, offensive-lorawan-sub-ghz
├── 5. Cloud & Virtualization (1 Skill)
│   └── offensive-cloud (AWS, Azure, GCP IAM escalation, IMDSv2, S3/Blob exfiltration)
├── 6. Mobile Application Security (1 Skill)
│   └── offensive-mobile (Android & iOS static/dynamic analysis, Frida, IPC redirection)
├── 7. IoT & Embedded Hardware (1 Skill)
│   └── offensive-iot (Firmware triage, UART/JTAG, SPI/I2C, Hardware reversing)
├── 8. Infrastructure & Red Team Operations (7 Skills)
│   └── offensive-initial-access, offensive-advanced-redteam, offensive-edr-evasion, offensive-shellcode, offensive-keylogger-arch, offensive-windows-mitigations, offensive-windows-boundaries
├── 9. Exploit Development & Binary Exploitation (6 Skills)
│   └── offensive-exploit-development, offensive-exploit-dev-course, offensive-basic-exploitation, offensive-crash-analysis, offensive-mitigations, offensive-toctou
├── 10. Fuzzing & Vulnerability Research (4 Skills)
│   └── offensive-fuzzing, offensive-fuzzing-course, offensive-bug-identification, offensive-vuln-classes
├── 11. OSINT & Intelligence Gathering (2 Skills)
│   └── offensive-osint, offensive-osint-methodology
├── 12. AI & LLM Security (1 Skill)
│   └── offensive-ai-security (Prompt injection, jailbreaking, model extraction)
└── 13. Audit & Reporting Utilities (2 Skills)
    └── offensive-fast-checking, offensive-reporting
```

---

## 2. Detailed Skills Directory & Threat Mapping

### 1. Web Applications & APIs (16 Skills)

| Skill | Attack Surface | Target Mechanisms & Vectors |
|---|---|---|
| `offensive-sqli` | Relational & NoSQL Databases | Error-based, UNION-based, Blind, Time-based, JSON operators, SQLmap automation |
| `offensive-xss` | Web Client Context | Stored, Reflected, DOM-based, CSP bypass, Context escaping |
| `offensive-ssrf` | Server Outbound Fetchers | Cloud metadata access (AWS IMDSv1/v2, GCP, Azure), internal port scanning |
| `offensive-ssti` | Template Engines | Jinja2, Twig, Freemarker, Velocity, Pebble, Mako remote code execution |
| `offensive-xxe` | XML Parsers | External entity resolution, Blind out-of-band extraction, SSRF via XML |
| `offensive-idor` | Object Identifiers | Insecure direct object reference, horizontal/vertical tenant boundary violation |
| `offensive-file-upload` | File Ingestion Handlers | MIME type spoofing, double extensions, polyglots, webshell deployment |
| `offensive-rce` | OS Command Handlers | Command injection, pipe/semicolon chaining, argument injection, shell evasion |
| `offensive-deserialization` | Serialized State Handlers | Python pickle, Java ysoserial gadget chains, PHP object injection |
| `offensive-race-condition` | Concurrency & State | TOCTOU concurrency, idempotency violations, payment/coupon race windows |
| `offensive-request-smuggling` | Reverse Proxies & HTTP Parsing | CL.TE, TE.CL, TE.TE HTTP/1.1 and HTTP/2 desynchronization |
| `offensive-open-redirect` | Navigation Parameters | Unvalidated redirects, OAuth code theft, phishing delivery |
| `offensive-parameter-pollution` | Query/Body Parsers | HTTP Parameter Pollution (HPP) across frontend proxies and backend engines |
| `offensive-graphql` | GraphQL APIs | Schema introspection extraction, batching brute-force, deep nesting DoS |
| `offensive-waf-bypass` | Web Application Firewalls | Payload obfuscation, chunked encoding, unicode normalization bypass |
| `offensive-business-logic` | Transactional Workflows | Multi-step workflow bypass, price manipulation, currency confusion |

### 2. Identity & Access Management (2 Skills)

| Skill | Focus Vector | Key Audit Checks |
|---|---|---|
| `offensive-jwt` | Token Authentication | Algorithm confusion (`alg:none`, RS256→HS256), `kid` injection, JWKS poisoning |
| `offensive-oauth` | OAuth 2.0 / OIDC | Redirect URI manipulation, state parameter fixation, token leakage |

### 3. Active Directory & Enterprise Networks (1 Skill)

| Skill | Domain | Key Assessment Techniques |
|---|---|---|
| `offensive-active-directory` | Hybrid & On-Prem AD | Kerberoasting, ASREPRoasting, NTLM relay, ACL abuse, ADCS (ESC1-ESC15), DCSync |

### 4. Wireless, RF & Physical IoT (14 Skills)

| Skill | Protocol / Standard | Coverage |
|---|---|---|
| `offensive-wifi` | 802.11 Airspace | Comprehensive wireless assessment methodology across 2.4/5/6 GHz |
| `offensive-wifi-recon` | 802.11 Airspace | Monitor mode, hidden SSID discovery, channel mapping, multi-band war-driving |
| `offensive-wpa2-psk` | 802.11 WPA2 Personal | 4-way handshake capture, PMKID attacks, GPU-accelerated hashcat cracking |
| `offensive-wpa3-sae` | 802.11 WPA3 SAE | Transition-mode downgrade, Dragonblood side-channel analysis, H2E timing |
| `offensive-wpa-enterprise` | 802.1X / EAP | Rogue RADIUS eaphammer attacks, MSCHAPv2 challenge cracking, client cert theft |
| `offensive-wps` | Wi-Fi Protected Setup | Pixie Dust offline cracking, online PIN brute-force, lockout handling |
| `offensive-evil-twin` | Rogue Access Points | KARMA, Mana selective probe response, captive portal phishing |
| `offensive-krack-fragattacks` | WPA2 & 802.11 Layer | Key reinstallation analysis, frame aggregation/fragmentation flaws |
| `offensive-deauth-disassoc` | 802.11 Frames | Targeted disassociation for handshake coercion, PMF (802.11w) evaluation |
| `offensive-bluetooth-ble` | Bluetooth Low Energy | GATT enumeration, unauthenticated read/write, Just Works pairing downgrade |
| `offensive-bluetooth-classic` | Bluetooth BR/EDR | SDP service discovery, legacy PIN attacks, LMP/L2CAP profile exploitation |
| `offensive-zigbee-thread-matter` | 802.15.4 Mesh Networks | Sniffing with KillerBee, Touchlink commissioning abuse, packet injection |
| `offensive-z-wave` | Z-Wave Smart Home | S0 network-key derivation flaws, unauthenticated node command injection |
| `offensive-lorawan-sub-ghz` | LoRaWAN / 433/868 MHz | OTAA join attack, frame counter replay, KeeLoq fixed-code remote capture |

### 5. Cloud, Infrastructure, Mobile & Binary Exploitation

| Skill | Category | Primary Focus |
|---|---|---|
| `offensive-cloud` | Cloud Security | AWS, Azure, GCP IAM privilege escalation, IMDSv2 abuse, storage exfiltration |
| `offensive-mobile` | Mobile Pentesting | Android APK (jadx) & iOS (IPA) reversing, Frida instrumentation, SSL pinning bypass |
| `offensive-iot` | Hardware Security | UART, JTAG, SPI flash dumps, binwalk firmware analysis, embedded RTOS |
| `offensive-advanced-redteam` | Red Team Operations | Multi-stage payload delivery, C2 architecture, living-off-the-land techniques |
| `offensive-edr-evasion` | EDR & Defender Evasion | Direct system calls, API unhooking, AMSI/ETW patching, process hollowing |
| `offensive-shellcode` | Payload Engineering | Position-independent code (PIC), PEB traversal, custom API hashing |
| `offensive-exploit-development` | Exploit Engineering | Stack/Heap buffer overflows, ROP gadget chaining, ASLR/DEP bypass |
| `offensive-toctou` | Concurrency & Race | Filesystem symlink races, kernel double-fetch, orchestrator race conditions |
| `offensive-fuzzing` | Vulnerability Discovery | AFL++, libFuzzer, Boofuzz protocol fuzzing, coverage-guided mutation |
| `offensive-ai-security` | AI / LLM Security | Direct/indirect prompt injection, model jailbreaking, training data extraction |
| `offensive-reporting` | Audit Deliverables | CVSS v3.1/v4.0 vector calculation, executive summary synthesis, remediation |
