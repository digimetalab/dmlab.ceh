# Comprehensive CLI Tooling Guide: Prism & SpiderFoot

This manual provides an in-depth reference for maximizing the execution of **Prism CLI** and **SpiderFoot CLI** within the DMLab CEH framework. 

All commands must be executed within the project's local virtual environment (`.venv`).

---

## 1. Prism OSINT & Scanning Platform CLI

Prism is an integrated OSINT reconnaissance engine featuring modular analyzers for domains, IP addresses, email addresses, phone numbers, usernames, and Telegram accounts.

### Location & Virtual Environment Execution
```bash
cd tools/prism
# Linux / macOS:   source ../../.venv/bin/activate
# Windows PS:      ..\..\.venv\Scripts\Activate.ps1
```

### Full Command-Line Syntax & Options
```bash
python cli.py scan <target> [options]
```

| Option | Flag | Description |
|---|---|---|
| **Target Type** | `--type, -t` | Explicitly specify target type: `domain`, `ip`, `email`, `phone`, `username`, `telegram`. *(Auto-detected if omitted)* |
| **Modules Filter** | `--modules, -m` | Comma-separated list of specific modules to run (e.g., `-m censys_lookup,shodan_lookup,wayback`). |
| **JSON Output** | `--json` | Generates machine-readable JSON (Default format, ideal for blackboard ingestion). |
| **HTML Report** | `--html` | Generates a standalone interactive HTML visual report. |
| **PDF Report** | `--pdf` | Compiles a formatted executive PDF audit report. |
| **Output Path** | `--output, -o` | Custom file destination for reports (e.g., `-o ../../results/recon/target.json`). |
| **Verbose Mode** | `--verbose, -v` | Prints real-time module execution progress and debugging logs to `stderr`. |
| **Quiet Mode** | `--quiet, -q` | Suppresses headers and banners, outputting raw data to `stdout`. |

---

### Prism Practical Execution Recipes

#### A. Comprehensive Domain Reconnaissance
```bash
# Full verbose domain scan with structured JSON output into the shared blackboard:
python cli.py scan target.com --type domain --json --verbose -o ../../results/recon/target_domain.json

# Generate standalone HTML deliverable:
python cli.py scan target.com --type domain --html -o ../../report/web_target_recon.html
```

#### B. Identity, Username & Email Footprinting
```bash
# Email address verification, breach correlation, and header analysis:
python cli.py scan admin@target.com --type email --json -o ../../results/recon/email_admin.json

# Cross-platform username enumeration across 500+ social/developer platforms:
python cli.py scan target_user --type username --json --verbose -o ../../results/recon/user_target.json
```

#### C. IP Infrastructure & Threat Intelligence
```bash
# Run specific high-impact modules against target infrastructure:
python cli.py scan 192.0.2.1 --type ip -m censys_lookup,shodan_lookup,threat_intel --json
```

#### D. Scheduled Re-Scanning & Watchlists
Prism includes an automated recurring monitoring system:
```bash
# Add a target to the recurring watchlist (e.g., rescan every 6 hours):
python cli.py watchlist add target.com --type domain --interval 6

# List active monitoring targets:
python cli.py watchlist list

# Pause / Resume monitoring:
python cli.py watchlist pause target.com
python cli.py watchlist resume target.com

# Remove from watchlist:
python cli.py watchlist rm target.com
```

---

## 2. SpiderFoot Automated Footprinting & Intelligence CLI

SpiderFoot is a heavy-duty OSINT automation framework with 200+ specialized modules for footprinting networks, infrastructure, certificates, DNS hierarchies, and exposed cloud assets.

### Location & Virtual Environment Execution
```bash
cd tools/spiderfoot
```

### Full Command-Line Syntax & Options
```bash
python sf.py -s <target> [options]
```

| Option | Flag | Description |
|---|---|---|
| **Target** | `-s <target>` | Target domain, IP, CIDR block, email address, phone number, or AS number. |
| **Use Case Mode** | `-u <usecase>` | Automated module grouping: `all`, `footprint`, `investigate`, `passive`. |
| **Target Type Constraint** | `-t <type>` | Constrain target type: `IP_ADDRESS`, `INTERNET_NAME`, `EMAILADDR`, `USERNAME`, etc. |
| **Module Selection** | `-m <modules>` | Comma-separated list of individual modules to execute (e.g., `-m sfp_dnsresolve,sfp_whois,sfp_shodan`). |
| **Output Format** | `-o <format>` | Output format: `json`, `csv`, `tab` (Default: `tab`). |
| **List Modules** | `-M` | Lists all 200+ available modules with descriptions and requirements. |
| **List Event Types** | `-T` | Lists all structured OSINT event data types. |
| **Concurrent Threads** | `-q` | Adjust concurrency limit (Default: 3 threads). |
| **Debug Mode** | `-d` | Enables verbose debug tracing. |
| **Web Server Daemon** | `-l <host:port>` | Launches the SpiderFoot REST API and Web UI (e.g., `-l 127.0.0.1:5001`). |

---

### SpiderFoot Practical Execution Recipes

#### A. Full Spectrum Autonomous Scan (`-u all`)
```bash
# Execute all active footprinting modules and dump raw JSON findings:
python sf.py -s target.com -u all -o json > ../../results/recon/target_spiderfoot_all.json
```

#### B. Strictly Passive OSINT Scan (`-u passive`)
```bash
# Execute only non-intrusive third-party database lookups without touching target servers:
python sf.py -s target.com -u passive -o json > ../../results/recon/target_passive_osint.json
```

#### C. Targeted Module Execution
```bash
# Run specific DNS, certificate transparency, and WHOIS enrichment modules:
python sf.py -s target.com -m sfp_dnsresolve,sfp_crt,sfp_whois,sfp_subdomain -o json > ../../results/recon/target_dns_subdomains.json
```

#### D. Inspecting Available Modules & Data Types
```bash
# View all installed modules:
python sf.py -M

# View all event types:
python sf.py -T
```

#### E. Background Daemon & Interactive Shell (`sfcli.py`)
```bash
# 1. Start headless REST API server:
python sf.py -l 127.0.0.1:5001 &

# 2. Interact via SpiderFoot CLI shell:
python sfcli.py -s http://127.0.0.1:5001

# Inside sfcli shell:
# sf> start -s target.com -t INTERNET_NAME -u passive
# sf> scans
# sf> data -i <scan_id> -o json
```

---

## 3. Chained Multi-Agent OSINT Pipeline Recipe

Specialist agents combine Prism and SpiderFoot to construct a deep attack-surface map:

```
+-------------------------------------------------------------------------+
|                  Phase 1: Fast OSINT & Exposure (Prism)                 |
|  $ python tools/prism/cli.py scan target.com --type domain --json       |
|    -> Subdomains, email addresses, CMS, DNS records extracted.          |
+------------------------------------+------------------------------------+
                                     |
                                     v
+-------------------------------------------------------------------------+
|               Phase 2: Deep Correlation & Network Footprint             |
|  $ python tools/spiderfoot/sf.py -s target.com -u passive -o json       |
|    -> ASN hierarchy, IP ranges, exposed cloud buckets, cert anomalies.  |
+------------------------------------+------------------------------------+
                                     |
                                     v
+-------------------------------------------------------------------------+
|               Phase 3: Persistence to Blackboard (results/recon/)       |
|  Results parsed and formatted into results/findings/fast-triage.json    |
|  Specialist assessment agents (SQLi, XSS, Auth, AD, Cloud) triggered.   |
+-------------------------------------------------------------------------+
```
