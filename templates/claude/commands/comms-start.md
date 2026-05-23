---
description: Start a local .claude/comms session for auditable agent-team communication artifacts.
argument-hint: "[task slug or goal]"
allowed-tools: Read, Write, Edit, Bash(mkdir:*), Bash(date:*), Bash(cp:*)
---

Create a local communication artifact session under `.claude/comms/sessions/` for:

$ARGUMENTS

Requirements:

- Use `.claude/comms/README.md`.
- Create a timestamped session directory: `.claude/comms/sessions/YYYYMMDD-HHMMSS-task-slug/`.
- Create subdirectories:
  - `artifacts/briefs`
  - `artifacts/results`
  - `artifacts/reviews`
  - `artifacts/handoffs`
  - `artifacts/errors`
  - `artifacts/tasks`
  - `by-agent/planner`
  - `by-agent/researcher`
  - `by-agent/coder`
  - `by-agent/integrator`
  - `by-agent/reviewer`
  - `by-agent/lead`
- Create `00-index.md` from `.claude/comms/templates/index.md`.
- Create `01-routing.md` from `.claude/comms/templates/routing.md`.
- Create `current.md` from `.claude/comms/templates/current.md`.
- Create `by-agent/<agent>/current.md` from `.claude/comms/templates/agent-current.md` when an agent receives an assignment.
- Do not store secrets.
- Tell the user the session directory path.
