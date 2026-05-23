# Agent Team Workflows

Use these workflows to coordinate agents consistently.

## Standard Task Flow

1. Coordinator restates the objective in repository terms.
2. Coordinator reads enough local context to classify the task.
3. Coordinator chooses the smallest useful agent set.
4. Coordinator decides whether local communication artifacts are needed.
5. Coordinator sends a `brief` envelope for every non-trivial delegation.
6. Planner is used first when scope, constraints, or acceptance criteria are unclear.
7. Researcher is used when external evidence or current docs matter.
8. Coder implements repository-local changes.
9. Integrator handles external systems only when needed.
10. Reviewer checks important output before final response.
11. Coordinator uses `handoff`, `review`, or `error` envelopes when chaining or resolving agent output.
12. Coordinator updates local comms artifacts if the workflow uses `.claude/comms/sessions/`, including `00-index.md`, `01-routing.md`, `current.md`, and `by-agent/<agent>/current.md`.
13. Coordinator synthesizes results and resolves conflicts.

## Implementation Flow

1. Inspect repository structure, manifests, docs, relevant files, and tests.
2. Define the technical objective.
3. Make the smallest safe change.
4. Run focused validation.
5. Use reviewer if the change is non-trivial.
6. Finalize with changed files, validation, risks, and next step.

## Research Flow

1. Inspect local project versions and context first.
2. Prefer official docs, specifications, changelogs, and source repositories.
3. Compare sources only when useful.
4. Record dates, versions, and applicability.
5. State confidence and unresolved uncertainty.
6. Use reviewer if the recommendation drives implementation or release decisions.

## Debugging Flow

1. Reproduce or characterize the failure.
2. Identify expected vs actual behavior.
3. Trace ownership through code, config, dependencies, and runtime assumptions.
4. Make one focused fix at a time.
5. Validate with the failing case or nearest available test.
6. Document residual risk.

## Integration Flow

1. Identify target system and action type.
2. Confirm whether the action is read-only or mutating.
3. Check credentials and required permissions.
4. Use stable identifiers for every external object.
5. Confirm result from tool output.
6. Report errors without leaking secrets.

## Review Flow

1. Review the actual changed files or the exact output being finalized.
2. Prioritize correctness, regressions, missing tests, security, compatibility, and unclear assumptions.
3. Put findings first.
4. Include exact fix suggestions.
5. State verdict: `pass`, `revise`, or `fail`.
