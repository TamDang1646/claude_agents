# Local Communication Artifacts

This directory stores optional local communication artifacts for the Claude agent team.

These files are not the runtime transport for Claude Code subagents or experimental agent teams. Runtime messages are still delivered by Claude Code. This directory is for auditable local records that agents can read and write when the coordinator decides traceability matters.

## Recommended Layout

```text
.claude/comms/
  templates/
    brief.md
    result.md
    review.md
    handoff.md
    error.md
    task-update.md
  sessions/
    YYYYMMDD-HHMMSS-task-slug/
      00-index.md
      01-routing.md
      current.md
      by-agent/
        planner/
        researcher/
        coder/
        integrator/
        reviewer/
        lead/
      artifacts/
        briefs/
        results/
        reviews/
        handoffs/
        errors/
        tasks/
```

## When To Write Local Artifacts

Write local communication artifacts when:

- The task spans multiple agents or teammates.
- The work may continue in a later Claude session.
- The user asks for traceability.
- A handoff between agents contains important decisions.
- There are conflicting findings that need an audit trail.
- The work is high risk: security, release, migration, data, external systems.

Skip local artifacts when:

- The request is simple.
- The record would duplicate a short final answer.
- The user asks not to write files.

## Naming

Use stable, sortable names:

```text
artifacts/briefs/001-to-planner-scope.md
artifacts/results/002-from-planner-result.md
artifacts/handoffs/003-planner-to-coder.md
artifacts/results/004-from-coder-result.md
artifacts/reviews/005-from-reviewer-code-review.md
artifacts/errors/006-from-coder-validation-error.md
```

Also create or update an agent-facing pointer file when an artifact is meant for a specific agent:

```text
by-agent/coder/current.md
```

The pointer file should tell that agent exactly what to read, what to write, and what index entries to update.

## Session Index

Each local comms session should include `00-index.md` with:

- User request
- Session goal
- Agents or teammates used
- Artifact list
- Current status
- Final outcome

Each session should include `01-routing.md` with:

- Artifact ID
- Message type
- From
- Target agent
- Path
- Status
- Depends on
- Next expected artifact

Each active delegated task should update `current.md` and `by-agent/<agent>/current.md`.

## Git Policy

By default, `.claude/comms/sessions/` is ignored by `.claude/comms/.gitignore` because it may contain transient findings, local paths, or implementation details. Commit specific session artifacts only when the team intentionally wants them as project records.
