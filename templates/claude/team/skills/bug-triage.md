# Skill: Bug Triage

Use this skill when investigating crashes, failing tests, regressions, unexpected behavior, or user-reported bugs.

## Steps

1. Capture the symptom and expected behavior.
2. Reproduce the failure or identify why it cannot be reproduced.
3. Locate the narrowest ownership boundary.
4. Build a hypothesis from code and evidence.
5. Test the hypothesis with focused inspection or a command.
6. Implement the smallest fix.
7. Validate the original failure path.

## Output

- Symptom
- Root cause
- Fix
- Validation
- Remaining risk

## Rules

- Do not patch symptoms without identifying cause.
- Prefer one change at a time.
- Preserve the original test intent.
