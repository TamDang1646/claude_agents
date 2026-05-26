# Claude Agents Team Kit

Project-level Claude Code agent team templates that can be installed into any repository.

This kit does not run a backend service and does not use Claude Managed Agents API. It installs Claude Code configuration files into a target repository:

- `.claude/agents/*.md` for project subagents
- `.claude/commands/*.md` for slash commands
- `.claude/team/*.md` for shared team rules, workflows, and output contracts
- `.claude/team/skills/*.md` for repository-local skill playbooks
- `.claude/rules/*.md` for official Claude Code project rules
- `.claude/skills/*/SKILL.md` for official project skills
- `.claude/output-styles/*.md` for project output styles
- `.claude/comms/` for optional local communication artifacts
- `.claude/hooks/*` for optional Claude Code hook scripts
- `.claude/settings.json` for project settings
- `.claude/settings.local.example.json` for personal local overrides
- `.claude/statusline.sh` for a project status line
- `.mcp.example.json` as a safe project MCP example
- `CLAUDE.md` as the primary coordinator charter, guarded by markers

## Documentation

- [Feature map](docs/feature-map.md)
- [Compatibility](docs/compatibility.md)
- [Operations](docs/operations.md)
- [Local comms example](docs/local-comms-example.md)
- [Security](SECURITY.md)
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

## Included Agents

- `planner`: breaks down vague or multi-step work into an executable plan.
- `researcher`: verifies external facts, docs, APIs, standards, and source-backed recommendations.
- `coder`: reads, edits, debugs, scripts, tests, and validates repository-local changes.
- `integrator`: works with MCP servers, external APIs, credentials, CI, deployments, registries, and other outside systems.
- `reviewer`: checks meaningful output for bugs, regressions, missing tests, security risk, and decision risk.

Claude Code's main thread acts as the coordinator. The routing policy lives in `CLAUDE.md` and `/team`.

## Team Operating Layer

The installer adds a shared operating layer under `.claude/team`:

```text
.claude/team/
  rules.md
  workflows.md
  contracts.md
  communication.md
  manifest.md
  skills/
    repo-context.md
    implementation.md
    bug-triage.md
    code-review.md
    research.md
    integration.md
    docs-sync.md
    validation.md
```

These files define how agents work together:

- `rules.md`: routing, safety, quality gates, and repository discipline.
- `workflows.md`: standard task, implementation, research, debugging, integration, and review flows.
- `contracts.md`: required output shape for each agent and the coordinator.
- `communication.md`: coordinator-mediated message envelopes for briefs, results, reviews, handoffs, errors, and conflict resolution.
- `agent-teams.md`: official experimental Claude Code agent-team mode, including teammate messaging, shared task list, and limits.
- `manifest.md`: installed team roster, commands, operating model, and config notes.
- `skills/*.md`: reusable playbooks for common engineering workflows.

`CLAUDE.md` imports these files with Claude Code memory imports, so the main coordinator sees them at session start. Each subagent also references the relevant files in its own prompt and can read them when handling delegated work.

## Local Communication Artifacts

If you want briefs, results, handoffs, reviews, errors, or task updates to exist as local repo files, the installer adds `.claude/comms/`:

```text
.claude/comms/
  README.md
  .gitignore
  templates/
    brief.md
    result.md
    review.md
    handoff.md
    error.md
    task-update.md
    index.md
    routing.md
    current.md
    agent-current.md
  sessions/
    .gitkeep
```

This is an audit/handoff layer, not Claude Code's runtime message transport. Runtime subagent messages are still pushed by Claude Code. Runtime experimental agent-team messages still use Claude Code's mailbox/shared task list. `.claude/comms/sessions/` is where the coordinator or agents can write local records when traceability matters.

A real comms session should be structured so the target agent is never ambiguous:

```text
.claude/comms/sessions/YYYYMMDD-HHMMSS-task-slug/
  00-index.md
  01-routing.md
  current.md
  by-agent/
    planner/current.md
    researcher/current.md
    coder/current.md
    integrator/current.md
    reviewer/current.md
    lead/current.md
  artifacts/
    briefs/
    results/
    reviews/
    handoffs/
    errors/
    tasks/
```

