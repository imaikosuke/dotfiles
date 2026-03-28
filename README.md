# dotfiles

> Japanese version: [README.ja.md](README.ja.md)

## Overview

A declarative macOS environment management setup based on Nix Flakes.

`nix-darwin` handles system-level configuration, `Home Manager` manages the user environment, and `nix-homebrew` takes care of GUI applications — all unified through `flake.nix` as the single entry point.

Designed for a single Apple Silicon Mac. The entire environment can be reproduced with one command:

```bash
sudo darwin-rebuild switch --flake .#imaikosuke
```

## Prerequisites

- macOS (Apple Silicon)
- Nix installed with flakes enabled
- nix-darwin available

## Directory Structure

```text
.
├── flake.nix                          # Entry point
├── flake.lock
├── nix-darwin/
│   ├── configuration.nix              # macOS system settings
│   ├── home_manager.nix               # Home Manager integration
│   └── homebrew.nix                   # Homebrew package management
└── home-manager/
    ├── home.nix                       # User environment configuration
    ├── cursor/
    │   ├── cursor.nix                 # Cursor extensions
    │   └── settings.json              # Cursor user settings
    ├── git/
    │   └── .gitconfig                 # Git / ghq configuration
    ├── ghostty/
    │   ├── config                     # Ghostty terminal settings
    │   └── banner.txt                 # Startup banner
    ├── starship/
    │   └── starship.toml              # Starship prompt configuration
    └── zsh/
        ├── .zshrc                     # zsh entry point
        ├── aliases.zsh                # Alias definitions
        ├── chpwd.zsh                  # Auto ls after cd
        └── sghq.zsh                   # ghq + fzf repository navigation
```

## What's Managed

### nix-darwin — macOS System Settings

| Item | Value |
|------|-------|
| Platform | `aarch64-darwin` |
| Touch ID sudo | Enabled via `security.pam.services.sudo_local.touchIdAuth` |

### nix-homebrew — GUI Applications (casks)

Homebrew is managed declaratively — packages removed from the config are automatically uninstalled.

| Cask |
|------|
| google-chrome |
| slack |
| obsidian |
| ghostty |
| raycast |
| cursor |
| font-jetbrains-mono-nerd-font |

### Home Manager — CLI Tools and User Settings

**Nix packages**

| Package | Purpose |
|---------|---------|
| bat | cat replacement |
| git | Version control |
| ghq | Repository management |
| tree | Directory tree display |
| zsh-completions | Additional zsh completions |

**programs (Home Manager modules)**

| Program | Configuration |
|---------|--------------|
| zsh | Completions, autosuggestions, loads `~/.config/zsh/.zshrc` |
| fzf | zsh integration enabled |
| starship | zsh integration enabled, customized via `starship.toml` |

**dotfiles (symlinked via `home.file`)**

| Target | Source |
|--------|--------|
| `~/.gitconfig` | `home-manager/git/.gitconfig` |
| `~/.config/starship.toml` | `home-manager/starship/starship.toml` |
| `~/.config/zsh/` | `home-manager/zsh/` |
| `~/.config/ghostty/config` | `home-manager/ghostty/config` |
| `~/.config/ghostty/banner.txt` | `home-manager/ghostty/banner.txt` |
| `~/Library/Application Support/Cursor/User/settings.json` | `home-manager/cursor/settings.json` |
| `~/.cursor/extensions/` | Extensions built with Nix |

**Cursor Extensions (nixpkgs)**

Astro, Auto Rename Tag, ESLint, GitHub Actions, GitLens, Markdown All in One, MDX, Prettier, Tailwind CSS IntelliSense, vscode-icons

## Initial Setup

### 1. Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Clone the repository

```bash
git clone git@github.com:imaikosuke/dotfiles.git ~/ghq/github.com/imaikosuke/dotfiles
cd ~/ghq/github.com/imaikosuke/dotfiles
```

### 3. Apply the configuration

```bash
sudo darwin-rebuild switch --flake .#imaikosuke
```

This applies the nix-darwin, Home Manager, and Homebrew configuration all at once.

### 4. Day-to-day usage

```bash
# Apply configuration changes
sudo darwin-rebuild switch --flake .#imaikosuke

# Update flake inputs then apply
nix flake update && sudo darwin-rebuild switch --flake .#imaikosuke
```
