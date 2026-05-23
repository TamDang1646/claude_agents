# Security Policy

## Supported Scope

This project installs Claude Code configuration into a repository. It does not operate a hosted service and does not collect data.

## Reporting Security Issues

Open a private security advisory or contact the maintainers directly. Do not publish secrets, exploit details, or private repository information in a public issue.

## Security Defaults

The installed template includes:

- Deny rules for common secret files.
- Ask rules for publish, push, deploy, and commit commands.
- Local settings ignored by default.
- MCP example file only, not active MCP servers.
- Local comms sessions ignored by default.

## Maintainer Checklist

Before release:

- Confirm no credentials, tokens, or private paths are committed.
- Run `scripts/test.sh`.
- Review `.claude/settings.json` permission patterns.
- Review hooks for command injection risk.
- Verify `.mcp.example.json` contains no live secrets or internal URLs.
