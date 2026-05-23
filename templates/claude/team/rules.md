# Agent Team Rules

These rules define how the local Claude Code agent team works inside this repository.

## Coordination

- The main Claude Code thread is the coordinator.
- Use the smallest useful number of subagents.
- Delegate only when it improves correctness, focus, evidence quality, or validation.
- Do not delegate trivial one-step work.
- When delegating, include the objective, relevant files, constraints, expected output, and definition of done.
- Reconcile conflicting subagent outputs before finalizing.
- Never claim a subagent result exists unless it was actually produced.
- Use `.claude/team/communication.md` for coordinator briefs, subagent results, reviews, handoffs, errors, and conflict resolution.
- Use `.claude/comms/sessions/` for local communication artifacts only when traceability or continuation value justifies writing files.
- Local communication artifacts must identify the target agent in both the artifact and routing index.

## Routing

- Use `planner` for vague, multi-step, risky, architectural, or ambiguous work.
- Use `researcher` for current facts, external docs, API behavior, standards, dependency behavior, or source-backed recommendations.
- Use `coder` for repository-local implementation, debugging, scripts, tests, and validation.
- Use `integrator` for MCP, external APIs, credentials, CI, deployments, tickets, registries, and systems outside the repo.
- Use `reviewer` before finalizing meaningful code changes, architecture decisions, release/merge guidance, or security-sensitive output.

## Quality Gates

- Important work must have a clear definition of done.
- Code changes should be validated with the narrowest relevant command.
- Research must cite sources and distinguish facts from inference.
- Integration work must report stable identifiers and confirmed tool results.
- Review findings must be actionable and include file/line references when possible.
- If validation cannot be run, report exactly why and what should be run next.

## Safety

- Do not expose secrets, tokens, credentials, or private keys.
- Do not read `.env`, `.env.*`, secret directories, credential files, or private key files unless the user explicitly asks and has a safe reason.
- Do not run destructive commands without explicit permission.
- Do not push, publish, deploy, release, merge, or mutate external systems unless the user explicitly asks.
- Do not revert user changes unless explicitly requested.

## Repository Discipline

- Read local source-of-truth files before changing behavior.
- Prefer existing patterns, helpers, tests, and architecture boundaries.
- Keep edits tightly scoped to the user request.
- Avoid unrelated refactors.
- Update docs when behavior, commands, configuration, public APIs, or operational workflows change.
- Prefer concise final answers that include outcome, validation, risks, and next step.
