# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CHANGELOG.md to track all project changes
- Cross-platform support for Linux and macOS

### Changed
- Replaced macOS-specific `sed -i ''` syntax with OS-detection for portability
- Edit and delete operations now work on both macOS and Linux systems

### Fixed

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
