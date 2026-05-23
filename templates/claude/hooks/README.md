# Claude Code Hooks

This directory contains optional hook scripts for repositories that want extra enforcement.

Hooks are configured through `.claude/settings.json`. The default kit keeps hooks conservative because hooks execute local commands and should be reviewed per repository.

Recommended hook uses:

- `SessionStart`: print a short reminder that the agent team is active.
- `PostToolUse` for `Write|Edit|MultiEdit`: remind Claude to run validation when files change.
- `SubagentStop`: remind the coordinator to check output contracts.

Enable hooks only after reviewing the scripts and confirming they fit the repository.
