#!/bin/bash

# Define the connections file path
connections_file="$HOME/.connections"

# Detect OS for sed compatibility
if [[ "$OSTYPE" == "darwin"* ]]; then
  SED_INPLACE="sed -i ''"
else
  SED_INPLACE="sed -i"
fi

# Function to show help documentation
show_help() {
  echo "Usage: sshconn [options]

Options:
  --list                 List all connections with numbered options
  --by-server            Group connections by IP address and prompt for selection
  --add                  Add a new connection entry (domain, user, IP, port)
  --scp                  Use SCP to copy files to a server (domain must be specified)
  -h, --help             Show this help documentation
  [domain]               Enter a domain name directly to connect to it

Operations:
  1. Use --list to display all available connections, sorted by domain name.
  2. Use --by-server to list connections grouped by IP addresses. You can then choose a specific connection to manage.
  3. Use --add to add a new connection (domain, username, IP, port) to the ~/.connections file.
  4. Use --scp with a domain to copy files via SCP.
  5. If you enter a domain directly, the script will attempt to connect to that server via SSH.
  6. After selecting a connection, you can choose to connect (y), edit (edit), or delete (del) the connection.
  7. Port specification is supported; default is 22 if not specified.
"
}

# Function to list all domains with numbers, sorted alphabetically by domain
list_domains() {
  echo "Available connections:"
  awk -F',' '{print $1}' "$connections_file" | sort | nl -w1 -s". " | column -c $(tput cols)
}

