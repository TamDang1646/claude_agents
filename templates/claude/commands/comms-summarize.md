---
description: Summarize a local .claude/comms session into a compact handoff.
argument-hint: "[.claude/comms/sessions/... path]"
---

Summarize the local communication artifacts in:

$ARGUMENTS

Read `.claude/comms/README.md` and `.claude/team/communication.md`.

Return:

- Session goal
- Agents or teammates involved
- Key decisions
- Findings
- Validation
- Open questions
- Next recommended action

Do not include secrets or unnecessary raw logs.
