#!/usr/bin/env python3
"""Repository validation checks for DMLab CEH CI.

Checks:
  1. Every skill under skills/*/SKILL.md has YAML frontmatter with a valid
     `name` (matching its folder) and a non-empty `description`.
  2. .gitmodules is consistent with the git index: every declared submodule
     path must exist and be registered as a gitlink (mode 160000) with a
     well-formed upstream URL.
  3. Shell scripts in the repository pass `bash -n` syntax checking.

Exit code 0 on success, 1 on any failure.
"""

import argparse
import configparser
import os
import re
import subprocess
import sys

REPO_ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
)
SKILLS_DIR = os.path.join(REPO_ROOT, "skills")
GITMODULES = os.path.join(REPO_ROOT, ".gitmodules")

FRONTMATTER_RE = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)


def git(args):
    return subprocess.run(
        ["git", "-C", REPO_ROOT] + args,
        capture_output=True,
        text=True,
        check=False,
    )


def check_skill_frontmatter():
    errors = []
    count = 0
    if not os.path.isdir(SKILLS_DIR):
        errors.append(f"skills directory not found: {SKILLS_DIR}")
        return count, errors
    for folder in sorted(os.listdir(SKILLS_DIR)):
        skill_dir = os.path.join(SKILLS_DIR, folder)
        if not os.path.isdir(skill_dir):
            continue
        skill_file = os.path.join(skill_dir, "SKILL.md")
        if not os.path.isfile(skill_file):
            errors.append(f"[{folder}] missing SKILL.md")
            continue
        count += 1
        with open(skill_file, encoding="utf-8") as fh:
            text = fh.read()
        match = FRONTMATTER_RE.match(text)
        if not match:
            errors.append(f"[{folder}] missing YAML frontmatter")
            continue
        block = match.group(1)
        name_match = re.search(r"^name:\s*(\S+)", block, re.MULTILINE)
        if not name_match:
            errors.append(f"[{folder}] frontmatter has no `name`")
        elif name_match.group(1) != folder:
            errors.append(
                f"[{folder}] `name` ({name_match.group(1)}) != folder name"
            )
        desc_match = re.search(
            r'^description:\s*"(.*)"\s*$', block, re.MULTILINE
        )
        if not desc_match:
            errors.append(f"[{folder}] frontmatter `description` not quoted")
        elif not desc_match.group(1).strip():
            errors.append(f"[{folder}] frontmatter `description` is empty")
    return count, errors


def check_gitmodules():
    errors = []
    if not os.path.isfile(GITMODULES):
        errors.append(".gitmodules file not found")
        return errors
    config = configparser.ConfigParser()
    config.read(GITMODULES)
    if not config.sections():
        errors.append(".gitmodules has no submodule sections")
        return errors
    for section in config.sections():
        if not section.startswith("submodule "):
            errors.append(f"invalid section [{section}]")
            continue
        path = config.get(section, "path", fallback=None)
        url = config.get(section, "url", fallback=None)
        if not path:
            errors.append(f"[{section}] missing `path`")
        if not url:
            errors.append(f"[{section}] missing `url`")
        if url and not re.match(r"^https?://", url):
            errors.append(f"[{section}] url is not HTTP(S): {url}")
        if path:
            proc = git(["ls-files", "--stage", "--", path])
            if proc.returncode != 0 or "160000" not in proc.stdout:
                errors.append(
                    f"[{section}] path `{path}` is not registered as a gitlink "
                    "(mode 160000) in the index"
                )
    return errors


def check_shell_syntax():
    errors = []
    proc = git(["ls-files", "*.sh"])
    if proc.returncode != 0:
        errors.append("git ls-files failed")
        return errors
    scripts = proc.stdout.splitlines()
    if not scripts:
        errors.append("no shell scripts tracked in the repository")
        return errors
    for script in scripts:
        full_path = os.path.join(REPO_ROOT, script)
        if not os.path.isfile(full_path):
            continue
        result = subprocess.run(
            ["bash", "-n", full_path], capture_output=True, text=True
        )
        if result.returncode != 0:
            errors.append(
                f"bash -n failed for {script}: {result.stderr.strip()}"
            )
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--skills", action="store_true", help="validate skill frontmatter"
    )
    parser.add_argument(
        "--gitmodules", action="store_true", help="validate .gitmodules"
    )
    parser.add_argument(
        "--shell", action="store_true", help="bash -n all tracked shell scripts"
    )
    args = parser.parse_args()

    if not (args.skills or args.gitmodules or args.shell):
        parser.error("at least one check is required")

    failed = False
    if args.skills:
        count, errors = check_skill_frontmatter()
        print(f"Skills: checked {count} SKILL.md files")
        if errors:
            failed = True
            for e in errors:
                print(f"  ERROR: {e}")
        else:
            print("  OK: all skills have valid frontmatter")
    if args.gitmodules:
        errors = check_gitmodules()
        print("Gitmodules: checked .gitmodules against the index")
        if errors:
            failed = True
            for e in errors:
                print(f"  ERROR: {e}")
        else:
            print("  OK: all submodules registered correctly")
    if args.shell:
        errors = check_shell_syntax()
        print("Shell: bash -n on all tracked shell scripts")
        if errors:
            failed = True
            for e in errors:
                print(f"  ERROR: {e}")
        else:
            print("  OK: all shell scripts pass syntax check")

    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
