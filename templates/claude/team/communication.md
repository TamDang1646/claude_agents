# Agent Communication Protocol

This protocol defines how the coordinator, subagents, and experimental agent-team teammates communicate inside Claude Code.

Claude Code has two different collaboration modes:

- Subagent mode: subagents do not talk to each other directly. The main Claude Code thread is the communication hub. Cross-agent context is passed through coordinator-mediated briefs, results, reviews, handoffs, and follow-up tasks.
- Experimental agent-team mode: teammates are independent Claude Code sessions with a shared task list and mailbox. Teammates can message each other directly by name. The lead still owns team creation, task coordination, and final synthesis.
- Local artifact mode: coordinator or agents may write brief/result/review/handoff/error/task-update files under `.claude/comms/sessions/` for traceability. These files are records and handoff artifacts, not the runtime message transport.

## Roles

- Coordinator: main Claude Code thread. Owns routing, delegation, synthesis, conflict resolution, and final response.
- Producer agent: subagent that creates a plan, research result, implementation, integration result, or handoff.
- Reviewer agent: subagent that checks producer output.
- Downstream agent: subagent that receives prior output as input for the next step.
- Team lead: main session that creates and coordinates an experimental agent team.
- Teammate: independent Claude Code session in an experimental agent team.

## Message Types

Use these message types when coordinating work:

- `brief`: coordinator instructions to a subagent.
- `status`: short progress or blocker update.
- `result`: completed subagent output.
- `review`: reviewer assessment of another output.
- `handoff`: compact context passed from one stage to another.
- `teammate_message`: direct message between experimental agent-team teammates.
- `task_update`: shared task-list update in experimental agent-team mode.
- `clarification_request`: missing information needed before safe progress.
- `error`: failed action, failed validation, unavailable tool, or blocked external system.

## Coordinator Brief Envelope

Every non-trivial subagent delegation should include:

```text
MESSAGE TYPE: brief
TARGET AGENT: <planner|researcher|coder|integrator|reviewer>
OBJECTIVE: <one clear outcome>
CONTEXT: <relevant repo facts, prior outputs, files, commands, constraints>
INPUTS: <user request, files, diff, links, identifiers, logs>
NON-GOALS: <what not to change or investigate>
REQUIRED DOCS: <team docs or skill playbooks to follow>
OUTPUT CONTRACT: <contract name from .claude/team/contracts.md>
VALIDATION: <expected checks or "explain if not runnable">
DEAD-END RULE: <when to stop and return clarification_request or error>
```

## Subagent Result Envelope

Subagents should return:

```text
MESSAGE TYPE: result
AGENT: <agent name>
STATUS: success | partial | blocked | failed
SUMMARY: <one to three sentences>
OUTPUT: <contract-specific content>
EVIDENCE: <files, commands, sources, tool results, identifiers>
VALIDATION: <checks run or why not run>
RISKS: <remaining risks>
NEXT: <recommended next agent or action>
```

## Review Envelope

Reviewer output should return:

```text
MESSAGE TYPE: review
AGENT: reviewer
STATUS: pass | revise | fail
SUBJECT: <what was reviewed>
FINDINGS: <ordered by severity>
FIXES: <exact suggested corrections>
VALIDATION GAPS: <missing checks>
RESIDUAL RISK: <remaining risk after fixes>
```

## Handoff Envelope

Use handoffs when output from one agent becomes input to another:

```text
MESSAGE TYPE: handoff
FROM: <agent or coordinator>
TO: <agent or coordinator>
GOAL: <why this handoff exists>
KEY CONTEXT: <facts needed by receiver>
ARTIFACTS: <files, commands, sources, identifiers>
DECISIONS: <decisions already made>
OPEN QUESTIONS: <known gaps>
NEXT CONTRACT: <expected receiver output>
```

## Error Envelope

Use errors instead of burying failures in prose:

```text
MESSAGE TYPE: error
AGENT: <agent name>
OPERATION: <what failed>
CAUSE: <known cause or "unknown">
IMPACT: <what cannot be completed>
RECOVERY: <next possible step>
NEEDS USER: yes | no
```

