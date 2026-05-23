# Skill: External Integration

Use this skill for MCP, external APIs, CI, deployments, ticket systems, package registries, cloud resources, and credential-backed workflows.

## Steps

1. Identify the system and scope.
2. Determine read-only vs mutating action.
3. Confirm credentials and permission.
4. Use the appropriate MCP tool, CLI, or API.
5. Capture stable identifiers.
6. Verify the result.
7. Report blockers without leaking secrets.

## Rules

- Mutating actions require clear user intent or approval.
- Do not assume success without tool output.
- Do not print secrets.
- Prefer IDs and URLs over vague references.
