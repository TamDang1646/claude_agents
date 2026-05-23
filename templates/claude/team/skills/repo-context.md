# Skill: Repository Context Bootstrap

Use this skill before planning, implementing, debugging, or reviewing in an unfamiliar repository.

## Steps

1. List the top-level repository files.
2. Read source-of-truth docs: `README`, `CLAUDE.md`, architecture notes, contribution docs.
3. Read manifests and build files: package manifests, language configs, test configs, lockfiles when relevant.
4. Identify main entrypoints and module boundaries.
5. Find available test, lint, typecheck, build, and dev commands.
6. Map the files likely owned by the requested task.

## Output

- Stack and runtime
- Relevant files
- Known commands
- Ownership boundary
- Assumptions and gaps

## Rules

- Do not assume default commands.
- Prefer `rg` and `rg --files` for discovery.
- Keep discovery scoped to the task when the repo is large.
