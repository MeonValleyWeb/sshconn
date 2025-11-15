![SSHConn - a Bash script for managing your SSH Connections](https://raw.githubusercontent.com/mwender/sshconn/main/thumbnail.png)

# SSHConn ![GitHub release (latest by date)](https://img.shields.io/github/v/release/mwender/sshconn)

`SSHConn` is a Bash script that simplifies the management of SSH connections. It allows you to store, list, and manage SSH connections based on domain, username, and IP address. You can also group connections by server, add new connections, and perform SSH connections directly by specifying a domain.

## Features

- **List Connections**: Display a numbered list of stored SSH connections.
- **Group by Server**: View connections grouped by their IP address.
- **Add New Connections**: Easily add new SSH connection entries.
- **Connect Automatically**: Run `sshconn [domain]` to automatically SSH into a server.
- **Secure Copy (SCP) Files**: Use the `--scp` option to securely copy files to a server.
- **Edit or Delete**: Edit or delete existing connections.
- **Help Menu**: A built-in help menu to display usage instructions.

## Installation

You can easily install the `sshconn` script using `curl` or `wget` by following the instructions below:

### Option 1: Install via Curl

```bash
# Download the script
curl -L https://raw.githubusercontent.com/mwender/sshconn/main/sshconn.sh -o /usr/local/bin/sshconn

# Make the script executable
chmod +x /usr/local/bin/sshconn
```

### Option 2: Install via Wget

```bash
# Download the script
wget https://raw.githubusercontent.com/mwender/sshconn/main/sshconn.sh -O /usr/local/bin/sshconn

# Make the script executable
chmod +x /usr/local/bin/sshconn
```

Once installed, you can start using the script by running:

```bash
sshconn -h
```

This will display the help menu with available options.

## Usage

- **List all connections**:
  ```bash
  sshconn --list
  ```

- **Group connections by IP**:
  ```bash
  sshconn --by-server
  ```

- **Add a new connection**:
  ```bash
  sshconn --add
  ```

- **Connect to a domain**:
  ```bash
  sshconn [domain]
  ```

- **Securely copy files using SCP**:
  ```bash
  sshconn [domain] --scp
  ```

## Enabling Autocompletion for `sshconn`

To enable autocompletion for the `sshconn` command, follow these steps:

### 1. Download the Autocompletion Script

Download the autocompletion script to your local machine:

```bash
curl -L https://raw.githubusercontent.com/mwender/sshconn/main/sshconn-completion.sh -o ~/.sshconn-completion.sh
```

### 2. Add the Following Line to Your Shell Configuration

For **Bash** users, add this line to your `~/.bashrc` (or `~/.bash_profile` if you're using macOS) to enable autocompletion every time you open a new terminal:

```bash
source ~/.sshconn-completion.sh
```

For **Zsh** users, add this to your `~/.zshrc`:

```bash
source ~/.sshconn-completion.sh
```

### 3. Apply the Changes

After making the changes, apply them by running:

```bash
source ~/.bashrc     # For Bash users
source ~/.zshrc      # For Zsh users
```

Now, when you type `sshconn` and press `TAB`, it will autocomplete available domains based on the entries in your `~/.connections` file.

## Security Considerations

The `~/.connections` file contains sensitive information including server IP addresses and usernames. To protect this data:

- **File Permissions**: The script will warn you if `~/.connections` has overly permissive permissions. It's recommended to set permissions to 600 (read/write for owner only):
  ```bash
  chmod 600 ~/.connections
  ```

- **Storage Location**: Keep the connections file in your home directory, not in shared or world-readable locations.

- **SSH Keys**: This script does not store passwords. Use SSH key-based authentication for secure, passwordless connections.

- **Shared Systems**: Avoid using this tool on shared systems where other users might access your connection data.

## File Format

The `~/.connections` file uses a simple CSV format:
```
domain,username,ip_or_hostname
```

Example:
```
webserver.example.com,john,192.168.1.100
database.example.com,dbadmin,db.internal.example.com
dev-server,developer,10.0.0.50
```

Each line represents one connection entry with comma-separated values for domain identifier, SSH username, and IP address or hostname.


## Changelog

For a complete changelog, see [CHANGELOG.md](CHANGELOG.md).

### Recent Changes

_1.2.1_

- **Portability**: Fixed macOS-specific `sed` commands to work on both macOS and Linux
- **Validation**: Added input validation for domain names, usernames, and IP addresses
- **Safety**: Added confirmation prompt before deleting connections
- **Consistency**: Fixed exit codes to properly indicate errors (exit 1) vs success (exit 0)
- **Edit Enhancement**: Can now edit IP addresses in addition to domain and username
- **Security**: Added file permission check and warnings for insecure configurations
- Added CHANGELOG.md for structured change tracking
- Added Security Considerations and File Format sections to README

_1.2.0_

- Added SCP functionality via the --scp option, allowing secure file transfers.
- Added autocompletion for file paths when using SCP.

_1.1.3_

- BUGFIX: Ensuring `--add` option adds new entries on a new line inside `~/.connections`.

_1.1.2_

- Adding "Behind the Code" section to README.

_1.1.1_

- Adding repo thumbnail.

_1.1.0_

- Adding auto complete function.

_1.0.0_

- First release.

## Behind the Code

I developed `SSHConn` with the help of ChatGPT 4o. The program builds upon my previous script [sshman](https://github.com/mwender/sshman).

Being no expert in Bash, I was the project manager while ChatGPT wrote code according to my specifications. I set the direction and defined the features. ChatGPT worked as my junior developer, helping me implement the functionality and refine the code.

The result is `SSHConn`, a tool that improves SSH connection management. It adds features like autocompletion and connection grouping, making it more efficient than my original `sshman` script. Given that I have 200+ SSH connections I need to keep track of, `SSHConn` greatly simplifies that process.

## License

This project is licensed under the MIT License.
