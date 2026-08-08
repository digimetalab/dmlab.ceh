#!/usr/bin/env python3
# =============================================================================
# DMLab CEH - install_skills.py
# Universal Cross-Platform Installer (Windows, Linux, macOS).
# Install skills dari skills/ ke agent target.
# DEFAULT = LOKAL PROJECT (.agents/skills/), tidak pernah global kecuali --global.
#
# Usage:
#   python tools/src/install_skills.py                     # install ke .agents/ lokal
#   python tools/src/install_skills.py --dry-run           # preview rencana copy
#   python tools/src/install_skills.py --only offensive-sqli offensive-xss
#   python tools/src/install_skills.py --dir custom/path   # target kustom
#   python tools/src/install_skills.py --global            # ke agent global
#   python tools/src/install_skills.py --list              # daftar target
# =============================================================================

import argparse
import os
import shutil
import sys
from pathlib import Path


def get_project_root() -> Path:
    script_path = Path(__file__).resolve()
    return script_path.parents[2]


def detect_global_dirs() -> list[Path]:
    dirs = []
    appdata = os.environ.get("APPDATA")
    if appdata:
        dirs.append(Path(appdata) / "opencode" / "skills")

    xdg_config = os.environ.get("XDG_CONFIG_HOME")
    if xdg_config:
        dirs.append(Path(xdg_config) / "opencode" / "skills")

    home = Path.home()
    candidates = [
        home / ".config" / "opencode" / "skills",
        home / ".claude" / "skills",
        home / ".agents" / "skills",
        home / ".codex" / "skills",
    ]
    for c in candidates:
        if c.exists() and c not in dirs:
            dirs.append(c)

    return dirs


def copy_skills(skills_dir: Path, dest_dir: Path, selected_skills: list[str] | None, dry_run: bool) -> int:
    if not dest_dir.exists() and not dry_run:
        dest_dir.mkdir(parents=True, exist_ok=True)
        print(f"  [create] {dest_dir}")

    available_skills = [p.name for p in skills_dir.iterdir() if p.is_dir()]

    if selected_skills:
        to_install = []
        for s in selected_skills:
            if s in available_skills:
                to_install.append(s)
            else:
                print(f"  [skip] skill '{s}' tidak ditemukan di skills/")
    else:
        to_install = sorted(available_skills)

    count = 0
    for skill_name in to_install:
        src = skills_dir / skill_name
        dest = dest_dir / skill_name
        if dry_run:
            count += 1
        else:
            if dest.exists():
                shutil.rmtree(dest)
            shutil.copytree(src, dest)
            count += 1

    return count


def main() -> int:
    parser = argparse.ArgumentParser(
        description="DMLab CEH - Universal Cross-Platform Skills Installer"
    )
    parser.add_argument(
        "--global",
        dest="is_global",
        action="store_true",
        help="Install ke direktori agent global (~/.claude/skills, dsb.)",
    )
    parser.add_argument(
        "--agent",
        type=str,
        default="",
        help="Filter agent tertentu saat mode global (contoh: opencode, claude)",
    )
    parser.add_argument(
        "--dir",
        type=str,
        default="",
        help="Target direktori kustom untuk instalasi skill",
    )
    parser.add_argument(
        "--only",
        nargs="+",
        help="Hanya install subset skill tertentu (contoh: --only offensive-sqli offensive-xss)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Simulasi instalasi tanpa menyalin file",
    )
    parser.add_argument(
        "--list",
        action="store_true",
        help="Tampilkan daftar target instalasi yang dikenali",
    )

    args = parser.parse_args()

    project_root = get_project_root()
    skills_dir = project_root / "skills"
    local_target = project_root / ".agents" / "skills"

    if not skills_dir.exists():
        print(f"Error: Direktori skills tidak ditemukan di {skills_dir}", file=sys.stderr)
        return 1

    if args.list:
        print("Target skill (mode default = lokal project):")
        print(f"  - {local_target} (LOKAL project, .agents/)")
        global_dirs = detect_global_dirs()
        print("\nDirektori global terdeteksi (hanya aktif dengan --global):")
        if not global_dirs:
            print("  (tidak ada agent global yang terdeteksi)")
        else:
            for g in global_dirs:
                print(f"  - {g}")
        return 0

    print("=== DMLab CEH : Skills Installer ===")
    print(f"Sumber  : {skills_dir}")

    # Mode Kustom
    if args.dir:
        dest = Path(os.path.expanduser(args.dir)).resolve()
        if args.dry_run:
            count = len(args.only) if args.only else len(list(skills_dir.iterdir()))
            print(f"  [dry-run] akan install {count} skill -> {dest}")
        else:
            count = copy_skills(skills_dir, dest, args.only, dry_run=False)
            print(f"  [ok] {count} skill -> {dest}")
        print("Selesai.")
        return 0

    # Mode Default: LOKAL project
    if not args.is_global:
        if args.dry_run:
            count = len(args.only) if args.only else len(list(skills_dir.iterdir()))
            print(f"  [dry-run] akan install {count} skill -> {local_target} (lokal project)")
        else:
            count = copy_skills(skills_dir, local_target, args.only, dry_run=False)
            print(f"  [ok] {count} skill -> {local_target}")
        print("Selesai. Skills terpasang di .agents project ini (tidak menyentuh global).")
        return 0

    # Mode Global
    global_targets = detect_global_dirs()
    if args.agent:
        global_targets = [t for t in global_targets if args.agent.lower() in str(t).lower()]

    if not global_targets:
        print("Tidak ada target agent global yang ditemukan. Gunakan --dir <path> untuk path kustom.")
        return 1

    for t in global_targets:
        if args.dry_run:
            count = len(args.only) if args.only else len(list(skills_dir.iterdir()))
            print(f"  [dry-run] akan install {count} skill -> {t} (global)")
        else:
            count = copy_skills(skills_dir, t, args.only, dry_run=False)
            print(f"  [ok] {count} skill -> {t}")

    print("Selesai. Skills terpasang global.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
