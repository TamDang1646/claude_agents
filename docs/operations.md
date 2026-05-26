# Operations Guide

## Install

```sh
scripts/install.sh /path/to/repo
```

## Install Without Cloning

```sh
curl -fsSL https://raw.githubusercontent.com/TamDang1646/claude_agents/main/install.sh | bash -s -- /path/to/repo
```

The bootstrap installer downloads:

```text
https://codeload.github.com/TamDang1646/claude_agents/tar.gz/main
```

Pin a release:

```sh
curl -fsSL https://raw.githubusercontent.com/TamDang1646/claude_agents/main/install.sh | CLAUDE_AGENTS_TEAM_REF=v0.1.0 bash -s -- /path/to/repo
```

## Update

```sh
scripts/install.sh /path/to/repo update
```

## Remove

```sh
scripts/install.sh /path/to/repo remove
```

Remove without cloning:

```sh
curl -fsSL https://raw.githubusercontent.com/TamDang1646/claude_agents/main/install.sh | bash -s -- /path/to/repo remove
```

## Validate Templates

```sh
scripts/validate.sh
```

## Validate Installed Repo

```sh
scripts/validate.sh /path/to/repo/.claude
```

## Full Test Suite

```sh
scripts/test.sh
```

## Recommended Release Checklist

1. Run `scripts/test.sh`.
2. Review `CHANGELOG.md`.
3. Review `docs/compatibility.md`.
4. Install into a real Claude Code test repository.
5. Start Claude Code and confirm:
   - `/team` appears.
   - Project agents are visible.
   - Settings load without warnings.
   - Hooks do not fail.
   - Status line renders.
6. Test one subagent workflow and one comms artifact workflow.
