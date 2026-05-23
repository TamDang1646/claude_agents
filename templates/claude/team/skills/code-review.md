# Skill: Findings-First Code Review

Use this skill when reviewing diffs, PRs, generated code, or implementation output.

## Review Priorities

1. Correctness bugs
2. Security and data exposure
3. Breaking API or compatibility changes
4. Missing tests for risky behavior
5. Operational or deployment risk
6. Maintainability problems that create concrete future risk

## Output

- Findings first, ordered by severity
- File and line reference when available
- Why it matters
- Exact fix suggestion
- Missing validation
- Residual risk

## Rules

- Do not lead with praise or summary when issues exist.
- Do not block on subjective style unless it affects correctness or maintainability.
- Say clearly when no issues are found.
