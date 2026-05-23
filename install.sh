#!/usr/bin/env bash
set -euo pipefail

REPO="${CLAUDE_AGENTS_TEAM_REPO:-TamDang1646/claude-agents-team-kit}"
REF="${CLAUDE_AGENTS_TEAM_REF:-main}"
TARGET_DIR="${1:-$(pwd)}"
MODE="${2:-install}"

usage() {
  cat <<'USAGE'
Usage:
  install.sh [target-repo] [install|update|remove]

Environment:
  CLAUDE_AGENTS_TEAM_REPO   GitHub repo in owner/name form.
  CLAUDE_AGENTS_TEAM_REF    Branch, tag, or commit to install from.

Examples:
  curl -fsSL https://raw.githubusercontent.com/TamDang1646/claude-agents-team-kit/main/install.sh | bash
  curl -fsSL https://raw.githubusercontent.com/TamDang1646/claude-agents-team-kit/main/install.sh | bash -s -- /path/to/repo
  CLAUDE_AGENTS_TEAM_REF=v0.1.0 bash install.sh /path/to/repo
USAGE
}

die() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

download() {
  local url="$1"
  local dest="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$dest"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$url"
  else
    die "curl or wget is required"
  fi
}

case "$TARGET_DIR" in
  -h|--help|help)
    usage
    exit 0
    ;;
esac

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ARCHIVE="$TMP_DIR/source.tar.gz"
URL="https://github.com/$REPO/archive/$REF.tar.gz"

printf 'Downloading %s@%s\n' "$REPO" "$REF"
download "$URL" "$ARCHIVE"

tar -xzf "$ARCHIVE" -C "$TMP_DIR"
SOURCE_DIR="$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
[[ -n "$SOURCE_DIR" ]] || die "downloaded archive did not contain a source directory"

"$SOURCE_DIR/scripts/install.sh" "$TARGET_DIR" "$MODE"
