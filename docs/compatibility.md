# Compatibility

This kit targets project-level Claude Code configuration.

## Required Baseline

- Claude Code with support for:
  - `CLAUDE.md` project memory
  - `.claude/agents`
  - `.claude/commands`
  - `.claude/settings.json`
- Shell environment with `bash`, `tar`, and either `curl` or `wget` for direct remote install.

## Optional Features

Some installed files use newer or optional Claude Code features:

- `.claude/skills`: project skills.
- `.claude/rules`: project rules.
- `.claude/output-styles`: custom output styles.
- `statusLine`: custom status line.
- `hooks`: lifecycle hooks.
- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`: experimental agent teams.
- `.mcp.json`: project-scoped MCP servers.

If a Claude Code version does not support an optional feature, the file remains harmless project configuration but the feature may not activate.

## Experimental Agent Teams

Agent teams are experimental. Use `/spawn-team`, `/debate-debug`, or `/parallel-review` only when direct teammate communication or independent parallel ownership is useful.

Known constraints documented in this kit:

- One team per session.
- No nested teams.
- Team lead owns final synthesis.
- Teammates can message each other directly.
- Session resumption may not restore active teammates.
- File ownership must be explicit to avoid conflicts.

## MCP

The kit installs `.mcp.example.json`, not `.mcp.json`.

To enable MCP:

1. Copy `.mcp.example.json` to `.mcp.json`.
2. Replace placeholder URLs with real reviewed MCP servers.
3. Configure `enabledMcpjsonServers` or project settings as needed.
4. Do not commit secrets.
