#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE_DIR="$ROOT_DIR/templates/claude"
TARGET_DIR="${1:-$(pwd)}"
MODE="${2:-install}"

START_MARKER="<!-- claude-agents-team:start -->"
END_MARKER="<!-- claude-agents-team:end -->"
GITIGNORE_START="# claude-agents-team:start"
GITIGNORE_END="# claude-agents-team:end"

usage() {
  cat <<'USAGE'
Usage:
  scripts/install.sh [target-repo] [install|update|remove]

Examples:
  scripts/install.sh /path/to/repo
  scripts/install.sh /path/to/repo update
  scripts/install.sh /path/to/repo remove
USAGE
}

die() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

copy_file() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [[ -f "$dst" ]]; then
    if cmp -s "$src" "$dst"; then
      printf 'unchanged %s\n' "$dst"
      return
    fi

    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    cp "$dst" "$backup"
    printf 'backup %s\n' "$backup"
  fi

  cp "$src" "$dst"
  printf 'write %s\n' "$dst"
}

append_or_replace_claude_block() {
  local target_claude="$TARGET_DIR/CLAUDE.md"
  local block_file="$TEMPLATE_DIR/CLAUDE.md"
  local tmp_file
  tmp_file="$(mktemp)"

  if [[ -f "$target_claude" ]] && grep -q "$START_MARKER" "$target_claude"; then
    awk -v start="$START_MARKER" -v end="$END_MARKER" '
      BEGIN { skipping = 0 }
      index($0, start) { skipping = 1; next }
      index($0, end) { skipping = 0; next }
      !skipping { print }
    ' "$target_claude" > "$tmp_file"
  elif [[ -f "$target_claude" ]]; then
    cp "$target_claude" "$tmp_file"
  else
    : > "$tmp_file"
  fi

  {
    sed -e '${/^$/d;}' "$tmp_file"
    printf '\n\n'
    cat "$block_file"
    printf '\n'
  } > "$target_claude"

  rm -f "$tmp_file"
  printf 'update %s\n' "$target_claude"
}

remove_claude_block() {
  local target_claude="$TARGET_DIR/CLAUDE.md"
  local tmp_file
  tmp_file="$(mktemp)"

  [[ -f "$target_claude" ]] || return 0

  awk -v start="$START_MARKER" -v end="$END_MARKER" '
    BEGIN { skipping = 0 }
    index($0, start) { skipping = 1; next }
    index($0, end) { skipping = 0; next }
    !skipping { print }
  ' "$target_claude" > "$tmp_file"

  mv "$tmp_file" "$target_claude"
  if [[ ! -s "$target_claude" ]] || ! grep -q '[^[:space:]]' "$target_claude"; then
    rm "$target_claude"
    printf 'remove empty %s\n' "$target_claude"
    return 0
  fi
  printf 'remove block %s\n' "$target_claude"
}

append_or_replace_gitignore_block() {
  local target_gitignore="$TARGET_DIR/.gitignore"
  local block_file="$ROOT_DIR/templates/gitignore/claude.append"
  local tmp_file
  tmp_file="$(mktemp)"

  if [[ -f "$target_gitignore" ]] && grep -q "$GITIGNORE_START" "$target_gitignore"; then
    awk -v start="$GITIGNORE_START" -v end="$GITIGNORE_END" '
      BEGIN { skipping = 0 }
      index($0, start) { skipping = 1; next }
      index($0, end) { skipping = 0; next }
      !skipping { print }
    ' "$target_gitignore" > "$tmp_file"
  elif [[ -f "$target_gitignore" ]]; then
    cp "$target_gitignore" "$tmp_file"
  else
    : > "$tmp_file"
  fi

  {
    sed -e '${/^$/d;}' "$tmp_file"
    printf '\n\n'
    cat "$block_file"
    printf '\n'
  } > "$target_gitignore"

  rm -f "$tmp_file"
  printf 'update %s\n' "$target_gitignore"
}

