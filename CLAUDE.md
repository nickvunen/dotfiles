# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository that configures a modern terminal development environment. The primary components are:

- **Shell**: zsh with Oh My Zsh, Powerlevel10k prompt, zsh-autosuggestions, zsh-syntax-highlighting
- **Editor**: Neovim with Lazy.nvim plugin manager (~34 plugins)
- **Terminal**: WezTerm with custom coolnight color scheme
- **Multiplexer**: tmux (prefix: `Ctrl+a`)
- **File Manager**: yazi with Catppuccin Mocha theme
- **CLI Tools**: fzf, zoxide, eza, lazygit, thefuck, fd, fzf-git.sh

## Installation

```bash
chmod +x setup-dotfiles.sh
./setup-dotfiles.sh
```

The script auto-detects OS and uses the appropriate package manager (Homebrew on macOS, apt on Ubuntu/Debian, pacman on Arch). After running, restart the terminal or run `exec zsh`.

### Testing in Docker

```bash
# Ubuntu
docker run -it --rm ubuntu:22.04 bash -c "apt update && apt install -y git curl sudo && useradd -m -s /bin/bash testuser && echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && su - testuser -c 'git clone https://github.com/nickvunen/dotfiles.git && cd dotfiles && ./setup-dotfiles.sh'"

# Arch Linux
docker run -it --rm archlinux:latest bash -c "pacman -Syu --noconfirm git curl sudo && useradd -m -s /bin/bash testuser && echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && su - testuser -c 'git clone https://github.com/nickvunen/dotfiles.git && cd dotfiles && ./setup-dotfiles.sh'"
```

## Repository Structure

Config files here mirror their destination under `~`. The setup script copies them with `cp -r`:

| Source | Destination |
|--------|-------------|
| `.tmux.conf` | `~/.tmux.conf` |
| `.wezterm.lua` | `~/.wezterm.lua` |
| `.config/nvim/` | `~/.config/nvim/` |
| `.config/zshrc/zshrc_extra` | `~/.config/zshrc/zshrc_extra` (sourced from `~/.zshrc`) |
| `.config/yazi/` | `~/.config/yazi/` |
| `.config/thefuck/` | `~/.config/thefuck/` |

## Neovim Architecture

Entry point: `.config/nvim/init.lua` → loads `.config/nvim/lua/user/`

```
lua/user/
├── core/
│   ├── options.lua     # Editor settings (2-space tabs, relative numbers, system clipboard)
│   └── keymaps.lua     # Key mappings (leader = Space)
├── lazy.lua            # Lazy.nvim bootstrap and plugin loading
└── plugins/
    ├── lsp/
    │   ├── mason.lua       # LSP/DAP/linter package manager
    │   └── lspconfig.lua   # Language server configuration
    └── *.lua               # Individual plugin configs
```

Plugin manager: **Lazy.nvim** (lock file at `lazy-lock.json`). To update plugins, run `:Lazy update` inside Neovim.

`.config/nvim/lua/user/plugins/dap-config.lua` is gitignored — use `dap-config.lua.example` as a template for project-specific debug adapter configurations.

## Key Conventions

- **Neovim leader**: `Space`
- **tmux prefix**: `Ctrl+a`
- All navigation uses vim-style `h/j/k/l` keys across neovim, tmux pane switching (`Ctrl+h/j/k/l`), and yazi
- Color scheme throughout is **coolnight** (deep blue/neon green, background `#011423`)
- Font throughout is **MesloLGS Nerd Font** — required for icons to render correctly

## Shell Configuration

`.config/zshrc/zshrc_extra` is sourced from `~/.zshrc`. It sets up:
- Tool integrations: zoxide (`cd` replacement), eza (`ls` replacement), fzf with coolnight theme
- Aliases: `lg` → lazygit, `y` → yazi, `fk` → thefuck
- fzf keybindings: `Ctrl+t` (files), `Ctrl+r` (history), `Alt+c` (directories)
