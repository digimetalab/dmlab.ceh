# Graph Report - D:\Projects\ceh  (2026-08-08)

## Corpus Check
- 66 files · ~379,816 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 342 nodes · 383 edges · 24 communities (23 shown, 1 thin omitted)
- Extraction: 80% EXTRACTED · 20% INFERRED · 0% AMBIGUOUS · INFERRED: 76 edges (avg confidence: 0.79)
- Token cost: 32,000 input · 5,000 output

## Community Hubs (Navigation)
- WiFi & WPA Attacks
- Web Auth & Mobile
- Exploit Development & Fuzzing
- Memory Mitigations & Shellcode
- Initial Access & C2
- HTTP Smuggling & WAF Bypass
- OSINT & Reporting
- Bank Kertiawan Engagement
- Business Logic & GraphQL
- Red Team C2 & Evasion
- WiFi Recon & KRACK
- Active Directory Attacks
- Bluetooth Attacks
- Race Conditions
- XSS & XXE Injection
- AI Security Testing
- Mesh IoT Wireless
- Agentic Pentest Platform
- Sub-GHz & LoRaWAN
- Windows Exploit Mitigations
- Cloud Attacks
- IoT & Firmware
- Keylogger Architecture
- CEH Lab Workspace

## God Nodes (most connected - your core abstractions)
1. `Offensive WiFi (802.11) Testing Methodology` - 15 edges
2. `Bank Kertiawan Findings F1-F2 (Recon + Fast Triage)` - 11 edges
3. `Active Directory Attack Methodology` - 10 edges
4. `AI/LLM Security Testing Methodology` - 9 edges
5. `Crash Analysis & Exploitability Assessment (Week 4)` - 9 edges
6. `offensive-mitigations skill` - 9 edges
7. `Basic Exploitation (Week 5)` - 8 edges
8. `EDR / AV Evasion` - 8 edges
9. `Exploit Development Guide` - 8 edges
10. `Modern Initial Access` - 8 edges

## Surprising Connections (you probably didn't know these)
- `AI/LLM Security Testing Methodology` --semantically_similar_to--> `AI-Assisted Bug Hunting`  [INFERRED] [semantically similar]
  .agents/skills/offensive-ai-security/SKILL.md → .agents/skills/offensive-bug-identification/SKILL.md
- `Agentic AI Pentest Platform Vision` --conceptually_related_to--> `Commander Orchestrator Agent`  [INFERRED]
  IDEA.md → AGENT-SCHEMA.md
- `Orchestration of 58 Skills + Prism OSINT Modules + SpiderFoot` --conceptually_related_to--> `Shared Blackboard in results/`  [INFERRED]
  IDEA.md → AGENT-SCHEMA.md
- `Fase 0: Preparation & Authorization` --conceptually_related_to--> `Authorization Gate & Evidence Hygiene`  [INFERRED]
  WORKFLOW-WEB-PENTEST.md → AGENT-SCHEMA.md
- `Fase 1: Passive Recon via Prism / SpiderFoot` --conceptually_related_to--> `Orchestration of 58 Skills + Prism OSINT Modules + SpiderFoot`  [INFERRED]
  WORKFLOW-WEB-PENTEST.md → IDEA.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Exploit Development Course Curriculum Pipeline** — _agents_skills_offensive_exploit_dev_course_skill_curriculum, _agents_skills_offensive_fuzzing_course_skill_fuzzing_course, _agents_skills_offensive_crash_analysis_skill_crash_analysis, _agents_skills_offensive_basic_exploitation_skill_basic_exploitation [EXTRACTED 1.00]
