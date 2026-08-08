#!/usr/bin/env python3
"""
DMLab CEH — Automated Project Installer (install.py)
Universal cross-platform bootstrap for developers and AI agents (Windows, Linux, macOS).

Checks and initializes:
  1. Git Submodules (tools/prism, tools/spiderfoot)
  2. Local Python Virtual Environment (.venv/)
  3. Python Dependencies (requirements.txt)
  4. 58 Standardized Skills (.agents/skills/)

Usage:
  python install.py           # Standard local install
  python install.py --force   # Force re-installation of dependencies and skills
  python install.py --dry-run # Preview actions without making changes
"""

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path


def run_cmd(cmd: list[str], cwd: Path | None = None, check: bool = True) -> int:
    try:
        res = subprocess.run(cmd, cwd=cwd, check=check)
        return res.returncode
    except subprocess.CalledProcessError as e:
        print(f"  [ERROR] Command failed: {' '.join(cmd)} (exit code: {e.returncode})", file=sys.stderr)
        return e.returncode
    except FileNotFoundError:
        print(f"  [ERROR] Executable not found: {cmd[0]}", file=sys.stderr)
        return 1


def main() -> int:
    parser = argparse.ArgumentParser(description="DMLab CEH — Automated Workspace Installer")
    parser.add_argument("--force", action="store_true", help="Force re-installation of dependencies and skills")
    parser.add_argument("--dry-run", action="store_true", help="Preview installation actions without executing")
    args = parser.parse_args()

    project_root = Path(__file__).resolve().parent

    print("=================================================================")
    print("        DMLab CEH — Agentic Framework Automated Installer       ")
    print("=================================================================")
    print(f"Workspace Root: {project_root}")

    # 1. Initialize Git Submodules
    print("\n[1/4] Checking Git Submodules (tools/prism, tools/spiderfoot)...")
    prism_marker = project_root / "tools" / "prism" / "cli.py"
    spiderfoot_marker = project_root / "tools" / "spiderfoot" / "sf.py"

    if not prism_marker.exists() or not spiderfoot_marker.exists() or args.force:
        if args.dry_run:
            print("  [dry-run] Would initialize git submodules.")
        else:
            print("  -> Initializing git submodules...")
            run_cmd(["git", "submodule", "update", "--init", "--recursive"], cwd=project_root, check=False)
            print("  [OK] Git submodules initialized.")
    else:
        print("  [OK] Git submodules already present.")

    # 2. Check / Create Local Virtual Environment (.venv/)
    print("\n[2/4] Checking Local Virtual Environment (.venv/)...")
    venv_dir = project_root / ".venv"
    if sys.platform == "win32":
        venv_python = venv_dir / "Scripts" / "python.exe"
    else:
        venv_python = venv_dir / "bin" / "python"

    if venv_dir.exists() and not venv_python.exists():
        print("  [WARN] Incomplete .venv detected. Rebuilding...")
        if not args.dry_run:
            shutil.rmtree(venv_dir, ignore_errors=True)

    if not venv_dir.exists() or args.force:
        if args.dry_run:
            print(f"  [dry-run] Would create virtual environment at {venv_dir}.")
        else:
            print(f"  -> Creating virtual environment at {venv_dir}...")
            run_cmd([sys.executable, "-m", "venv", str(venv_dir)], cwd=project_root)
            print("  [OK] Virtual environment created.")
    else:
        print("  [OK] Local virtual environment (.venv) exists.")

    active_python = str(venv_python) if venv_python.exists() else sys.executable

    # 3. Install Unified Requirements
    print("\n[3/4] Checking Python Dependencies (requirements.txt)...")
    req_file = project_root / "requirements.txt"
    if req_file.exists():
        if args.dry_run:
            print(f"  [dry-run] Would install {req_file} using {active_python}.")
        else:
            print(f"  -> Installing dependencies using {active_python}...")
            run_cmd([active_python, "-m", "pip", "install", "--upgrade", "pip", "--quiet"], cwd=project_root, check=False)
            run_cmd([active_python, "-m", "pip", "install", "-r", str(req_file), "--quiet"], cwd=project_root)
            print("  [OK] Dependencies installed successfully.")
    else:
        print("  [WARN] requirements.txt not found. Skipping dependency installation.")

    # 4. Install 58 Skills to .agents/skills/
    print("\n[4/4] Installing 58 Standard Skills to Local .agents/skills/...")
    skills_installer = project_root / "tools" / "src" / "install_skills.py"
    if skills_installer.exists():
        cmd = [active_python, str(skills_installer)]
        if args.dry_run:
            cmd.append("--dry-run")
        run_cmd(cmd, cwd=project_root)
        print("  [OK] 58 Offensive Skills installed in .agents/skills/.")
    else:
        print(f"  [ERROR] Skill installer not found at {skills_installer}", file=sys.stderr)
        return 1

    print("\n=================================================================")
    print("  [SUCCESS] DMLab CEH is fully installed and ready for agents!   ")
    print("=================================================================")
    print("Quick activation:")
    if sys.platform == "win32":
        print("  - Windows:     .venv\\Scripts\\Activate.ps1 (or activate.bat)")
    else:
        print("  - Linux/macOS: source .venv/bin/activate")
    print("  - Universal:   python install.py (or ./install.sh)")
    print("  - Docs Hub:    docs/ONBOARDING.md | docs/AGENTS.md")
    print("=================================================================")
    return 0


if __name__ == "__main__":
    sys.exit(main())
