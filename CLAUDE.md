# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SSHConn is a Bash script for managing SSH connections. It stores connections in `~/.connections` (CSV format: `domain,username,ip_or_hostname,port`) and provides commands to list, add, edit, delete, and connect to servers.

## Architecture

**Main Files:**
- `sshconn.sh` - Main script with all functionality
- `sshconn-completion.sh` - Bash/Zsh tab completion for domain names

**Key Functions in sshconn.sh:**
- `show_help()` - Display usage documentation
- `list_domains()` / `list_by_server()` - Two ways to display connections
- `add_entry()` - Add new connection with validation
- `scp_file()` - SCP file transfer to a domain
- Validation functions: `validate_domain()`, `validate_username()`, `validate_ip_or_hostname()`, `validate_port()`

## Development Notes

**Cross-platform sed compatibility:** The script detects `$OSTYPE` to use either `sed -i ''` (macOS) or `sed -i` (Linux). Always use this pattern when editing files in-place:
```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "..." "$file"
else
  sed -i "..." "$file"
fi
```

**Connections file format:** CSV with 4 fields (port optional, defaults to 22):
```
domain,username,ip_or_hostname,port
```

**Exit codes:** Use `exit 0` for success, `exit 1` for errors.

**Input validation:** All user input (domain, username, IP/hostname, port) must be validated before writing to the connections file.

## Testing

No automated test suite. Manual testing required:
```bash
# Test the script directly
./sshconn.sh --help
./sshconn.sh --list
./sshconn.sh --add
./sshconn.sh --by-server
./sshconn.sh [domain] --scp
```

Requires a `~/.connections` file to exist for most operations.
