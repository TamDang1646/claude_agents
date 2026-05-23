#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_DIR="${1:-$ROOT_DIR/templates/claude}"

die() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || die "missing file: $1"
}

require_dir() {
  [[ -d "$1" ]] || die "missing directory: $1"
}

validate_frontmatter() {
  local file="$1"
  local required_name="$2"

  local first_line
  first_line="$(sed -n '1p' "$file")"
  [[ "$first_line" == "---" ]] || die "$file must start with YAML frontmatter"

  grep -q "^name: $required_name$" "$file" || die "$file missing expected name: $required_name"
  grep -q "^description: " "$file" || die "$file missing description"
  awk 'NR > 1 && $0 == "---" { found = 1; exit } END { exit found ? 0 : 1 }' "$file" || die "$file missing closing frontmatter marker"
}

validate_command() {
  local file="$1"
  local command_name="$2"

  local first_line
  first_line="$(sed -n '1p' "$file")"
  [[ "$first_line" == "---" ]] || die "$file must start with YAML frontmatter"

  grep -q "^description: " "$file" || die "$file missing description"
  awk 'NR > 1 && $0 == "---" { found = 1; exit } END { exit found ? 0 : 1 }' "$file" || die "$file missing closing frontmatter marker"

  case "$command_name" in
    team|plan|research|implement|review|handoff|spawn-team|debate-debug|parallel-review|comms-start|comms-summarize)
      ;;
    *)
      die "unexpected command template: $command_name"
      ;;
  esac
}

require_dir "$BASE_DIR"
require_dir "$BASE_DIR/agents"
require_dir "$BASE_DIR/commands"
require_dir "$BASE_DIR/comms"
require_dir "$BASE_DIR/comms/templates"
require_dir "$BASE_DIR/comms/sessions"
require_dir "$BASE_DIR/rules"
require_dir "$BASE_DIR/team"
require_dir "$BASE_DIR/team/skills"
require_dir "$BASE_DIR/skills"
require_dir "$BASE_DIR/output-styles"
require_dir "$BASE_DIR/hooks"
require_file "$BASE_DIR/settings.json"
require_file "$BASE_DIR/settings.local.example.json"
require_file "$BASE_DIR/statusline.sh"
require_file "$BASE_DIR/comms/README.md"
require_file "$BASE_DIR/comms/.gitignore"
require_file "$BASE_DIR/comms/sessions/.gitkeep"

for agent in planner researcher coder integrator reviewer; do
  validate_frontmatter "$BASE_DIR/agents/$agent.md" "$agent"
done

for command in team plan research implement review handoff spawn-team debate-debug parallel-review comms-start comms-summarize; do
  validate_command "$BASE_DIR/commands/$command.md" "$command"
done

for template in brief result review handoff error task-update index routing current agent-current; do
  require_file "$BASE_DIR/comms/templates/$template.md"
done

for doc in rules workflows contracts communication agent-teams manifest; do
  require_file "$BASE_DIR/team/$doc.md"
done

for skill in repo-context implementation bug-triage code-review research integration docs-sync validation; do
  require_file "$BASE_DIR/team/skills/$skill.md"
done

for rule in 00-agent-team 10-security 20-validation 30-communication; do
  require_file "$BASE_DIR/rules/$rule.md"
done

for skill in team-coordinate repo-context implement debug review research validate docs-sync; do
  require_file "$BASE_DIR/skills/$skill/SKILL.md"
  grep -q "^description: " "$BASE_DIR/skills/$skill/SKILL.md" || die "$BASE_DIR/skills/$skill/SKILL.md missing description"
done

require_file "$BASE_DIR/output-styles/team-coordinator.md"
grep -q "^keep-coding-instructions: true$" "$BASE_DIR/output-styles/team-coordinator.md" || die "team output style must keep coding instructions"

for hook in README.md session-start.sh post-edit-reminder.sh subagent-stop-reminder.sh; do
  require_file "$BASE_DIR/hooks/$hook"
done

if [[ -f "$BASE_DIR/CLAUDE.md" ]]; then
  grep -q '<!-- claude-agents-team:start -->' "$BASE_DIR/CLAUDE.md" || die "CLAUDE.md missing start marker"
  grep -q '<!-- claude-agents-team:end -->' "$BASE_DIR/CLAUDE.md" || die "CLAUDE.md missing end marker"
  require_file "$BASE_DIR/../mcp/.mcp.example.json"
  require_file "$BASE_DIR/../gitignore/claude.append"
elif [[ -f "$BASE_DIR/../CLAUDE.md" ]]; then
  grep -q '<!-- claude-agents-team:start -->' "$BASE_DIR/../CLAUDE.md" || die "installed CLAUDE.md missing start marker"
  grep -q '<!-- claude-agents-team:end -->' "$BASE_DIR/../CLAUDE.md" || die "installed CLAUDE.md missing end marker"
  require_file "$BASE_DIR/../.mcp.example.json"
  require_file "$BASE_DIR/../.gitignore"
  grep -q '# claude-agents-team:start' "$BASE_DIR/../.gitignore" || die "installed .gitignore missing start marker"
  grep -q '# claude-agents-team:end' "$BASE_DIR/../.gitignore" || die "installed .gitignore missing end marker"
else
  die "missing CLAUDE.append.md or installed CLAUDE.md marker block"
fi

printf 'ok: validated %s\n' "$BASE_DIR"