## Communication Rules

- Subagents must not assume other subagents saw their context.
- The coordinator must explicitly pass prior outputs when chaining agents.
- If local artifacts are used, the coordinator must pass exact artifact file paths to downstream agents.
- Teammates in experimental agent teams may message each other directly, but should also keep the shared task list current.
- The coordinator must summarize long outputs before passing them downstream.
- The coordinator must preserve evidence: file paths, commands, sources, identifiers, and validation results.
- If two agents disagree, the coordinator must compare evidence and either resolve the conflict or ask a targeted follow-up.
- Do not delegate a vague request. Convert it into a brief first.
- Do not ask reviewer to review an undefined subject. Provide the exact output, files, diff, or decision.
- Do not present partial or failed subagent output as complete.
- Do not write secrets, tokens, credentials, private keys, or unnecessary raw logs into local comms artifacts.

## Parallel Work

Parallel delegation is allowed only when tasks are independent. If independent workers need to communicate directly, prefer experimental agent-team mode over subagent mode.

Before parallel delegation:

- Define separate objectives.
- Ensure agents do not edit the same files.
- Define merge order.
- Define reviewer scope after merge.

After parallel delegation:

- Compare outputs for contradictions.
- Merge only compatible results.
- Use reviewer for the combined output when user-facing or code-affecting.

## Experimental Agent-Team Messaging

Use this envelope for direct teammate messages:

```text
MESSAGE TYPE: teammate_message
FROM: <teammate name>
TO: <teammate name or lead>
SUBJECT: <short topic>
CONTEXT: <finding, question, or conflict>
EVIDENCE: <files, commands, sources, identifiers>
REQUEST: <what the recipient should do>
URGENCY: low | normal | blocking
```

Use this envelope for shared task-list updates:

```text
MESSAGE TYPE: task_update
AGENT: <lead or teammate name>
TASK: <task title or identifier>
STATE: pending | in_progress | completed | blocked
DEPENDENCIES: <related tasks>
NOTES: <short evidence-backed update>
```

## Conflict Resolution

When outputs conflict:

1. Identify the exact conflicting claims or changes.
2. Compare evidence and validation.
3. Prefer repository source-of-truth over inference.
4. Prefer official/current sources over secondary sources.
5. If unresolved, ask one targeted follow-up or return the uncertainty clearly.

## Status Language

Use these statuses consistently:

- `success`: completed the requested contract.
- `partial`: useful progress, but some requested parts remain.
- `blocked`: cannot proceed without missing information, permission, credential, or tool.
- `failed`: attempted action did not work and needs correction.

## Final Synthesis

The coordinator final answer should not dump every subagent message. It should synthesize:

- What was requested.
- Which agents were used and why, when relevant.
- What was concluded or changed.
- Evidence and validation.
- Remaining risks or blockers.

## Local Artifact Mode

Use local artifacts when traceability matters or when work may continue in another session.

Recommended path:

```text
.claude/comms/sessions/YYYYMMDD-HHMMSS-task-slug/
```

Recommended subdirectories:

```text
artifacts/briefs/
artifacts/results/
artifacts/reviews/
artifacts/handoffs/
artifacts/errors/
artifacts/tasks/
by-agent/<agent>/
```

Rules:

- Start with `.claude/comms/templates/*.md`.
- Maintain `00-index.md`.
- Maintain `01-routing.md`.
- Maintain `current.md` for the active task.
- Maintain `by-agent/<agent>/current.md` for each assigned agent.
- Every local artifact must identify `TARGET AGENT` or `TARGET: coordinator`.
- Every brief must include `LOCAL ARTIFACTS: READ`, `WRITE`, and `UPDATE INDEX`.
- Store concise summaries, not full noisy logs.
- Reference files, commands, sources, and identifiers as evidence.
- Pass artifact paths in later briefs or handoffs.
- Keep `.claude/comms/sessions/` ignored by default unless the user intentionally wants to commit a record.
- Do not make downstream agents scan the whole comms folder. Give exact paths through runtime brief and `by-agent/<agent>/current.md`.
