# MEMORY - sshconn

**Project:** SSHConn  
**Type:** CLI Tool / Bash Script  
**Version:** 1.3.0

## Purpose
Lightweight SSH connection manager. Store, list, group, and connect to SSH servers with one command.

## Installation
```bash
curl -L https://raw.githubusercontent.com/mwender/sshconn/main/sshconn.sh -o /usr/local/bin/sshconn
chmod +x /usr/local/bin/sshconn
```

## Commands
- `sshconn --list` — List all connections
- `sshconn --by-server` — Group by IP/server
- `sshconn --add` — Add new connection
- `sshconn [domain]` — Connect
- `sshconn [domain] --scp` — SCP file transfer

## Config
File: `~/.connections`
Format: `domain,username,ip_or_hostname,port`

## Completion Setup
**Bash:** `~/.sshconn-completion.bash` → source in `.bashrc`
**Zsh:** `~/.zsh/completions/_sshconn` → add to `fpath`

## Security
- File permissions: `600`
- No passwords stored
- SSH keys only
