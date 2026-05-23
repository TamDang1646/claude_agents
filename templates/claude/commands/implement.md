---
description: Implement a focused repository change with validation.
argument-hint: "[change request]"
---

Use the `coder` subagent to implement this request:

$ARGUMENTS

The coder must follow `.claude/team/rules.md`, `.claude/team/workflows.md`, `.claude/team/contracts.md`, `.claude/team/communication.md`, and the relevant files in `.claude/team/skills/`.

Requirements:

- Inspect relevant repository context before editing.
- Keep the change scoped to the request.
- Preserve existing patterns.
- Run the narrowest relevant validation command when practical.
- Report using the result envelope from `.claude/team/communication.md`, including files changed, key logic, validation, risks, and next step.
- Ask for permission before destructive actions.
