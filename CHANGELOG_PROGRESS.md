# CHANGELOG_PROGRESS - sshconn

**Cloned:** 2026-04-02  
**Status:** Stable CLI tool — v1.3.0 released

## Project Overview
Bash script for managing SSH connections. Lightweight, shell-agnostic (Bash/Zsh).

## Features
- List connections (numbered)
- Group by server IP/hostname
- Add/edit/delete entries
- One-command SSH: `sshconn [domain]`
- SCP support: `sshconn [domain] --scp`
- Shell autocompletion (Bash + Zsh)

## Tech
- **Language:** Bash
- **Config:** `~/.connections` (CSV format)
- **Completion:** Separate files for Bash/Zsh

## Recent Activity
- v1.3.0: zsh compatibility
- v1.2.1: macOS/Linux portability, input validation, permission checks
- v1.2.0: SCP support
- v1.1.x: Autocompletion

## Security
- Recommended permissions: `600` on `~/.connections`
- No password storage (SSH keys only)
- Warns if permissions too permissive

## Pending Tasks
- [ ] Review for any new features needed
- [ ] Check if completions need updates
- [ ] Monitor for user issues/requests

## Notes
- Forked from mwender/sshconn (MIT license)
- Connections file format: `domain,username,ip_or_hostname,port`

---
*This file is managed by Jarvis. Last updated: 2026-04-02*
