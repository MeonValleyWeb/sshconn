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

By default the examples below install into `~/.local/bin`, keeping everything in your home directory and avoiding `sudo`/permission issues. Create a different directory if you prefer, just make sure it is on your `PATH`.

```bash
export INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"
```

If `~/.local/bin` is not already on your `PATH`, add one of the following lines to your shell profile (e.g. `~/.bashrc`, `~/.zshrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Option 1: Install via Curl

```bash
curl -L https://raw.githubusercontent.com/mwender/sshconn/main/sshconn.sh -o "$INSTALL_DIR/sshconn"
chmod +x "$INSTALL_DIR/sshconn"
```

### Option 2: Install via Wget

```bash
wget https://raw.githubusercontent.com/mwender/sshconn/main/sshconn.sh -O "$INSTALL_DIR/sshconn"
chmod +x "$INSTALL_DIR/sshconn"
```

### Why install locally?

- Writing to `~/.local/bin` keeps everything owned by your user, so `curl`/`chmod` never need `sudo` and you avoid "permission denied" errors.
- Adding `~/.local/bin` to your `PATH` (and re-sourcing your shell profile) ensures the freshly installed `sshconn` command is immediately available in new terminals.
- Initializing the `~/.connections` file ahead of time avoids the script prompting for elevated privileges when it first tries to write to it.

### Quick start checklist

```bash
curl -L https://raw.githubusercontent.com/mwender/sshconn/main/sshconn.sh -o ~/.local/bin/sshconn
chmod +x ~/.local/bin/sshconn
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc  # or ~/.bashrc
source ~/.zshrc                                        # reload your shell config
touch ~/.connections                                  # create the storage file
chmod 600 ~/.connections                              # optional but recommended for privacy
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


## Changelog

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