- **WiFi Attack Chain: Deauth -> Evil Twin -> Initial Access** — _agents_skills_offensive_deauth_disassoc_skill_deauth, _agents_skills_offensive_evil_twin_skill_evil_twin, _agents_skills_offensive_initial_access_skill_initial_access [EXTRACTED 1.00]
- **AD Credential Harvesting & Lateral Movement Kill Chain** — _agents_skills_offensive_active_directory_skill_llmnr_poisoning, _agents_skills_offensive_active_directory_skill_ntlm_relay, _agents_skills_offensive_active_directory_skill_passthehash, _agents_skills_offensive_active_directory_skill_dcsync, _agents_skills_offensive_active_directory_skill_ticket_forging [INFERRED 0.85]
- **RF/wireless attack surface** — offensive_wifi_recon, offensive_krack_fragattacks, offensive_lorawan_sub_ghz [INFERRED 0.75]
- **Web protocol-confusion attack family** — offensive_request_smuggling, offensive_parameter_pollution, offensive_waf_bypass [INFERRED 0.85]
- **Memory-corruption exploitation stack** — offensive_vuln_classes, offensive_shellcode, offensive_mitigations [INFERRED 0.85]
- **802.11 Attack Methodology** — _agents_skills_offensive_wifi_skill_offensive_wifi, _agents_skills_offensive_wpa2_psk_skill_offensive_wpa2_psk, _agents_skills_offensive_wpa_enterprise_skill_offensive_wpa_enterprise, _agents_skills_offensive_wpa3_sae_skill_offensive_wpa3_sae, _agents_skills_offensive_wps_skill_offensive_wps [INFERRED 0.85]
- **Bank Kertiawan Attack Surface** — results_findings_bankkertiawan_f1_f2_fortigate_exposure, results_findings_bankkertiawan_f1_f2_melody_mobile_banking, results_findings_bankkertiawan_f1_f2_wp_user_enumeration, results_findings_bankkertiawan_f1_f2_sql_injection_pendaftaran, results_findings_bankkertiawan_f1_f2_itms_portal, results_findings_bankkertiawan_f1_f2_infrastructure [INFERRED 0.75]
- **Exposed Custom PHP Applications** — results_findings_bankkertiawan_f1_f2_esurvei_app, results_findings_bankkertiawan_f1_f2_itms_portal, results_findings_bankkertiawan_f1_f2_sql_injection_pendaftaran [INFERRED 0.85]

## Communities (24 total, 1 thin omitted)

### Community 0 - "WiFi & WPA Attacks"
Cohesion: 0.07
Nodes (34): Deauthentication & Disassociation Attacks, Evil Twin / KARMA / Mana Attacks, WPA Handshake Capture & PMKID Attack, KRACK & FragAttacks, MAC Randomization Defeat, Offensive WiFi (802.11) Testing Methodology, Wi-Fi 6 / 6E / 7 Considerations, Wireless Airspace Recon & Adapter Selection (+26 more)

### Community 1 - "Web Auth & Mobile"
Cohesion: 0.07
Nodes (33): offensive-jwt skill, JWT algorithm confusion (alg:none, RS256->HS256), JWT header parameter injection (kid, jku, x5u, jwk), JWKS cache poisoning, JWS/JWE confusion, jwt_tool (ticarpi), JWT weak HMAC secret brute force, offensive-mobile skill (+25 more)

### Community 2 - "Exploit Development & Fuzzing"
Cohesion: 0.09
Nodes (31): Basic Exploitation (Week 5), Leak -> Compute -> Exploit Pattern, ASLR / NX / Canary Bypass, Return-to-libc, Return-Oriented Programming (ROP), Shellcode Injection, Stack Buffer Overflow, AI-Assisted Bug Hunting (+23 more)

### Community 3 - "Memory Mitigations & Shellcode"
Cohesion: 0.10
Nodes (21): offensive-mitigations skill, ASLR/DEP/NX memory protections, Mitigation bypass techniques, Control-flow integrity (CFI), KASLR, RELRO (partial/full), seccomp sandboxing, Stack canaries (+13 more)

### Community 4 - "Initial Access & C2"
Cohesion: 0.11
Nodes (20): Tiered C2 Infrastructure Segregation, Action-Frame Attacks vs PMF, Beacon Flooding DoS, Deauthentication / Disassociation Attacks, 802.11w PMF Awareness, Insecure Deserialization Testing, Deserialization Gadget Chains, Magic Method Abuse (+12 more)

### Community 5 - "HTTP Smuggling & WAF Bypass"
Cohesion: 0.11
Nodes (20): offensive-parameter-pollution skill, HTTP parameter pollution (first/last occurrence parsing), HTTP parameter pollution for WAF bypass, offensive-request-smuggling skill, Request-smuggling-driven cache poisoning, CL.TE request smuggling, HTTP/2 request smuggling, TE.CL request smuggling (+12 more)

### Community 6 - "OSINT & Reporting"
Cohesion: 0.11
Nodes (18): offensive-osint skill, Breach data lookup, Censys, Cryptocurrency tracing, Domain reconnaissance and infrastructure mapping, Email harvesting, Exposure scanning (Shodan, Censys), Geospatial intelligence (+10 more)

