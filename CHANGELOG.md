# Changelog

All notable changes to this project are documented here.

## 0.1.0 - 2026-05-23

Initial complete repository-local Claude Code agent team kit.

### Added

- Direct remote installer via root `install.sh`.

### Fixed

- Remote installer now defaults to `TamDang1646/claude_agents` and uses the `codeload.github.com` archive endpoint with clearer 404 troubleshooting.
- Project-level `CLAUDE.md` coordinator charter.
- Claude Code subagents: planner, researcher, coder, integrator, reviewer.
- Slash commands for team coordination, planning, research, implementation, review, handoff, agent teams, parallel review, debugging debate, and local comms.
- Team operating docs: rules, workflows, contracts, communication protocol, manifest, and experimental agent teams guide.
- Local comms artifact system under `.claude/comms`.
- Official project rules under `.claude/rules`.
- Official project skills under `.claude/skills`.
- Project output style and status line.
- Hooks for session start, post-edit validation reminder, and subagent output contract reminder.
- Conservative settings, permissions, environment defaults, and MCP example.
- Installer, remover, validator, and test suite.