# Function to render connections in a boxed layout
list_domains_boxed() {
    local connections=()
    while IFS= read -r line; do
        connections+=("$line")
    done < <(sort "$connections_file")

    local term_width=$(tput cols)
    local box_content_width=33 # Inner content width
    local box_total_width=$((box_content_width + 2)) # Add 2 for vertical borders
    local padding=2 # Space between boxes
    local cell_width=$((box_total_width + padding))

    local num_columns=$((term_width / cell_width))
    if [ $num_columns -eq 0 ]; then num_columns=1; fi

    local num_connections=${#connections[@]}
    local num_rows=$(( (num_connections + num_columns - 1) / num_columns ))

    for (( r=0; r<num_rows; r++ )); do
        # Top border row
        for (( c=0; c<num_columns; c++ )); do
            local index=$((r * num_columns + c))
            if [ $index -lt $num_connections ]; then
                printf "┌%s┐" "$(printf '─%.0s' $(seq 1 $box_content_width))"
                printf "%s" "$(printf ' ' $(seq 1 $padding))"
            fi
        done
        printf "\n"

        # Domain name row
        for (( c=0; c<num_columns; c++ )); do
            local index=$((r * num_columns + c))
            if [ $index -lt $num_connections ]; then
                local line_data=${connections[$index]}
                local domain=$(echo "$line_data" | cut -d',' -f1)
                printf "│ %-2s %-28s │" "$((index + 1))." "$(tput bold)$domain$(tput sgr0)"
                printf "%s" "$(printf ' ' $(seq 1 $padding))"
            fi
        done
        printf "\n"

        # User@IP row
        for (( c=0; c<num_columns; c++ )); do
            local index=$((r * num_columns + c))
            if [ $index -lt $num_connections ]; then
                local line_data=${connections[$index]}
                local user=$(echo "$line_data" | cut -d',' -f2)
                local ip=$(echo "$line_data" | cut -d',' -f3)
                printf "│ %-31s │" "  $user@$ip"
                printf "%s" "$(printf ' ' $(seq 1 $padding))"
            fi
        done
        printf "\n"
        
        # Bottom border row
        for (( c=0; c<num_columns; c++ )); do
            local index=$((r * num_columns + c))
            if [ $index -lt $num_connections ]; then
                printf "└%s┘" "$(printf '─%.0s' $(seq 1 $box_content_width))"
                printf "%s" "$(printf ' ' $(seq 1 $padding))"
            fi
        done
        printf "\n"
    done
}

# Function to validate port number
validate_port() {
  local port=$1
  # Port can be empty (default 22) or a number between 1-65535
  if [ -z "$port" ]; then
    return 0
  fi
  if [[ "$port" =~ ^[0-9]+$ ]] && [ "$port" -ge 1 ] && [ "$port" -le 65535 ]; then
    return 0
  fi
  return 1
}

# Function to validate domain name
validate_domain() {
  local domain=$1
  # Allow alphanumeric, dots, hyphens
  if [[ ! "$domain" =~ ^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$ ]]; then
    return 1
  fi
  return 0
}

# Function to validate username
validate_username() {
  local username=$1
  # Allow alphanumeric, underscore, hyphen, dot (common SSH username chars)
  if [[ -z "$username" ]] || [[ ! "$username" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    return 1
  fi
  return 0
}

# Function to validate IP address or hostname
validate_ip_or_hostname() {
  local ip=$1
  # Check if it's a valid IPv4 address
  if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    # Validate each octet is 0-255
    local IFS='.'
    local -a octets=($ip)
    for octet in "${octets[@]}"; do
      if ((octet > 255)); then
        return 1
      fi
    done
    return 0
  fi
  # Or check if it's a valid hostname/FQDN
  if [[ "$ip" =~ ^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$ ]]; then
    return 0
  fi
  return 1
}

# Function to add a new entry to the connections file
add_entry() {
  read -p "Enter domain: " domain
  read -p "Enter username: " username
  read -p "Enter IP address: " ip_address
  read -p "Enter port (press Enter for default 22): " port

  # Default port to 22 if empty
  port=${port:-22}

  # Validate domain
  if ! validate_domain "$domain"; then
    echo "ERROR: Invalid domain name format."
    exit 1
  fi

  # Validate username
  if ! validate_username "$username"; then
    echo "ERROR: Invalid username format. Use only alphanumeric characters, dots, hyphens, and underscores."
    exit 1
  fi

  # Validate IP address or hostname
  if ! validate_ip_or_hostname "$ip_address"; then
    echo "ERROR: Invalid IP address or hostname format."
    exit 1
  fi

  # Validate port
  if ! validate_port "$port"; then
    echo "ERROR: Invalid port number. Must be between 1 and 65535."
    exit 1
  fi

  if grep -q "^$domain," "$connections_file"; then
    echo "ERROR: Domain $domain already exists."
    exit 1
  fi

  # Ensure the file ends with a newline before appending
  if [ -s "$connections_file" ] && [ "$(tail -c 1 "$connections_file")" != "" ]; then
    echo "" >> "$connections_file"
  fi

  echo "$domain,$username,$ip_address,$port" >> "$connections_file"
  echo "New entry added: $domain,$username,$ip_address,$port"
}

# Function to list connections grouped by IP address, sorted alphabetically within each IP group
list_by_server() {
  echo "Connections grouped by IP:"
  awk -F',' '{ printf "%s %s %s %s\n", $3, $1, $2, ($4 ? $4 : "22") }' "$connections_file" | sort -t' ' -k1,1 -k2,2 | nl -w1 -s". " | column -t

  read -p "Select a number to proceed: " selection_number

  selected_line=$(awk -F',' '{ printf "%s %s %s %s\n", $3, $1, $2, ($4 ? $4 : "22") }' "$connections_file" | sort -t' ' -k1,1 -k2,2 | nl -w1 -s". " | awk "NR==$selection_number")

  if [ -z "$selected_line" ]; then
    echo "ERROR: Invalid selection."
    exit 1
  fi

  ip_address=$(echo "$selected_line" | awk '{print $2}')
  domain=$(echo "$selected_line" | awk '{print $3}')
  username=$(echo "$selected_line" | awk '{print $4}')
  port=$(echo "$selected_line" | awk '{print $5}')

  read -p "You've selected $domain. Would you like to connect (y), edit (edit), or delete (del)? [y/edit/del] " action

  case "$action" in
    y)
      ssh -p "$port" "$username@$ip_address"
      ;;
    edit)
      echo "Editing $domain:"
      read -p "Enter new domain (or press Enter to keep \"$domain\"): " new_domain
      read -p "Enter new username (or press Enter to keep \"$username\"): " new_username
      read -p "Enter new IP address (or press Enter to keep \"$ip_address\"): " new_ip
      read -p "Enter new port (or press Enter to keep \"$port\"): " new_port

      new_domain=${new_domain:-$domain}
      new_username=${new_username:-$username}
      new_ip=${new_ip:-$ip_address}
      new_port=${new_port:-$port}

      # Validate new values if they were changed
      if [ "$new_domain" != "$domain" ]; then
        if ! validate_domain "$new_domain"; then
          echo "ERROR: Invalid domain name format."
          exit 1
        fi
      fi

      if [ "$new_username" != "$username" ]; then
        if ! validate_username "$new_username"; then
          echo "ERROR: Invalid username format."
          exit 1
        fi
      fi

      if [ "$new_ip" != "$ip_address" ]; then
        if ! validate_ip_or_hostname "$new_ip"; then
          echo "ERROR: Invalid IP address or hostname format."
          exit 1
        fi
      fi

      if [ "$new_port" != "$port" ]; then
        if ! validate_port "$new_port"; then
          echo "ERROR: Invalid port number."
          exit 1
        fi
      fi

      # Use portable sed syntax
      $SED_INPLACE "s|^$domain,$username,$ip_address,$port|$new_domain,$new_username,$new_ip,$new_port|" "$connections_file"

      echo "Entry updated."
      ;;
    del)
      read -p "Are you sure you want to delete $domain? (y/N): " confirm
      if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Deletion cancelled."
        exit 0
      fi
      echo "Deleting $domain..."
      # Use portable sed syntax
      $SED_INPLACE "/^$domain,$username,$ip_address,$port/d" "$connections_file"

      echo "$domain has been deleted."
      ;;
    *)
      echo "Invalid option. Exiting."
      exit 1
      ;;
  esac
}

