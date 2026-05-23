---
description: Create an experimental Claude Code agent team for parallel work with direct teammate communication.
argument-hint: "[team goal and teammate roles]"
---

Task: $ARGUMENTS

Use experimental Claude Code agent teams only if this task benefits from direct teammate communication, shared task coordination, or independent parallel work.

Read:

- `.claude/team/agent-teams.md`
- `.claude/team/communication.md`
- `.claude/team/contracts.md`

If agent teams are appropriate:

1. State why subagents are insufficient.
2. Define teammate names and role/subagent type.
3. Define task ownership and file boundaries.
4. Create a shared task list with dependencies.
5. Require teammates to message each other about conflicts.
6. Wait for teammate completion before final synthesis.
7. Run reviewer or review gate on the combined result.

If agent teams are not appropriate, use `/team` style coordination with subagents instead.
