# Skill: Validation Gate

Use this skill before considering implementation, migration, refactor, or release guidance complete.

## Validation Options

- Unit tests for changed logic
- Integration tests for cross-boundary behavior
- Typecheck for typed codebases
- Lint for style and common defects
- Build for packaging/runtime issues
- Smoke test for user-facing flows

## Rules

- Run the narrowest command that proves the change.
- Broaden validation when shared behavior or public contracts changed.
- If validation is impossible, explain the blocker and provide the exact command the user should run.
- Do not claim unrun validation passed.
