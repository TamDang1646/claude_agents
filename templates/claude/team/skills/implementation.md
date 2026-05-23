# Skill: Focused Implementation

Use this skill for repository-local feature work, behavior changes, refactors, and fixes.

## Steps

1. Clarify the requested behavior and definition of done.
2. Bootstrap repository context if needed.
3. Inspect existing patterns and nearby tests.
4. Make the smallest coherent change.
5. Add or update tests when risk justifies it.
6. Run focused validation.
7. Ask reviewer to inspect non-trivial changes.

## Rules

- Preserve architecture boundaries.
- Avoid unrelated cleanup.
- Prefer existing helper APIs and local conventions.
- Do not silently change public contracts.
- Update docs when behavior or commands change.
