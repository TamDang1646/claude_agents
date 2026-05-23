# Communication Routing

SESSION:

## Routing Table

| ID | Message Type | From | Target Agent | Read Paths | Write Path | Status | Depends On | Next |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

## Rules

- Every artifact must have one target agent or `coordinator`.
- Every brief must specify `READ`, `WRITE`, and `UPDATE INDEX`.
- Every handoff must specify source artifact and target agent.
- Downstream agents should only read files listed in their brief, handoff, or `by-agent/<agent>/current.md` unless the task requires repository inspection.
