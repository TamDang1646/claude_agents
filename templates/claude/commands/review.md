---
description: Review current work or a specified change with the reviewer subagent.
argument-hint: "[scope, diff, file, or PR context]"
---

Use the `reviewer` subagent to review:

$ARGUMENTS

The reviewer must follow `.claude/team/rules.md`, `.claude/team/workflows.md`, `.claude/team/contracts.md`, `.claude/team/communication.md`, `.claude/team/skills/code-review.md`, and `.claude/team/skills/validation.md`.

Use the review envelope from `.claude/team/communication.md`. Focus on concrete bugs, regressions, missing tests, security or compatibility risk, and repository convention violations. Findings must lead the response. Include exact fix suggestions and remaining validation gaps.