### Community 7 - "Bank Kertiawan Engagement"
Cohesion: 0.18
Nodes (18): Report Naming Convention (report/tipe_namatarget_yyyymmdd_hhmm.md), OSINT Digital Footprint of username cgyudistira, Pentest Report Structure (OWASP ASVS / PTES / NIST SP 800-115), Severity Tables & Strategic Recommendations, Bank Kertiawan Passive Recon & OSINT Report, Wayback CDX History & Legacy PHP Site (403 entries), Default DB Credentials (root / db_daftar) in Leaked Source, Elementor 4.0.1 CVE-2026-6127 / CVE-2026-49782 (+10 more)

### Community 8 - "Business Logic & GraphQL"
Cohesion: 0.15
Nodes (17): Business Logic Vulnerability Testing, Price / Quantity / Currency Manipulation, Role / Tenant Boundary Violation, State Machine / Workflow Bypass, Time-of-Check / Time-of-Use Races, Fast Testing Checklist, Rapid Web Recon & Surface Mapping, GraphQL Batching Attack (+9 more)

### Community 9 - "Red Team C2 & Evasion"
Cohesion: 0.20
Nodes (14): Malleable Beacon Profiles, C2 Infrastructure Design, Stealthy Data Exfiltration, Living Off The Land (LOTL), C2 Redirectors (cloudflared / websocat), Advanced Red Team Operations, Staged Payload Delivery (Stage 0/1/2), AMSI Bypass (+6 more)

### Community 10 - "WiFi Recon & KRACK"
Cohesion: 0.17
Nodes (13): offensive-krack-fragattacks skill, FragAttacks fragmentation/aggregation attacks (CVE-2020-24586..588), KRACK key reinstallation (CVE-2017-13077..082), krackattacks-scripts, Supplicant attack testing (vanhoefm/krackattacks-scripts), offensive-wifi-recon skill, Wi-Fi adapter selection for monitor mode, airodump-ng (+5 more)

### Community 11 - "Active Directory Attacks"
Cohesion: 0.27
Nodes (11): Active Directory Attack Methodology, ADCS Abuse (ESC1-ESC15), ASREProasting, BloodHound / SharpHound AD Recon, DCSync, Kerberos Delegation Abuse, Kerberoasting, LLMNR / NBT-NS / mDNS Poisoning (+3 more)

### Community 12 - "Bluetooth Attacks"
Cohesion: 0.20
Nodes (11): Bluetooth Low Energy Attack Methodology, crackle LTK Recovery, GATT Service / Characteristic Enumeration, BLE Pairing Attacks (Just Works MITM), BLE Pairing Exchange Sniffing, BlueBorne, Bluetooth Classic (BR/EDR) Attack Methodology, Bluetooth HID Spoofing (+3 more)

### Community 13 - "Race Conditions"
Cohesion: 0.20
Nodes (11): offensive-race-condition skill, Double-spend and rate-limit bypass races, Race condition exploitation, Single-packet race attack (Last-Byte sync), Turbo Intruder, offensive-toctou skill, Container/runc TOCTOU escapes, File-descriptor and /proc races (+3 more)

### Community 14 - "XSS & XXE Injection"
Cohesion: 0.20
Nodes (10): CSP / XSS Filter Bypass & Event Handler Injection, DOM Clobbering & Mutation XSS, Cross-Site Scripting (XSS) Testing Checklist, XSS Impact Escalation (Session Hijack, Phishing, Keylogging), Stored / Reflected / DOM / Blind XSS, Blind XXE / Out-of-Band Exfiltration, Classic XXE (File Read), XML External Entity (XXE) Injection Testing Checklist (+2 more)

### Community 15 - "AI Security Testing"
Cohesion: 0.31
Nodes (9): Training Data Poisoning, Excessive Agency & Plugin Abuse, garak LLM Vulnerability Scanner, Jailbreaking / Bypass Techniques, AI/LLM Security Testing Methodology, Model Extraction / Theft, OWASP Top 10 for LLM Applications, Prompt Injection (Direct/Indirect) (+1 more)

