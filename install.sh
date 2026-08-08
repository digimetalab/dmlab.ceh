#!/usr/bin/env bash
# =============================================================================
# DMLab CEH — Automated Project Installer (install.sh)
# One-command bootstrap for developers and AI agents (Claude, OpenCode, Codex).
# Checks and initializes:
#   1. Git Submodules (tools/prism, tools/spiderfoot) with upstream sync
#   2. Local Python Virtual Environment (.venv/)
#   3. Python Dependencies (root & submodule requirements.txt)
#   4. 58 Standardized Skills (.agents/skills/)
#
# Usage:
#   ./install.sh           # Standard local install
#   ./install.sh --latest  # Sync submodules to latest upstream commits & install
#   ./install.sh --force   # Force re-installation of dependencies and skills
#   ./install.sh --dry-run # Preview actions without making changes
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DRY_RUN=0
FORCE=0
LATEST=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --force) FORCE=1 ;;
    --latest) LATEST=1 ;;
    *) echo "Unknown option: $arg"; exit 1 ;;
  esac
done

echo "================================================================="
echo "        DMLab CEH — Agentic Framework Automated Installer       "
echo "================================================================="
echo "Workspace Root: $SCRIPT_DIR"

# 1. Initialize & Sync Git Submodules
echo ""
echo "[1/5] Checking Git Submodules (tools/prism, tools/spiderfoot)..."
if (( LATEST )); then
  echo "  -> Fetching latest upstream commits for submodules..."
  if (( ! DRY_RUN )); then
    git submodule update --init --remote --recursive || true
  fi
  echo "  [OK] Submodules updated to latest upstream."
elif [[ ! -f "tools/prism/cli.py" ]] || [[ ! -f "tools/spiderfoot/sf.py" ]] || (( FORCE )); then
  if (( DRY_RUN )); then
    echo "  [dry-run] Would initialize git submodules."
  else
    echo "  -> Initializing submodules..."
    git submodule update --init --recursive || true
    echo "  [OK] Submodules initialized."
  fi
else
  echo "  [OK] Submodules already present."
fi

# 2. Check / Create Local Virtual Environment (.venv)
echo ""
echo "[2/5] Checking Local Virtual Environment (.venv/)..."
PYTHON_BIN=""

if [[ -d ".venv" ]] && [[ ! -f ".venv/bin/python" ]] && [[ ! -f ".venv/Scripts/python.exe" ]]; then
  echo "  [WARN] Incomplete .venv detected. Rebuilding..."
  rm -rf .venv
fi

if [[ ! -d ".venv" ]] || (( FORCE )); then
  if (( DRY_RUN )); then
    echo "  [dry-run] Would create .venv directory."
  else
    echo "  -> Creating Python virtual environment in .venv/..."
    if command -v python3 >/dev/null 2>&1; then
      python3 -m venv .venv
    elif command -v python >/dev/null 2>&1; then
      python -m venv .venv
    elif command -v py >/dev/null 2>&1; then
      py -3 -m venv .venv
    else
      echo "  [ERROR] Python interpreter not found! Please install Python 3.8+."
      exit 1
    fi
    echo "  [OK] Virtual environment created."
  fi
else
  echo "  [OK] Local virtual environment (.venv) exists."
fi

# Resolve Venv Python Binary
if [[ -f ".venv/bin/python" ]]; then
  PYTHON_BIN=".venv/bin/python"
elif [[ -f ".venv/Scripts/python.exe" ]]; then
  PYTHON_BIN=".venv/Scripts/python.exe"
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="python3"
else
  PYTHON_BIN="python"
fi

# 3. Install Unified & Submodule Requirements
echo ""
echo "[3/5] Installing/Updating Python Dependencies across all tools..."
REQ_FILES=("requirements.txt" "tools/spiderfoot/requirements.txt" "tools/prism/requirements.txt" "tools/prism/requirements-web.txt")

if (( ! DRY_RUN )); then
  "$PYTHON_BIN" -m pip install --upgrade pip --quiet || true
fi

for req in "${REQ_FILES[@]}"; do
  if [[ -f "$req" ]]; then
    if (( DRY_RUN )); then
      echo "  [dry-run] Would install $req"
    else
      echo "  -> Installing requirements from $req..."
      "$PYTHON_BIN" -m pip install -r "$req" --quiet || true
      echo "  [OK] $req installed."
    fi
  fi
done

# 4. Install 58 Skills to .agents/skills/
echo ""
echo "[4/5] Installing 58 Standard Skills to Local .agents/skills/..."
if (( DRY_RUN )); then
  "$PYTHON_BIN" tools/src/install_skills.py --dry-run
else
  "$PYTHON_BIN" tools/src/install_skills.py
  echo "  [OK] 58 Offensive Skills installed in .agents/skills/."
fi

# 5. Initialize Workspace Blackboard Directories
echo ""
echo "[5/5] Initializing Workspace Runtime Directories..."
if (( ! DRY_RUN )); then
  mkdir -p results/{recon,findings,evidence} report
  echo "  [OK] Runtime directories (results/, report/) ready."
fi

echo ""
echo "================================================================="
echo "  [SUCCESS] DMLab CEH is fully installed and ready for agents!   "
echo "================================================================="
echo "Quick activation:"
echo "  - Linux/macOS: source .venv/bin/activate"
echo "  - Windows:     .venv\\Scripts\\Activate.ps1"
echo "  - Universal:   python install.py (or ./install.sh)"
echo "  - Docs Hub:    docs/ONBOARDING.md | docs/AGENTS.md"
echo "================================================================="
