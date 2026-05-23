---
description: Use an experimental agent team to debug with competing hypotheses.
argument-hint: "[bug, symptom, or failing test]"
---

Bug or symptom: $ARGUMENTS

Create an experimental agent team only if multiple independent hypotheses can be tested in parallel.

Use `.claude/team/agent-teams.md` and `.claude/team/communication.md`.

Suggested teammates:

- `hypothesis-a`: investigate one plausible root cause.
- `hypothesis-b`: investigate a competing root cause.
- `evidence-reviewer`: challenge both hypotheses and check validation.

Require teammates to share findings and attempt to disprove each other's conclusions. Final synthesis must include root cause, evidence, fix path, validation, and residual risk.