### Community 16 - "Mesh IoT Wireless"
Cohesion: 0.25
Nodes (9): Z-Wave Attack Methodology, Z-Wave S0 Network-Key Derivation Flaw & Key Reuse, Z-Wave S2 ECDH Commissioning Analysis, Z-Wave Sniffing (Z-Force / EZ-Wave / RTL-SDR + ZniffMobile), IEEE 802.15.4 Sniffing (TI CC2531 / KillerBee), Zigbee / Thread / Matter Mesh-Protocol Attack Methodology, Thread Credential Theft & Matter Commissioning Chain, Zigbee Touchlink Commissioning Abuse (+1 more)

### Community 17 - "Agentic Pentest Platform"
Cohesion: 0.25
Nodes (9): Authorization Gate & Evidence Hygiene, Shared Blackboard in results/, Commander Orchestrator Agent, RECON / ASSESSMENT / DEEP Specialist Agents, Orchestration of 58 Skills + Prism OSINT Modules + SpiderFoot, Agentic AI Pentest Platform Vision, v1 Manual to v2 Blackboard Evolution, Fase 0: Preparation & Authorization (+1 more)

### Community 18 - "Sub-GHz & LoRaWAN"
Cohesion: 0.25
Nodes (8): offensive-lorawan-sub-ghz skill, LoRaWAN downlink injection, Flipper Zero, HackRF, LoRaWAN ABP/OTAA join and session-key attacks, RTL-SDR, Sub-GHz protocol replay (KeeLoq, fixed-code remotes, TPMS), Universal Radio Hacker

### Community 19 - "Windows Exploit Mitigations"
Cohesion: 0.33
Nodes (7): Defeating Windows Security Boundaries (Week 7), Windows Privilege Escalation Path Planning, Sandbox Escape (LPAC, AppContainer), Windows Security Boundary Taxonomy, Windows Exploit Mitigation Stack (ASLR, DEP, CFG, CET, SEHOP, ACG), Known Mitigation Bypass Techniques, Understanding Windows Exploit Mitigations (Week 6)

### Community 20 - "Cloud Attacks"
Cohesion: 0.47
Nodes (6): Cloud Persistence Techniques, Cloud Attack Methodology (AWS/Azure/GCP), IAM Privilege Escalation, IMDS Credential Theft, Kubernetes-on-Cloud Attacks, Pacu AWS Toolkit

### Community 21 - "IoT & Firmware"
Cohesion: 0.33
Nodes (6): offensive-iot skill, binwalk, Bootloader and secure-boot attacks (U-Boot, fault injection), Firmware acquisition and analysis (flash dump, binwalk), UART/JTAG/SWD hardware debug interfaces, ICS/IoT protocol exploitation (MQTT, CoAP, Modbus, BACnet)

### Community 22 - "Keylogger Architecture"
Cohesion: 0.40
Nodes (5): offensive-keylogger-arch skill, ETW-based keystroke capture, Kernel-mode vs user-mode keylogger architecture, SetWindowsHookEx/WH_KEYBOARD_LL keylogging, Keylogger stealth and forensic trace management

## Knowledge Gaps
- **108 isolated node(s):** `BloodHound / SharpHound AD Recon`, `Kerberoasting`, `ASREProasting`, `C2 Redirectors (cloudflared / websocat)`, `Malleable Beacon Profiles` (+103 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Offensive WiFi (802.11) Testing Methodology` connect `WiFi & WPA Attacks` to `Mesh IoT Wireless`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **Why does `Modern Initial Access` connect `Initial Access & C2` to `Red Team C2 & Evasion`?**
  _High betweenness centrality (0.006) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Crash Analysis & Exploitability Assessment (Week 4)` (e.g. with `Exploit Development Guide` and `Offensive Fuzzing Methodology`) actually correct?**
  _`Crash Analysis & Exploitability Assessment (Week 4)` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `BloodHound / SharpHound AD Recon`, `Kerberoasting`, `ASREProasting` to the rest of the system?**
  _108 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `WiFi & WPA Attacks` be split into smaller, more focused modules?**
  _Cohesion score 0.06951871657754011 - nodes in this community are weakly interconnected._
- **Should `Web Auth & Mobile` be split into smaller, more focused modules?**
  _Cohesion score 0.06628787878787878 - nodes in this community are weakly interconnected._
- **Should `Exploit Development & Fuzzing` be split into smaller, more focused modules?**
  _Cohesion score 0.08817204301075268 - nodes in this community are weakly interconnected._