#!/usr/bin/env bash
# =============================================================================
# DMLab CEH - install_skills.sh
# Install skills dari skills/ ke agent. DEFAULT = LOKAL PROJECT (.agents/),
# tidak pernah global kecuali eksplisit --global. Orang yang clone project ini
# menjalankan ini agar skills terpasang di .agents project-nya sendiri.
#
# Usage:
#   ./tools/src/install_skills.sh                     # install ke .agents lokal project
#   ./tools/src/install_skills.sh --global            # (opsional) ke dir agent global
#   ./tools/src/install_skills.sh --agent opencode    # paksa agent tertentu (global mode)
#   ./tools/src/install_skills.sh --list              # daftar target yang dikenali
#   ./tools/src/install_skills.sh --dir ~/.agents     # target dir kustom
#   ./tools/src/install_skills.sh --only offensive-sqli offensive-xss
#   ./tools/src/install_skills.sh --dry-run
#
# Catatan: .agents/ = kondisi TERINSTALL lokal project dan TIDAK di-commit
# (gitignored). Sumber (skills/) = source of truth yang di-commit.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS_DIR="$PROJECT_ROOT/skills"
HOME_DIR="${HOME:-$USERPROFILE}"

# Default target: LOKAL project. Global HANYA jika --global diberikan.
LOCAL_TARGET="$PROJECT_ROOT/.agents/skills"

detect_global_dirs() {
  # dir skill agent global (hanya dipakai saat --global)
  local dirs=()
  [[ -n "${APPDATA:-}" ]] && dirs+=("$APPDATA/opencode/skills")
  [[ -n "${XDG_CONFIG_HOME:-}" ]] && dirs+=("$XDG_CONFIG_HOME/opencode/skills")
  [[ -d "$HOME_DIR/.config/opencode/skills" ]] && dirs+=("$HOME_DIR/.config/opencode/skills")
  [[ -d "$HOME_DIR/.claude/skills" ]] && dirs+=("$HOME_DIR/.claude/skills")
  [[ -d "$HOME_DIR/.agents/skills" ]] && dirs+=("$HOME_DIR/.agents/skills")
  [[ -d "$HOME_DIR/.codex/skills" ]] && dirs+=("$HOME_DIR/.codex/skills")
  printf '%s\n' "${dirs[@]}"
}

list_targets() {
  echo "Target skill (mode default = lokal project):"
  echo "  - $LOCAL_TARGET  (LOKAL project, .agents/)"
  local g
  g="$(detect_global_dirs)"
  echo "Dir global (hanya dengan --global):"
  if [[ -z "$g" ]]; then
    echo "  (tidak ada agent global terdeteksi)"
  else
    while IFS= read -r d; do echo "  - $d"; done <<< "$g"
  fi
}

install_to() {
  local dest="$1"
  shift
  local selected=("$@")

  if [[ ! -d "$dest" ]]; then
    mkdir -p "$dest"
    echo "  [create] $dest"
  fi

  local src_list=()
  if (( ${#selected[@]} > 0 )); then
    for s in "${selected[@]}"; do
      if [[ -d "$SKILLS_DIR/$s" ]]; then
        src_list+=("$s")
      else
        echo "  [skip] skill '$s' tidak ada"
      fi
    done
  else
    src_list=( "$SKILLS_DIR"/* )
    src_list=( "${src_list[@]##*/}" )
  fi

  local n=0
  for s in "${src_list[@]}"; do
    cp -r "$SKILLS_DIR/$s" "$dest/"
    n=$((n+1))
  done
  echo "  [ok] $n skill -> $dest"
}

DRY_RUN=0
GLOBAL_MODE=0
AGENT_FILTER=""
DEST_DIR=""
ONLY=()

while (( $# > 0 )); do
  case "$1" in
    --global) GLOBAL_MODE=1; shift ;;
    --agent) AGENT_FILTER="$2"; shift 2 ;;
    --dir) DEST_DIR="$2"; shift 2 ;;
    --list) list_targets; exit 0 ;;
    --only) shift; while (( $# > 0 )) && [[ "$1" != --* ]]; do ONLY+=("$1"); shift; done ;;
    --dry-run) DRY_RUN=1; shift ;;
    *) echo "argumen tak dikenal: $1"; exit 1 ;;
  esac
done

echo "=== DMLab CEH : install skills ==="
echo "Sumber : $SKILLS_DIR"

# Target kustom eksplisit menang
if [[ -n "$DEST_DIR" ]]; then
  DEST_DIR="${DEST_DIR/#\~/$HOME_DIR}"
  if (( DRY_RUN )); then
    if (( ${#ONLY[@]} > 0 )); then
      echo "  [dry-run] akan install ${#ONLY[@]} skill -> $DEST_DIR"
    else
      echo "  [dry-run] akan install semua skill -> $DEST_DIR"
    fi
  else
    install_to "$DEST_DIR" "${ONLY[@]}"
  fi
  echo "Selesai."
  exit 0
fi

# Mode default: LOKAL project
if (( GLOBAL_MODE == 0 )); then
  if (( DRY_RUN )); then
    if (( ${#ONLY[@]} > 0 )); then
      echo "  [dry-run] akan install ${#ONLY[@]} skill -> $LOCAL_TARGET (lokal project)"
    else
      echo "  [dry-run] akan install semua skill -> $LOCAL_TARGET (lokal project)"
    fi
  else
    install_to "$LOCAL_TARGET" "${ONLY[@]}"
  fi
  echo "Selesai. Skills terpasang di .agents project ini (tidak menyentuh global)."
  exit 0
fi

# Mode global (eksplisit --global)
TARGETS=( $(detect_global_dirs) )
if [[ -n "$AGENT_FILTER" ]]; then
  FILTERED=()
  for t in "${TARGETS[@]}"; do
    if [[ "$t" == *"$AGENT_FILTER"* ]]; then FILTERED+=("$t"); fi
  done
  TARGETS=( "${FILTERED[@]}" )
fi

if (( ${#TARGETS[@]} == 0 )); then
  echo "Tidak ada target agent global. Pakai --dir <path> untuk target kustom."
  exit 1
fi

N_SKILLS=0
if (( ${#ONLY[@]} > 0 )); then N_SKILLS=${#ONLY[@]}; fi

for t in "${TARGETS[@]}"; do
  if (( DRY_RUN )); then
    if (( N_SKILLS > 0 )); then
      echo "  [dry-run] akan install $N_SKILLS skill -> $t (global)"
    else
      echo "  [dry-run] akan install semua skill -> $t (global)"
    fi
  else
    install_to "$t" "${ONLY[@]}"
  fi
done
echo "Selesai. Skills terpasang global."
