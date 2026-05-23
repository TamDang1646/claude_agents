# Local Comms Example

This example shows how local communication artifacts should route work to a specific agent.

## Session

```text
.claude/comms/sessions/20260523-101500-auth-refactor/
  00-index.md
  01-routing.md
  current.md
  by-agent/coder/current.md
  artifacts/handoffs/003-planner-to-coder.md
```

## Routing Entry

```md
| ID | Message Type | From | Target Agent | Read Paths | Write Path | Status | Depends On | Next |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 003 | handoff | planner | coder | artifacts/results/002-from-planner-result.md | artifacts/results/004-from-coder-result.md | pending | 002 | reviewer |
```

## Agent Pointer

```md
# Current Agent Input

SESSION: 20260523-101500-auth-refactor
TARGET AGENT: coder
ASSIGNED BY: coordinator
STATUS: pending

## Read First

- ../../artifacts/handoffs/003-planner-to-coder.md

## Objective

Implement step 1 from the planner handoff.

## Write Result To

- ../../artifacts/results/004-from-coder-result.md
```

## Runtime Brief

The coordinator should still pass the exact pointer path to the subagent:

```text
Read first:
.claude/comms/sessions/20260523-101500-auth-refactor/by-agent/coder/current.md
```
