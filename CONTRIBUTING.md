# Contributing

## Development Principles

- Keep this kit repository-local. Do not introduce a daemon, backend service, or external database.
- Prefer official Claude Code project-level extension points.
- Keep templates explicit and auditable.
- Avoid installing live external integrations by default.
- Treat experimental features as optional and documented.

## Validate Before Submitting

Run:

```sh
scripts/test.sh
```

At minimum, this checks:

- Shell syntax.
- JSON validity.
- Template structure.
- Install/update/remove behavior.
- Marker idempotency.

## Template Rules

- Agent files must include YAML frontmatter with `name` and `description`.
- Command files must include YAML frontmatter with `description`.
- `CLAUDE.md` must keep the `claude-agents-team` markers.
- Local comms templates must include routing metadata where relevant.
- Settings must remain valid JSON.

## Compatibility

Claude Code features can evolve. When updating official feature usage, update:

- `docs/compatibility.md`
- `README.md`
- `scripts/validate.sh`
- `scripts/test.sh`
