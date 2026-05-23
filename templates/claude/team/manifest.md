# Claude Agents Team Manifest

This file describes the project-level Claude Code agent team installed in this repository.

## Components

- Primary coordinator memory: `CLAUDE.md`
- Subagents: `.claude/agents/*.md`
- Slash commands: `.claude/commands/*.md`
- Team operating docs: `.claude/team/*.md`
- Skill playbooks: `.claude/team/skills/*.md`
- Official project skills: `.claude/skills/*/SKILL.md`
- Official project rules: `.claude/rules/*.md`
- Project output styles: `.claude/output-styles/*.md`
- Local communication artifacts: `.claude/comms/`
- Project settings and permissions: `.claude/settings.json`
- Local settings example: `.claude/settings.local.example.json`
- Status line script: `.claude/statusline.sh`
- Optional hooks: `.claude/hooks/*`
- Optional project MCP example: `.mcp.example.json`

## Subagents

| Agent | File | Purpose |
| --- | --- | --- |
| planner | `.claude/agents/planner.md` | Scope, assumptions, constraints, acceptance criteria, execution order |
| researcher | `.claude/agents/researcher.md` | Source-backed facts, current docs, standards, dependency/API evidence |
| coder | `.claude/agents/coder.md` | Repository-local code changes, scripts, debugging, tests, validation |
| integrator | `.claude/agents/integrator.md` | MCP, external APIs, credentials, CI, deployment, issue trackers, registries |
| reviewer | `.claude/agents/reviewer.md` | Findings-first review and quality gates |

## Commands

| Command | File | Purpose |
| --- | --- | --- |
| `/team` | `.claude/commands/team.md` | Coordinate the full team |
| `/plan` | `.claude/commands/plan.md` | Force planning workflow |
| `/research` | `.claude/commands/research.md` | Force source-backed research |
| `/implement` | `.claude/commands/implement.md` | Force implementation workflow |
| `/review` | `.claude/commands/review.md` | Force review workflow |
| `/handoff` | `.claude/commands/handoff.md` | Produce continuation summary |
| `/spawn-team` | `.claude/commands/spawn-team.md` | Create experimental agent team |
| `/debate-debug` | `.claude/commands/debate-debug.md` | Debug with competing hypotheses |
| `/parallel-review` | `.claude/commands/parallel-review.md` | Multi-perspective parallel review |
| `/comms-start` | `.claude/commands/comms-start.md` | Create local communication artifact session |
| `/comms-summarize` | `.claude/commands/comms-summarize.md` | Summarize local communication artifacts |

## Communication

Agent communication follows `.claude/team/communication.md`.

- Coordinator to subagent: `brief` envelope.
- Subagent to coordinator: `result`, `review`, `handoff`, `clarification_request`, or `error` envelope.
- Agent-to-agent handoff: coordinator passes summarized output using a `handoff` envelope.
- Experimental agent-team teammate messaging: direct `teammate_message` and shared `task_update` envelopes.
- Local artifact mode: optional files under `.claude/comms/sessions/` for auditable briefs, results, reviews, handoffs, errors, and task updates.
- Conflict resolution: coordinator compares evidence and either resolves, asks a targeted follow-up, or reports uncertainty.

## Operating Model

The main Claude Code thread is the coordinator in subagent mode and the team lead in experimental agent-team mode. It decides whether to answer directly, delegate to subagents, or create a real agent team. Subagents do not communicate directly with each other. Agent-team teammates can communicate directly through Claude Code's team mailbox and shared task list.

## Configuration Notes

- Project subagents take precedence over same-named user subagents.
- Project memory is loaded from `CLAUDE.md`; this team uses imports from `CLAUDE.md` into `.claude/team/*`.
- Project MCP servers should be configured in `.mcp.json`. This kit ships `.mcp.example.json` only, to avoid installing placeholder live MCP servers.
- Hooks are optional. This kit ships hook scripts and documents them, but does not rely on hooks for correctness.