`01-routing.md` maps each artifact to `FROM`, `TARGET AGENT`, path, status, dependencies, and next expected artifact. `by-agent/<agent>/current.md` is the exact pointer file a target agent should read first. The coordinator must also pass the same exact file path in the runtime brief.

Use:

```text
/comms-start implement auth refresh safely
/comms-summarize .claude/comms/sessions/20260523-101500-auth-refresh
```

By default `.claude/comms/sessions/*` is ignored by `.claude/comms/.gitignore`; commit a session record only when the team intentionally wants it preserved.

## Primary CLAUDE.md Charter

The most important installed file is `CLAUDE.md`.

Claude Code reads project memory from `CLAUDE.md`, so this kit installs a full coordinator charter there, not just a short note. That charter defines:

- Startup protocol for every non-trivial request.
- Agent roster and responsibilities.
- Execution mode policy: direct, subagent, experimental agent team, or isolated worktree sessions.
- Routing policy.
- Delegation protocol.
- Agent communication protocol.
- Required quality gates.
- Safety baseline.
- Final response contract.
- Imports for `.claude/team/*` and `.claude/team/skills/*`.

## Install Into A Repository

From this kit repository:

```sh
scripts/install.sh /path/to/target-repo
```

To install into the current directory:

```sh
scripts/install.sh
```

Install directly from GitHub without cloning:

```sh
curl -fsSL https://raw.githubusercontent.com/TamDang1646/claude_agents/main/install.sh | bash
```

Install into a specific repository:

```sh
curl -fsSL https://raw.githubusercontent.com/TamDang1646/claude_agents/main/install.sh | bash -s -- /path/to/target-repo
```

Install a tagged release:

```sh
curl -fsSL https://raw.githubusercontent.com/TamDang1646/claude_agents/main/install.sh | CLAUDE_AGENTS_TEAM_REF=v0.1.0 bash -s -- /path/to/target-repo
```

Use a fork or private mirror:

```sh
curl -fsSL https://raw.githubusercontent.com/OWNER/REPO/main/install.sh | CLAUDE_AGENTS_TEAM_REPO=OWNER/REPO bash -s -- /path/to/target-repo
```

The installer writes:

```text
.claude/
  agents/
    planner.md
    researcher.md
    coder.md
    integrator.md
    reviewer.md
  commands/
    comms-start.md
    comms-summarize.md
    debate-debug.md
    team.md
    spawn-team.md
    parallel-review.md
    plan.md
    research.md
    implement.md
    review.md
    handoff.md
  output-styles/
    team-coordinator.md
  comms/
    README.md
    .gitignore
    templates/
      brief.md
      result.md
      review.md
      handoff.md
      error.md
      task-update.md
    sessions/
      .gitkeep
  rules/
    00-agent-team.md
    10-security.md
    20-validation.md
    30-communication.md
  skills/
    team-coordinate/
      SKILL.md
    repo-context/
      SKILL.md
    implement/
      SKILL.md
    debug/
      SKILL.md
    review/
      SKILL.md
    research/
      SKILL.md
    validate/
      SKILL.md
    docs-sync/
      SKILL.md
  hooks/
    README.md
    session-start.sh
    post-edit-reminder.sh
    subagent-stop-reminder.sh
  team/
    rules.md
    workflows.md
    contracts.md
    communication.md
    manifest.md
    skills/
      repo-context.md
      implementation.md
      bug-triage.md
      code-review.md
      research.md
      integration.md
      docs-sync.md
      validation.md
  settings.json
  settings.local.example.json
  statusline.sh
.mcp.example.json
.gitignore
CLAUDE.md
```

If an installed file already exists and differs, the installer creates a timestamped `.bak.*` backup before replacing it. The `CLAUDE.md` block is inserted between stable markers so it can be updated or removed safely.

## Update Or Remove

Update an existing installation:

```sh
scripts/install.sh /path/to/target-repo update
```

Remove installed agent files, command files, and the marked `CLAUDE.md` block:

```sh
scripts/install.sh /path/to/target-repo remove
```

## Validate Templates

Validate this kit's templates:

```sh
scripts/validate.sh
```

Validate an installed target:

