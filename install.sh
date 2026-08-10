#!/usr/bin/env bash
# =============================================================================
# DMLab CEH — Automated Project Installer (install.sh)
# Thin POSIX wrapper around the universal cross-platform installer (install.py).
#
# All installation logic (submodules, venv, dependencies, skills, runtime dirs)
# and all flags (--check, --latest, --force, --dry-run) live in install.py.
# This script only locates a Python interpreter and forwards every argument.
#
# Usage:
#   ./install.sh            # Standard local install
#   ./install.sh --check    # Fast pre-flight verification (0 ready / 1 incomplete)
#   ./install.sh --latest   # Sync submodules to latest upstream commits & install
#   ./install.sh --force    # Force re-installation of dependencies and skills
#   ./install.sh --dry-run  # Preview actions without making changes
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Locate a Python interpreter
PYTHON_BIN=""
if command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN="python"
elif command -v py >/dev/null 2>&1; then
  PYTHON_BIN="py"
else
  echo "[ERROR] Python interpreter not found! Please install Python 3.8+." >&2
  exit 1
fi

exec "$PYTHON_BIN" "$SCRIPT_DIR/install.py" "$@"