# Function to handle SCP connection
scp_file() {
  local domain_input=$1

  # Fetch the matching entry
  matches=$(grep "^$domain_input," "$connections_file")

  if [ -z "$matches" ]; then
    echo "No connection found for $domain_input."
    exit 1
  fi

  match_count=$(echo "$matches" | wc -l | tr -d ' ')

  if [ "$match_count" -gt 1 ]; then
    echo "ERROR: Multiple entries for $domain_input. Please edit your ~/.connections file to have only one line for this domain."
    exit 1
  else
    user=$(echo "$matches" | cut -d',' -f2)
    ip_address=$(echo "$matches" | cut -d',' -f3)
    port=$(echo "$matches" | cut -d',' -f4)
    port=${port:-22}  # Default to 22 if not specified
  fi

  # Prompt for file to copy.
  # - In Bash, use `read -e` for readline editing.
  # - Otherwise, fall back to plain `read`.
  if [[ -n "${BASH_VERSION:-}" ]]; then
    read -e -p "File to copy: " file_to_copy
  else
    read -p "File to copy: " file_to_copy
  fi

  if [ ! -f "$file_to_copy" ]; then
    echo "ERROR: File does not exist."
    exit 1
  fi

  read -p "Destination path on $domain_input: " destination_path

  # Execute the SCP command
  scp -P "$port" "$file_to_copy" "$user@$ip_address:$destination_path"
}

# Check if the connections file exists
if [ ! -f "$connections_file" ]; then
  echo "ERROR: No ~/.connections file found."
  exit 1
fi

# Check file permissions for security
file_perms=$(stat -f "%OLp" "$connections_file" 2>/dev/null || stat -c "%a" "$connections_file" 2>/dev/null)
if [ "$file_perms" != "600" ] && [ "$file_perms" != "400" ]; then
  echo "WARNING: ~/.connections has permissions $file_perms (should be 600 for security)"
  echo "Consider running: chmod 600 ~/.connections"
  echo ""
fi

# Check for help or no arguments provided
if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ -z "$1" ]; then
  show_help
  exit 0
fi

# Check if the script was run with the --list option
if [ "$1" == "--list" ]; then
  list_domains_boxed

  read -p "Enter the number corresponding to the domain: " domain_number

  if ! [[ "$domain_number" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Invalid input. Please enter a number."
    exit 1
  fi

  chosen_domain=$(awk -F',' '{print $1}' "$connections_file" | sort | awk "NR==$domain_number")

  if [ -z "$chosen_domain" ]; then
    echo "ERROR: No domain found for number $domain_number."
    exit 1
  fi

  $0 "$chosen_domain"
  exit 0
fi

# Check if the script was run with the --add option
if [ "$1" == "--add" ]; then
  add_entry
  exit 0
fi

# Check if the script was run with the --by-server option
if [ "$1" == "--by-server" ]; then
  list_by_server
  exit 0
fi

# Check if the script was run with the --scp option
if [ "$2" == "--scp" ]; then
  scp_file "$1"
  exit 0
fi

# Regular domain handling flow
domain_input=$1

if [ -z "$domain_input" ]; then
  echo "ERROR: Please provide a domain as input or use the --list option."
  exit 1
fi

matches=$(grep "^$domain_input," "$connections_file")

if [ -z "$matches" ]; then
  echo "No connection found for $domain_input."
  exit 1
fi

match_count=$(echo "$matches" | wc -l | tr -d ' ')

if [ "$match_count" -gt 1 ]; then
  echo "ERROR: Multiple entries for $domain_input. Please edit your ~/.connections file to have only one line for this domain."
  exit 1
else
  user=$(echo "$matches" | cut -d',' -f2)
  ip_address=$(echo "$matches" | cut -d',' -f3)
  port=$(echo "$matches" | cut -d',' -f4)
  port=${port:-22}  # Default to 22 if not specified

  # Directly execute the SSH command
  ssh -p "$port" "$user@$ip_address"
fi
