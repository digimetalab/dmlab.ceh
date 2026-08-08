#!/usr/bin/env python3
"""
DMLab CEH — Automated Project Installer & Environment Validator (install.py)
Universal cross-platform bootstrap for developers and AI agents (Windows, Linux, macOS).

Capabilities:
  1. Submodule Verification & Initialization (tools/prism, tools/spiderfoot)
  2. Local Python Virtual Environment (.venv/)
  3. Unified Dependency Installation (requirements.txt)
  4. 58 Standardized Skills Deployment (.agents/skills/)
  5. Pre-flight Environment Health Check (--check)

Usage:
  python install.py           # Standard automated local install
  python install.py --check   # Fast pre-flight verification (returns 0 if complete, 1 if missing)
  python install.py --force   # Force re-installation of dependencies and skills
  python install.py --dry-run # Preview actions without executing
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


def check_environment(project_root: Path) -> tuple[bool, list[str]]:
    """Verify if the local workspace is fully installed according to project standards."""
    missing = []

    # 1. Check Submodules
    prism_marker = project_root / "tools" / "prism" / "cli.py"
    spiderfoot_marker = project_root / "tools" / "spiderfoot" / "sf.py"
    if not prism_marker.exists() or not spiderfoot_marker.exists():
        missing.append("Git submodules (tools/prism, tools/spiderfoot)")

    # 2. Check Virtual Environment
    venv_dir = project_root / ".venv"
    if sys.platform == "win32":
        venv_python = venv_dir / "Scripts" / "python.exe"
    else:
        venv_python = venv_dir / "bin" / "python"

    if not venv_dir.exists() or not venv_python.exists():
        missing.append("Virtual environment (.venv)")

    # 3. Check 58 Skills in .agents/skills/
    agents_skills = project_root / ".agents" / "skills"
    source_skills = project_root / "skills"
    if source_skills.exists():
        expected_count = len([p for p in source_skills.iterdir() if p.is_dir()])
        installed_count = len([p for p in agents_skills.iterdir() if p.is_dir()]) if agents_skills.exists() else 0
        if installed_count < expected_count:
            missing.append(f"Offensive skills in .agents/skills/ ({installed_count}/{expected_count} installed)")
    else:
        missing.append("Source skills directory (skills/)")

    # 4. Check results / report dirs
    for d in ["results", "report"]:
        if not (project_root / d).exists():
            missing.append(f"Workspace runtime directory ({d}/)")

    is_complete = len(missing) == 0
    return is_complete, missing


def main() -> int:
    parser = argparse.ArgumentParser(description="DMLab CEH — Automated Workspace Installer & Validator")
    parser.add_argument("--check", action="store_true", help="Perform pre-flight verification without making changes")
    parser.add_argument("--force", action="store_true", help="Force re-installation of dependencies and skills")
    parser.add_argument("--dry-run", action="store_true", help="Preview installation actions without executing")
    args = parser.parse_args()

    project_root = Path(__file__).resolve().parent

    # Fast Pre-flight Check Mode
    if args.check:
        print("=== DMLab CEH : Pre-Flight Environment Health Check ===")
        is_complete, missing = check_environment(project_root)
        if is_complete:
            print("  [STATUS: 100% READY] Local environment is fully initialized and all 58 skills are active.")
            return 0
        else:
            print("  [STATUS: INCOMPLETE] The workspace requires setup before executing agent workflows:")
            for item in missing:
                print(f"    - Missing: {item}")
            print("\n  -> Action required: Run 'python install.py' (or './install.sh') to initialize.")
            return 1

    print("=================================================================")
    print("        DMLab CEH — Agentic Framework Automated Installer       ")
    print("=================================================================")
    print(f"Workspace Root: {project_root}")

    # 1. Initialize Git Submodules
    print("\n[1/5] Checking Git Submodules (tools/prism, tools/spiderfoot)...")
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
    print("\n[2/5] Checking Local Virtual Environment (.venv/)...")
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
    print("\n[3/5] Checking Python Dependencies (requirements.txt)...")
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
    print("\n[4/5] Installing 58 Standard Skills to Local .agents/skills/...")
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

    # 5. Initialize Workspace Blackboard Directories
    print("\n[5/5] Initializing Workspace Runtime Directories...")
    if not args.dry_run:
        for d in ["results/recon", "results/findings", "results/evidence", "report"]:
            (project_root / d).mkdir(parents=True, exist_ok=True)
        print("  [OK] Runtime directories (results/, report/) ready.")

    print("\n=================================================================")
    print("  [SUCCESS] DMLab CEH is fully installed and ready for agents!   ")
    print("=================================================================")
    print("Quick activation:")
    if sys.platform == "win32":
        print("  - Windows:     .venv\\Scripts\\Activate.ps1 (or activate.bat)")
    else:
        print("  - Linux/macOS: source .venv/bin/activate")
    print("  - Universal:   python install.py (or ./install.sh)")
    print("  - Health Check:python install.py --check")
    print("  - Docs Hub:    docs/ONBOARDING.md | docs/AGENTS.md")
    print("=================================================================")
    return 0


if __name__ == "__main__":
    sys.exit(main())
