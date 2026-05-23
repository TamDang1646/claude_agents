---
description: Coordinate the local Claude agent team for a complex repository task.
argument-hint: "[task]"
---

Task: $ARGUMENTS

Act as the coordinator for this repository's Claude agent team.

Follow the installed team operating docs:

- `.claude/team/rules.md`
- `.claude/team/workflows.md`
- `.claude/team/contracts.md`
- `.claude/team/communication.md`
- `.claude/team/skills/*.md`

Use the smallest useful set of subagents:

- Use `planner` when the task is unclear, multi-step, risky, or needs acceptance criteria.
- Use `researcher` when facts, current docs, external APIs, standards, dependency behavior, or source-backed claims are needed.
- Use `coder` when files need to be read, edited, debugged, generated, tested, or validated.
- Use `integrator` when MCP servers, external services, credentials, CI, deployment, issue trackers, package registries, or other outside systems are involved.
- Use `reviewer` before finalizing meaningful code changes, research summaries, decisions, or release/merge-ready output.

Workflow:

1. Restate the objective in repository-specific terms.
2. Inspect enough local context before choosing agents.
3. Delegate only when it improves correctness, speed, or context isolation.
4. Use the coordinator brief envelope from `.claude/team/communication.md` for every non-trivial delegation.
5. Use handoff envelopes when chaining one agent's output into another agent.
6. Reconcile contradictions before finalizing.
7. Apply the relevant quality gate from `.claude/team/skills/validation.md`.
8. End with the coordinator final contract from `.claude/team/contracts.md`.

Do not use subagents for trivial requests that can be handled directly.
