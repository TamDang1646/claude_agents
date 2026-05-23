#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d /private/tmp/claude-agents-test.XXXXXX)"
TARGET="$TEST_ROOT/target-repo"

cleanup() {
  rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

die() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || die "missing file: $1"
}

require_absent_files() {
  local files
  files="$(find "$1" -type f | sort)"
  [[ -z "$files" ]] || die "expected no files after remove, found: $files"
}

printf '== shell syntax ==\n'
bash -n "$ROOT_DIR/scripts/install.sh"
bash -n "$ROOT_DIR/scripts/validate.sh"
bash -n "$ROOT_DIR/scripts/test.sh"
sh -n "$ROOT_DIR/templates/claude/statusline.sh"

printf '== json ==\n'
python3 -m json.tool "$ROOT_DIR/templates/claude/settings.json" >/dev/null
python3 -m json.tool "$ROOT_DIR/templates/claude/settings.local.example.json" >/dev/null
python3 -m json.tool "$ROOT_DIR/templates/mcp/.mcp.example.json" >/dev/null

printf '== template validate ==\n'
"$ROOT_DIR/scripts/validate.sh"

printf '== install ==\n'
mkdir -p "$TARGET"
"$ROOT_DIR/scripts/install.sh" "$TARGET" >/dev/null
"$ROOT_DIR/scripts/validate.sh" "$TARGET/.claude"

require_file "$TARGET/CLAUDE.md"
require_file "$TARGET/.gitignore"
require_file "$TARGET/.mcp.example.json"
require_file "$TARGET/.claude/settings.json"
require_file "$TARGET/.claude/comms/templates/agent-current.md"
require_file "$TARGET/.claude/commands/spawn-team.md"
require_file "$TARGET/.claude/skills/team-coordinate/SKILL.md"

grep -q '<!-- claude-agents-team:start -->' "$TARGET/CLAUDE.md" || die "CLAUDE.md marker missing"
grep -q '# claude-agents-team:start' "$TARGET/.gitignore" || die ".gitignore marker missing"
grep -q 'TARGET AGENT:' "$TARGET/.claude/comms/templates/brief.md" || die "brief target missing"
grep -q 'CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS' "$TARGET/.claude/settings.json" || die "agent teams env missing"

printf '== update idempotency ==\n'
"$ROOT_DIR/scripts/install.sh" "$TARGET" update >/dev/null
[[ "$(grep -c 'claude-agents-team:start' "$TARGET/CLAUDE.md")" == "1" ]] || die "CLAUDE marker duplicated"
[[ "$(grep -c 'claude-agents-team:start' "$TARGET/.gitignore")" == "1" ]] || die "gitignore marker duplicated"

printf '== remove ==\n'
"$ROOT_DIR/scripts/install.sh" "$TARGET" remove >/dev/null
require_absent_files "$TARGET"

printf 'ok: full test suite passed\n'