```sh
scripts/validate.sh /path/to/target-repo/.claude
```

Run the full test suite:

```sh
scripts/test.sh
```

## Usage In Claude Code

Use the team command for complex tasks:

```text
/team analyze this repo and implement the requested feature safely
```

Use focused commands when you already know the workflow:

```text
/plan migrate the auth module to the new provider
/research latest migration notes for this dependency version
/implement add request timeout handling to the API client
/review current diff
/handoff summarize current progress
```

Experimental agent-team commands:

```text
/spawn-team explore this refactor with frontend/backend/test teammates
/debate-debug users report the app exits after one message
/parallel-review current diff
/comms-start high-risk payment migration
/comms-summarize .claude/comms/sessions/20260523-101500-payment-migration
```

Official project skills are also installed and can be invoked directly:

```text
/team-coordinate
/repo-context
/implement
/debug
/review
/research
/validate
/docs-sync
```

The commands and subagents follow these contracts:

- Planning output follows `.claude/team/contracts.md#planner-contract`.
- Research output follows `.claude/team/contracts.md#researcher-contract`.
- Implementation output follows `.claude/team/contracts.md#coder-contract`.
- Integration output follows `.claude/team/contracts.md#integrator-contract`.
- Review output follows `.claude/team/contracts.md#reviewer-contract`.
- Final synthesis follows `.claude/team/contracts.md#coordinator-final-contract`.

Agent communication has two modes:

- Coordinator sends `brief` envelopes to subagents.
- Subagents return `result`, `review`, `handoff`, `clarification_request`, or `error` envelopes.
- Agent-to-agent context is passed by the coordinator using a `handoff` envelope.
- Experimental agent-team teammates may message each other directly with `teammate_message` envelopes and coordinate through `task_update` entries.
- Local artifact mode can write those same envelopes to `.claude/comms/sessions/<session>/` for auditability.
- Local artifact mode must update `01-routing.md` and `by-agent/<agent>/current.md`, so agents do not guess which file to read.
- Parallel work must define independent objectives, non-overlapping files, merge order, and review scope.
- Conflicts are resolved by comparing evidence, validation, and repository source-of-truth.

You can also invoke subagents directly:

```text
Use the planner subagent to break down this feature.
Use the reviewer subagent to inspect the current diff.
```

## Design Notes

The installed system intentionally stays repository-local:

- No daemon or server process.
- No external database.
- No Managed Agents API session orchestration.
- No global user-level agent install by default.

Project-level subagents are preferred because they can be committed and shared with the team, and they take precedence over same-named user-level subagents.

## Safety Defaults

The installed `.claude/settings.json` includes conservative project defaults:

- Ask before common publish, push, deploy, and commit actions.
- Deny reads of common secret files such as `.env`, `secrets/**`, private keys, and `.pem` files.
- Deny obviously destructive shell patterns such as `rm -rf`, `git reset --hard`, and `git clean`.
- Enable lightweight hooks that remind Claude Code to follow the coordinator charter, validation gate, and output contracts.
- Enable experimental agent teams with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`.
- Configure project output style `Team Coordinator`.
- Configure a lightweight status line showing model, project, team state, and context percentage.
- Set MCP timeout/output environment defaults without installing live MCP servers.

Tune these settings per repository after install if your team has stricter or more permissive policies.

The installer also updates `.gitignore` to ignore `.claude/settings.local.json` and `CLAUDE.local.md`.

## MCP

Project-scoped MCP servers are configured by Claude Code in a root `.mcp.json` file. This kit installs `.mcp.example.json` only. Rename or copy it to `.mcp.json` after replacing placeholders with real, reviewed project MCP servers.

## Official Claude Code Features Covered

This kit now covers the main official project-level extension points:

- `CLAUDE.md` project memory and imports.
- `.claude/rules/` project rules.
- `.claude/agents/` project subagents.
- `.claude/skills/` project skills.
- `.claude/commands/` slash commands.
- `.claude/settings.json` project settings, permissions, hooks, status line, output style, and environment.
- `.claude/output-styles/` custom output style.
- `.mcp.json` pattern through `.mcp.example.json`.
- Experimental agent teams via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`.
