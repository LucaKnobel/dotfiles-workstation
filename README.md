# Dotfiles

Version-controlled Linux configurations for multiple machines.

## Goals

- Shared configuration across Linux desktops and laptops
- Machine-specific settings where necessary
- Reproducible workstation configuration
- Version-controlled changes
- No secrets committed to Git

## Tools

- Git: Version control
- Chezmoi: Dotfile management
- Make: Common commands
- Ansible: Future system provisioning

## Repository structure

- `home/`: Chezmoi-managed configuration
- `legacy/`: Archived configurations
- `docs/`: Documentation
- `scripts/`: Helper scripts
- `ansible/`: Future system provisioning

## Usage

Run these commands from the repository root:

- `make doctor` - Check Chezmoi environment
- `make status` - Show configuration status
- `make diff` - Preview changes
- `make apply` - Apply configurations

## Architecture

Shared configurations are managed with Chezmoi.

Machine-specific settings will use templates and local data.

System configuration and package installation may be
automated separately with Ansible in the future.
