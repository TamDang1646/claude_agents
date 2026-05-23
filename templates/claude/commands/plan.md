---
description: Create an implementation plan with the planner subagent.
argument-hint: "[goal or request]"
---

Use the `planner` subagent to analyze this request:

$ARGUMENTS

The planner must follow `.claude/team/rules.md`, `.claude/team/workflows.md`, `.claude/team/contracts.md`, `.claude/team/communication.md`, and `.claude/team/skills/repo-context.md`.

The plan must use the result envelope from `.claude/team/communication.md` and include objective, current context, assumptions, constraints, subtasks, execution order, acceptance criteria, risks, and open questions. Inspect repository source-of-truth files before planning.
