![SSHConn - a Bash script for managing your SSH Connections](https://raw.githubusercontent.com/mwender/sshconn/main/thumbnail.png)

# SSHConn ![GitHub release (latest by date)](https://img.shields.io/github/v/release/mwender/sshconn)

`SSHConn` is a lightweight command-line tool that simplifies the management of SSH connections. It allows you to store, list, group, and manage SSH connections by domain, username, IP/hostname, and port—then connect with a single command.

Although `sshconn` is implemented as a Bash script, it works seamlessly when launched from **Bash or Zsh**. Shell-native autocompletion is supported for both environments.

---

## Features

* **List Connections** – Display a numbered list of stored SSH connections
* **Group by Server** – View connections grouped by IP address / host
* **Add New Connections** – Interactively add SSH connection entries
* **One-Command SSH** – Run `sshconn [domain]` to connect immediately
* **SCP Support** – Securely copy files using `--scp`
* **Edit or Delete Entries** – Manage connections interactively
* **Built-in Help** – Usage and options available via `-h` / `--help`
* **Shell Autocompletion** – Domain autocompletion for Bash and Zsh

---

## Installation

You can install `sshconn` directly using `curl` or `wget`.

### Option 1: Install via Curl

```bash
sudo curl -L https://raw.githubusercontent.com/MeonValleyWeb/sshconn/main/sshconn.sh -o /usr/local/bin/sshconn
sudo chmod +x /usr/local/bin/sshconn
```

### Option 2: Install via Wget

```bash
sudo wget https://raw.githubusercontent.com/MeonValleyWeb/sshconn/main/sshconn.sh -O /usr/local/bin/sshconn
sudo chmod +x /usr/local/bin/sshconn
```

Verify installation:

```bash
sshconn --help
```

---

## Usage

* **List all connections**

  ```bash
  sshconn --list
  ```

* **Group connections by IP / server**

  ```bash
  sshconn --by-server
  ```

* **Add a new connection**

  ```bash
  sshconn --add
  ```

* **Connect to a domain**

  ```bash
  sshconn myserver.example.com
  ```

* **Copy files via SCP**

  ```bash
  sshconn myserver.example.com --scp
  ```

---

## Shell Compatibility

### Bash vs Zsh

* `sshconn` runs under **Bash** (via its shebang) and works correctly when invoked from **either Bash or Zsh**
* No separate “zsh version” of the script is required
* Shell-specific behavior is handled via **separate completion files**, not separate executables

This keeps the core logic consistent and easy to maintain.

---

## Enabling Autocompletion

Autocompletion is optional but highly recommended. Setup differs slightly between Bash and Zsh.

---

### Bash Autocompletion

#### Install the completion script

```bash
curl -L https://raw.githubusercontent.com/MeonValleyWeb/sshconn/main/completions/bash/sshconn -o ~/.sshconn-completion.bash
```

#### Enable it

Add the following to your `~/.bashrc` or `~/.bash_profile` (macOS):

```bash
source ~/.sshconn-completion.bash
```

Reload your shell:

```bash
source ~/.bashrc
```

---

### Zsh Autocompletion

Zsh uses its own native completion system and requires a different setup.

#### 1. Create a completions directory (if needed)

```bash
mkdir -p ~/.zsh/completions
```

#### 2. Download the Zsh completion file

```bash
curl -L https://raw.githubusercontent.com/MeonValleyWeb/sshconn/main/completions/zsh/_sshconn -o ~/.zsh/completions/_sshconn
```

#### 3. Enable completions in `~/.zshrc`

Ensure the following lines exist in your `~/.zshrc`:

```zsh
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit
compinit
```

Reload your shell:

```bash
source ~/.zshrc
```

Once enabled, typing `sshconn` followed by `TAB` will autocomplete domains from your `~/.connections` file.

---

## Security Considerations

The `~/.connections` file contains sensitive metadata about your servers.

* **Permissions** – Recommended permissions are `600`:

  ```bash
  chmod 600 ~/.connections
  ```

* **No Password Storage** – Passwords are never stored; use SSH keys

* **Shared Systems** – Avoid use on shared machines

* **Warnings** – `sshconn` will warn if permissions are too permissive

---

## Connections File Format

`sshconn` reads from a simple CSV file at `~/.connections`.

```
domain,username,ip_or_hostname,port
```

* The `port` field is optional (defaults to `22`)
* Hostnames and IP addresses are both supported

Valid examples:

```
webserver.example.com,john,192.168.1.100,22
database.example.com,dbadmin,db.internal.example.com,3306
dev-server,developer,10.0.0.50
ssh-custom-port,admin,example.com,2222
```

Each line represents a single SSH connection profile.

---

## Changelog

For the full changelog, see [CHANGELOG.md](CHANGELOG.md).

### Recent Changes

**1.3.0**
* zsh compatibility

**1.2.1**

* Portability fixes for macOS/Linux `sed`
* Improved input validation
* Safer delete confirmations
* Editable IPs and ports
* File permission checks and warnings
* Custom SSH port support
* Added structured changelog and expanded documentation

**1.2.0**

* Added SCP support via `--scp`
* File path autocompletion for SCP

**1.1.x**

* Autocompletion support
* Stability and formatting fixes
* Repo metadata improvements

---

## Behind the Code

`SSHConn` was developed with the assistance of ChatGPT (initially GPT-4o), building on my earlier script [sshman](https://github.com/mwender/sshman).

I acted as the project manager—defining requirements, workflows, and UX—while ChatGPT handled implementation details. The result is a pragmatic tool that dramatically simplifies managing hundreds of SSH connections with minimal ceremony.

---

## License

This project is licensed under the MIT License.
