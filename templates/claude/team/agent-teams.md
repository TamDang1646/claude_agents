# Experimental Agent Teams

Claude Code supports experimental agent teams: multiple independent Claude Code sessions coordinated by a team lead.

Use this only when the task benefits from real teammate-to-teammate communication, parallel investigation, debate, or separate ownership of independent work areas. For focused side tasks, use subagents instead.

## Enablement

This kit enables agent teams through project settings:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

Agent teams require Claude Code v2.1.32 or later. Check with:

```sh
claude --version
```

## Architecture

- Team lead: the main Claude Code session.
- Teammates: independent Claude Code sessions with their own context windows.
- Shared task list: work items teammates claim or complete.
- Mailbox: direct messaging between teammates and the lead.

## When To Use Agent Teams

Use an agent team for:

- Research with competing hypotheses.
- Parallel code review from different perspectives.
- New feature work where each teammate owns separate files or layers.
- Cross-layer work where frontend, backend, tests, and docs can proceed independently.
- Architecture debate where teammates should challenge each other.

Avoid agent teams for:

- Sequential work.
- Same-file edits.
- Small bug fixes.
- Tasks with tight dependency chains.
- Work where token cost matters more than parallelism.

## Spawn Protocol

When creating a team, the lead should specify:

- Team goal.
- Teammate names.
- Teammate role or subagent type.
- Owned files, directories, or layers.
- Shared task list.
- Communication expectations.
- Merge order.
- Review gate.
- Shutdown expectation.

Example:

```text
Create an agent team for this task.
Lead: coordinate and synthesize.
Spawn teammates:
- planner-ux using planner: analyze workflow and user-facing risks.
- implementation-coder using coder: inspect implementation files only, do not edit until plan is accepted.
- reviewer-risk using reviewer: challenge assumptions and review final plan.
Use the shared task list. Have teammates message each other when they find conflicting assumptions. Wait for all teammates before final synthesis.
```

## Teammate Communication

Unlike subagents, teammates can message each other directly. Use direct teammate messages for:

- Sharing findings that affect another teammate's task.
- Challenging an assumption.
- Coordinating file ownership.
- Asking for a focused review.

Use the lead for:

- Team creation.
- Task assignment.
- Dependency coordination.
- Final synthesis.
- Deciding whether work is complete.

## File Ownership

Agent teams do not isolate teammates in separate worktrees by default. To avoid edit conflicts:

- Assign non-overlapping files or directories.
- Prefer read-only exploration until ownership is clear.
- Have the lead approve merge order before edits.
- Use reviewer after combining outputs.

## Known Limitations

- Agent teams are experimental and disabled by default unless enabled in settings or environment.
- One team per session.
- No nested teams.
- The lead cannot be transferred.
- Session resumption may not restore in-process teammates.
- Task status can lag.
- Shutdown can be slow.
- Split panes require tmux or iTerm2; in-process mode works broadly.
