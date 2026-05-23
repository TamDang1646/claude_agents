# Security Rule

- Do not read secrets unless explicitly requested for a safe reason.
- Do not print credentials, tokens, private keys, or environment secrets.
- Treat `.env`, `secrets/**`, `credentials/**`, private keys, and `.pem` files as denied by default.
- Mutating external systems requires clear user intent or approval.
- Deployment, publishing, pushing, and destructive commands require explicit permission.
