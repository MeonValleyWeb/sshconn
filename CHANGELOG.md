# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CHANGELOG.md to track all project changes
- Cross-platform support for Linux and macOS
- Input validation for domain names, usernames, and IP addresses when adding entries
- Validation functions to ensure data integrity in connections file
- Confirmation prompt before deleting connections to prevent accidental removal
- Ability to edit IP addresses when editing connections

### Changed
- Replaced macOS-specific `sed -i ''` syntax with OS-detection for portability
- Edit and delete operations now work on both macOS and Linux systems
- `--add` command now validates input before adding to connections file
- Exit codes are now consistent: 0 for success, 1 for errors
- Edit function now supports modifying all three fields: domain, username, and IP address
- Edit function validates all changed fields before saving

### Fixed
- Prevented invalid domain names, usernames, and IP addresses from being added
- Inconsistent exit codes when connections are not found now properly return 1
- IP addresses can now be edited (previously this field was not editable)

### Security

## [1.2.0] - 2024-XX-XX

### Added
- SCP functionality via the --scp option, allowing secure file transfers
- Autocompletion for file paths when using SCP

## [1.1.3] - 2024-XX-XX

### Fixed
- Ensuring `--add` option adds new entries on a new line inside `~/.connections`

## [1.1.2] - 2024-XX-XX

### Added
- "Behind the Code" section to README

## [1.1.1] - 2024-XX-XX

### Added
- Repository thumbnail

## [1.1.0] - 2024-XX-XX

### Added
- Auto complete function

## [1.0.0] - 2024-XX-XX

### Added
- Initial release
- List connections functionality
- Group connections by server
- Add/edit/delete connections
- Direct SSH connection via domain
- Help documentation
