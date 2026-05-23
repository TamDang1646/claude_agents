#!/usr/bin/env sh
set -eu

input="$(cat)"

project="$(printf '%s' "$input" | sed -n 's/.*"project_dir"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | awk -F/ '{print $NF}' | head -n 1)"
model="$(printf '%s' "$input" | sed -n 's/.*"display_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"
context="$(printf '%s' "$input" | sed -n 's/.*"used_percentage"[[:space:]]*:[[:space:]]*\([0-9.]*\).*/\1/p' | cut -d. -f1 | head -n 1)"

project="${project:-project}"
model="${model:-Claude}"
context="${context:-0}"

printf '[%s] %s | team:%s | ctx:%s%%\n' "$model" "$project" "${CLAUDE_AGENTS_TEAM:-enabled}" "$context"
