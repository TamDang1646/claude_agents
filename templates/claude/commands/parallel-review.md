---
description: Use an experimental agent team or reviewer subagents for parallel review from multiple perspectives.
argument-hint: "[diff, files, PR, or scope]"
---

Review scope: $ARGUMENTS

Choose the execution mode:

- Use reviewer subagent if a single findings-first review is enough.
- Use experimental agent team if independent reviewers should communicate, challenge each other, or cover separate layers.

Suggested perspectives:

- correctness
- security
- compatibility
- tests and validation
- maintainability

Final synthesis must de-duplicate findings, order by severity, and include exact fix suggestions.