remove_gitignore_block() {
  local target_gitignore="$TARGET_DIR/.gitignore"
  local tmp_file
  tmp_file="$(mktemp)"

  [[ -f "$target_gitignore" ]] || return 0

  awk -v start="$GITIGNORE_START" -v end="$GITIGNORE_END" '
    BEGIN { skipping = 0 }
    index($0, start) { skipping = 1; next }
    index($0, end) { skipping = 0; next }
    !skipping { print }
  ' "$target_gitignore" > "$tmp_file"

  mv "$tmp_file" "$target_gitignore"
  if [[ ! -s "$target_gitignore" ]] || ! grep -q '[^[:space:]]' "$target_gitignore"; then
    rm "$target_gitignore"
    printf 'remove empty %s\n' "$target_gitignore"
    return 0
  fi
  printf 'remove block %s\n' "$target_gitignore"
}

install_files() {
  [[ -d "$TARGET_DIR" ]] || die "target repo does not exist: $TARGET_DIR"
  [[ -d "$TEMPLATE_DIR" ]] || die "template directory missing: $TEMPLATE_DIR"

  for src in "$TEMPLATE_DIR"/agents/*.md; do
    copy_file "$src" "$TARGET_DIR/.claude/agents/$(basename "$src")"
  done

  for src in "$TEMPLATE_DIR"/commands/*.md; do
    copy_file "$src" "$TARGET_DIR/.claude/commands/$(basename "$src")"
  done

  copy_file "$TEMPLATE_DIR/comms/README.md" "$TARGET_DIR/.claude/comms/README.md"
  copy_file "$TEMPLATE_DIR/comms/.gitignore" "$TARGET_DIR/.claude/comms/.gitignore"
  copy_file "$TEMPLATE_DIR/comms/sessions/.gitkeep" "$TARGET_DIR/.claude/comms/sessions/.gitkeep"

  for src in "$TEMPLATE_DIR"/comms/templates/*.md; do
    copy_file "$src" "$TARGET_DIR/.claude/comms/templates/$(basename "$src")"
  done

  for src in "$TEMPLATE_DIR"/team/*.md; do
    copy_file "$src" "$TARGET_DIR/.claude/team/$(basename "$src")"
  done

  for src in "$TEMPLATE_DIR"/team/skills/*.md; do
    copy_file "$src" "$TARGET_DIR/.claude/team/skills/$(basename "$src")"
  done

  for src in "$TEMPLATE_DIR"/rules/*.md; do
    copy_file "$src" "$TARGET_DIR/.claude/rules/$(basename "$src")"
  done

  for src in "$TEMPLATE_DIR"/skills/*/SKILL.md; do
    local skill_name
    skill_name="$(basename "$(dirname "$src")")"
    copy_file "$src" "$TARGET_DIR/.claude/skills/$skill_name/SKILL.md"
  done

  for src in "$TEMPLATE_DIR"/output-styles/*.md; do
    copy_file "$src" "$TARGET_DIR/.claude/output-styles/$(basename "$src")"
  done

  for src in "$TEMPLATE_DIR"/hooks/*; do
    copy_file "$src" "$TARGET_DIR/.claude/hooks/$(basename "$src")"
  done

  copy_file "$TEMPLATE_DIR/settings.json" "$TARGET_DIR/.claude/settings.json"
  copy_file "$TEMPLATE_DIR/settings.local.example.json" "$TARGET_DIR/.claude/settings.local.example.json"
  copy_file "$TEMPLATE_DIR/statusline.sh" "$TARGET_DIR/.claude/statusline.sh"

  copy_file "$ROOT_DIR/templates/mcp/.mcp.example.json" "$TARGET_DIR/.mcp.example.json"

  append_or_replace_claude_block
  append_or_replace_gitignore_block
}

remove_files() {
  [[ -d "$TARGET_DIR" ]] || die "target repo does not exist: $TARGET_DIR"

  for name in planner researcher coder integrator reviewer; do
    local path="$TARGET_DIR/.claude/agents/$name.md"
    if [[ -f "$path" ]]; then
      rm "$path"
      printf 'remove %s\n' "$path"
    fi
  done

  for name in team plan research implement review handoff spawn-team debate-debug parallel-review comms-start comms-summarize; do
    local path="$TARGET_DIR/.claude/commands/$name.md"
    if [[ -f "$path" ]]; then
      rm "$path"
      printf 'remove %s\n' "$path"
    fi
  done

  for name in rules workflows contracts communication agent-teams manifest; do
    local path="$TARGET_DIR/.claude/team/$name.md"
    if [[ -f "$path" ]]; then
      rm "$path"
      printf 'remove %s\n' "$path"
    fi
  done

  for name in repo-context implementation bug-triage code-review research integration docs-sync validation; do
    local path="$TARGET_DIR/.claude/team/skills/$name.md"
    if [[ -f "$path" ]]; then
      rm "$path"
      printf 'remove %s\n' "$path"
    fi
  done

  for name in README.md .gitignore; do
    local path="$TARGET_DIR/.claude/comms/$name"
    if [[ -f "$path" ]]; then
      rm "$path"
      printf 'remove %s\n' "$path"
    fi
  done

  for name in brief result review handoff error task-update index routing current agent-current; do
    local path="$TARGET_DIR/.claude/comms/templates/$name.md"
    if [[ -f "$path" ]]; then
      rm "$path"
      printf 'remove %s\n' "$path"
    fi
  done

  local comms_gitkeep="$TARGET_DIR/.claude/comms/sessions/.gitkeep"
  if [[ -f "$comms_gitkeep" ]]; then
    rm "$comms_gitkeep"
    printf 'remove %s\n' "$comms_gitkeep"
  fi

  for name in 00-agent-team 10-security 20-validation 30-communication; do
    local path="$TARGET_DIR/.claude/rules/$name.md"
    if [[ -f "$path" ]]; then
      rm "$path"
      printf 'remove %s\n' "$path"
    fi
  done

  for name in team-coordinate repo-context implement debug review research validate docs-sync; do
    local path="$TARGET_DIR/.claude/skills/$name/SKILL.md"
    if [[ -f "$path" ]]; then
      rm "$path"
      printf 'remove %s\n' "$path"
    fi
  done

  local output_style="$TARGET_DIR/.claude/output-styles/team-coordinator.md"
  if [[ -f "$output_style" ]]; then
    rm "$output_style"
    printf 'remove %s\n' "$output_style"
  fi

  for name in README.md session-start.sh post-edit-reminder.sh subagent-stop-reminder.sh; do
    local path="$TARGET_DIR/.claude/hooks/$name"
    if [[ -f "$path" ]]; then
      rm "$path"
      printf 'remove %s\n' "$path"
    fi
  done

  local mcp_example="$TARGET_DIR/.mcp.example.json"
  if [[ -f "$mcp_example" ]]; then
    rm "$mcp_example"
    printf 'remove %s\n' "$mcp_example"
  fi

  local settings="$TARGET_DIR/.claude/settings.json"
  if [[ -f "$settings" ]]; then
    rm "$settings"
    printf 'remove %s\n' "$settings"
  fi

  local settings_local_example="$TARGET_DIR/.claude/settings.local.example.json"
  if [[ -f "$settings_local_example" ]]; then
    rm "$settings_local_example"
    printf 'remove %s\n' "$settings_local_example"
  fi

  local statusline="$TARGET_DIR/.claude/statusline.sh"
  if [[ -f "$statusline" ]]; then
    rm "$statusline"
    printf 'remove %s\n' "$statusline"
  fi

  remove_claude_block
  remove_gitignore_block
}

case "$MODE" in
  install|update)
    install_files
    ;;
  remove)
    remove_files
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage
    die "unknown mode: $MODE"
    ;;
esac
