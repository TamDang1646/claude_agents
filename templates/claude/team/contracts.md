# Agent Output Contracts

Subagents should return structured outputs so the coordinator can merge results without ambiguity.

## Planner Contract

- Objective
- Current context
- Assumptions
- Constraints
- Subtasks
- Recommended execution order
- Acceptance criteria
- Risks and open questions

## Researcher Contract

- Key findings
- Sources used
- Confidence level
- Applicability to this repository
- Conflicts or uncertainty
- Recommendation

## Coder Contract

- Files changed
- Key logic
- Commands run
- Validation result
- Risks
- Next validation step

## Integrator Contract

- Action performed
- Target system
- Inputs or identifiers
- Result
- Errors or blockers
- Follow-up needed

## Reviewer Contract

- Verdict: `pass` | `revise` | `fail`
- Findings
- Severity
- Exact fix suggestions
- Missing validation
- Residual risk

## Coordinator Final Contract

- Outcome
- What changed or what was decided
- Validation performed
- Remaining risks or blockers
- Next recommended action
