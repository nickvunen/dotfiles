# Dotfiles

A comprehensive dotfiles setup script that configures a modern terminal development environment with zsh, neovim, tmux, and various CLI tools.

## Installation

### Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/nickvunen/dotfiles.git
   cd dotfiles
   ```

2. Run the setup script:
   ```bash
   chmod +x setup-dotfiles.sh
   ./setup-dotfiles.sh
   ```

3. Restart your terminal or run:
   ```bash
   exec zsh
   ```

4. The Powerlevel10k configuration wizard will start automatically. If it doesn't, run:
   ```bash
   p10k configure
   ```

### What the Script Does

The `setup-dotfiles.sh` script performs the following actions:

1. **Detects your OS** and installs packages using the appropriate package manager
2. **Switches your shell to zsh** if you're currently using bash or another shell
3. **Installs all required packages** (tmux, neovim, yazi, lazygit, fzf, zoxide, eza, fd, thefuck, wezterm, opencode)
4. **Installs MesloLGS Nerd Font** for proper icon rendering
5. **Installs fzf-git.sh** for enhanced git integration with fzf
6. **Sets up Oh My Zsh** with plugins (zsh-autosuggestions, zsh-syntax-highlighting)
7. **Installs Powerlevel10k** theme for a beautiful and informative prompt
8. **Copies configuration files**:
   - `.tmux.conf` → `~/.tmux.conf`
   - `.wezterm.lua` → `~/.wezterm.lua`
   - `.config/nvim/` → `~/.config/nvim/`
   - `.config/zshrc/` → `~/.config/zshrc/`
   - `.config/yazi/` → `~/.config/yazi/`
   - `.config/thefuck/` → `~/.config/thefuck/`
9. **Adds source lines** to `~/.zshrc` for extra configurations
10. **Launches the Powerlevel10k configuration wizard** for prompt customization

### Testing in a Clean Environment

To verify the setup script works correctly, you can test it in a clean environment using Docker:

#### Testing on Ubuntu
```bash
docker run -it --rm ubuntu:22.04 bash -c "
  apt update && apt install -y git curl sudo
  useradd -m -s /bin/bash testuser
  echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
  su - testuser -c '
    git clone https://github.com/nickvunen/dotfiles.git
    cd dotfiles
    ./setup-dotfiles.sh
  '
"
```

#### Testing on Arch Linux
```bash
docker run -it --rm archlinux:latest bash -c "
  pacman -Syu --noconfirm git curl sudo
  useradd -m -s /bin/bash testuser
  echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
  su - testuser -c '
    git clone https://github.com/nickvunen/dotfiles.git
    cd dotfiles
    ./setup-dotfiles.sh
  '
"
```

#### Testing on macOS
For macOS testing, use a fresh user account or a virtual machine:
```bash
git clone https://github.com/nickvunen/dotfiles.git
cd dotfiles
./setup-dotfiles.sh
```

### Expected Outcomes After Installation

After running the setup script successfully, you should see:

1. **Shell changed to zsh** - Your default shell will be zsh
2. **Oh My Zsh installed** - Located at `~/.oh-my-zsh/`
3. **Powerlevel10k theme active** - Beautiful prompt with git status, etc.
4. **All CLI tools available** - Run `which tmux nvim yazi lazygit fzf zoxide eza fd thefuck wezterm opencode` to verify
5. **Configuration files in place**:
   - `~/.tmux.conf`
   - `~/.wezterm.lua`
   - `~/.config/nvim/`
   - `~/.config/zshrc/`
   - `~/.config/yazi/`
   - `~/.config/thefuck/`
6. **MesloLGS Nerd Font installed** - Icons should render correctly in the terminal
7. **fzf-git.sh available** - Located at `~/.fzf-git.sh`

### Verification Commands

After installation, run these commands to verify everything is working:

```bash
# Check shell
echo $SHELL  # Should show /bin/zsh or /usr/bin/zsh

# Check installed tools
tmux -V
nvim --version | head -1
yazi --version
lazygit --version
fzf --version
zoxide --version
eza --version
fd --version
thefuck --version
wezterm --version
opencode --version

# Check Oh My Zsh plugins
ls ~/.oh-my-zsh/custom/plugins/

# Check Powerlevel10k
ls ~/.oh-my-zsh/custom/themes/powerlevel10k/

# Check config files
ls -la ~/.tmux.conf ~/.wezterm.lua ~/.config/nvim/ ~/.config/zshrc/
```

## What Gets Installed

The setup script installs and configures the following tools, organized by category:

### Terminal & Shell
| Tool | Description |
|------|-------------|
| [zsh](https://www.zsh.org/) | Powerful shell with advanced features |
| [Oh My Zsh](https://ohmyz.sh/) | Framework for managing zsh configuration |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Fast and customizable zsh theme |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-like autosuggestions for zsh |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Syntax highlighting for zsh commands |

### Terminal Emulator
| Tool | Description |
|------|-------------|
| [WezTerm](https://wezfurlong.org/wezterm/) | GPU-accelerated terminal emulator |

### Terminal Multiplexer
| Tool | Description |
|------|-------------|
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer for managing multiple sessions |

### Editor
| Tool | Description |
|------|-------------|
| [Neovim](https://neovim.io/) | Hyperextensible Vim-based text editor |

### File Manager
| Tool | Description |
|------|-------------|
| [yazi](https://github.com/sxyazi/yazi) | Blazing fast terminal file manager |

### Git Tools
| Tool | Description |
|------|-------------|
| [lazygit](https://github.com/jesseduffield/lazygit) | Simple terminal UI for git commands |
| [fzf-git.sh](https://github.com/junegunn/fzf-git.sh) | Key bindings for Git objects powered by fzf |

### CLI Utilities
| Tool | Description |
|------|-------------|
| [fzf](https://github.com/junegunn/fzf) | Command-line fuzzy finder |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter cd command that learns your habits |
| [eza](https://github.com/eza-community/eza) | Modern replacement for ls |
| [fd](https://github.com/sharkdp/fd) | Simple, fast alternative to find |
| [thefuck](https://github.com/nvbn/thefuck) | Magnificent app that corrects previous console commands |
| [opencode](https://opencode.ai/) | AI coding agent for the terminal |

### Fonts
| Font | Description |
|------|-------------|
| [MesloLGS Nerd Font](https://github.com/ryanoasis/nerd-fonts) | Patched font with icons for terminal use |

## OS-Specific Installation Notes

The setup script automatically detects your operating system and installs packages using the appropriate package manager:

### macOS (Homebrew)
```bash
# Homebrew is installed automatically if not present
# Packages installed via: brew install <package>
brew install tmux neovim yazi lazygit fzf zoxide eza fd thefuck wezterm
brew install --cask font-meslo-lg-nerd-font
# opencode installed via: curl -fsSL https://opencode.ai/install | bash
```

### Ubuntu/Debian (apt)
```bash
# Core packages installed via apt
sudo apt install tmux neovim fzf fd-find

# Additional packages installed from official sources or manually:
# - yazi: via cargo or direct download
# - lazygit: from GitHub releases
# - zoxide: via install script
# - eza: from gierens repository
# - thefuck: via pip
# - wezterm: from wez repository
# - opencode: via install script (curl -fsSL https://opencode.ai/install | bash)
```

### Arch Linux (pacman)
```bash
# All packages available in official repositories
sudo pacman -S tmux neovim yazi lazygit fzf zoxide eza fd thefuck wezterm ttf-meslo-nerd
# opencode installed via: curl -fsSL https://opencode.ai/install | bash
```

## Configuration Files

The repository includes the following configuration files:

| File/Folder | Description |
|-------------|-------------|
| `.tmux.conf` | tmux configuration |
| `.wezterm.lua` | WezTerm terminal configuration |
| `.config/nvim/` | Neovim configuration |
| `.config/zshrc/` | Additional zsh configuration |
| `.config/yazi/` | Yazi file manager configuration |
| `.config/thefuck/` | thefuck configuration |

## Optional: Debug Adapter Protocol (DAP) Configuration

If you want to set up project-specific debug configurations for Neovim:

1. Copy the example configuration:
   ```bash
   cp ~/.config/nvim/lua/user/plugins/dap-config.lua.example ~/.config/nvim/lua/user/plugins/dap-config.lua
   ```

2. Edit `dap-config.lua` to add your custom debug configurations for your projects

3. The `dap-config.lua` file is gitignored by default to keep your personal/work configurations private

**Note**: The example file contains a template for Python debugging. Customize it based on your specific project needs.

## Troubleshooting

### Mason-lspconfig Issues
If you get issues with mason-lspconfig in Neovim, clear the local cache:
```bash
rm -rf ~/.local/share/nvim/lazy/mason-lspconfig.nvim
```

### WezTerm on Arch Linux (Omarchy)
If WezTerm does not start on Arch Linux with Omarchy, install it via AUR:
```bash
yay -S wezterm-git
```

### Powerlevel10k Configuration
If the Powerlevel10k configuration wizard doesn't start automatically:
```bash
p10k configure
```

### Shell Not Changing to Zsh
If your shell doesn't change to zsh after running the script:
1. Verify zsh is installed: `which zsh`
2. Change shell manually: `chsh -s $(which zsh)`
3. Log out and log back in, or restart your terminal

### Missing Icons in Terminal
If icons don't render correctly:
1. Ensure MesloLGS Nerd Font is installed
2. Configure your terminal emulator to use "MesloLGS Nerd Font Mono" as the font
3. Restart your terminal

### Permission Denied Errors
If you encounter permission errors during installation:
```bash
chmod +x setup-dotfiles.sh
```

For package installation issues, ensure you have sudo privileges.

### Neovim Deprecation Warnings

**Important**: You may see deprecation warnings when starting Neovim. These are typically caused by plugins using deprecated Neovim APIs and are **non-blocking** — your editor will still work correctly.

**What to do:**
1. **Update your plugins regularly**: Run `:Lazy update` in Neovim to update all plugins to their latest versions
2. **Most warnings are harmless**: Deprecation warnings are informational and won't prevent you from using Neovim
3. **Plugin authors fix these over time**: Most popular plugins get updated to use new APIs

To suppress deprecation warnings temporarily, you can add this to your Neovim config:
```lua
vim.deprecate = function() end
```

**Note**: This is not recommended long-term as it hides useful information about API changes.

### Lua 5.1 for LuaJIT Compatibility (Optional)

Some Neovim plugins or tools (like certain LSP servers) may benefit from having Lua 5.1 or LuaJIT installed. This is **optional** and most users won't need it.

**macOS (Homebrew):**
```bash
brew install lua@5.1 luajit
```

**Ubuntu/Debian:**
```bash
sudo apt install lua5.1 luajit
```

**Arch Linux:**
```bash
sudo pacman -S lua51 luajit
```

### Ruby Provider (Optional)

If you use Ruby and want Neovim's Ruby provider:
```bash
gem install neovim
```

The setup script will automatically install this if Ruby is detected on your system.

### Neovim Provider Health Check

To verify all Neovim providers are working correctly, run inside Neovim:
```vim
:checkhealth provider
```

This will show the status of Python, Node.js, Ruby, and other providers.

## Keyboard Shortcuts

This section documents all custom keyboard shortcuts configured in the dotfiles.

### Tmux Shortcuts

Prefix key: `Ctrl+a` (press this first, then the following key)

#### Session/Window Management
| Shortcut | Description |
|----------|-------------|
| `Ctrl+a` | Send prefix to nested tmux session |
| `Ctrl+a` then `|` | Split window vertically |
| `Ctrl+a` then `-` | Split window horizontally |
| `Ctrl+a` then `r` | Reload tmux configuration |
| `Ctrl+a` then `m` | Maximize/restore current pane |

#### Pane Navigation (Vim-style)
| Shortcut | Description |
|----------|-------------|
| `Ctrl+h` | Move to left pane |
| `Ctrl+j` | Move to pane below |
| `Ctrl+k` | Move to pane above |
| `Ctrl+l` | Move to right pane |

#### Pane Resizing
| Shortcut | Description |
|----------|-------------|
| `Ctrl+a` then `h` | Resize pane left |
| `Ctrl+a` then `j` | Resize pane down |
| `Ctrl+a` then `k` | Resize pane up |
| `Ctrl+a` then `l` | Resize pane right |

#### Copy Mode
| Shortcut | Description |
|----------|-------------|
| `Ctrl+a` then `[` | Enter copy mode (vim-style navigation) |
| `v` | Begin selection (in copy mode) |
| `y` | Copy selection (in copy mode) |

### Neovim Shortcuts

Leader key: `Space`

#### General
| Shortcut | Mode | Description |
|----------|------|-------------|
| `jk` | Insert | Exit insert mode |
| `Space+nh` | Normal | Clear search highlights |
| `Space++` | Normal | Increment number |
| `Space+-` | Normal | Decrement number |

#### Window Management
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+sv` | Normal | Split window vertically |
| `Space+sh` | Normal | Split window horizontally |
| `Space+se` | Normal | Make splits equal size |
| `Space+sx` | Normal | Close current split |
| `Space+sm` | Normal | Maximize/minimize a split |

#### Tab Management
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+to` | Normal | Open new tab |
| `Space+tx` | Normal | Close current tab |
| `Space+tn` | Normal | Go to next tab |
| `Space+tp` | Normal | Go to previous tab |
| `Space+tf` | Normal | Open current buffer in new tab |
| `Space+1` | Normal | Go to tab 1 |
| `Space+2` | Normal | Go to tab 2 |
| `Space+3` | Normal | Go to tab 3 |

#### Quickfix List
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+qo` | Normal | Open quickfix list |
| `Space+qc` | Normal | Close quickfix list |

#### File Explorer (nvim-tree)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+ee` | Normal | Toggle file explorer |
| `Space+ef` | Normal | Toggle file explorer on current file |
| `Space+ec` | Normal | Collapse file explorer |
| `Space+er` | Normal | Refresh file explorer |

#### Telescope (Fuzzy Finder)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+ff` | Normal | Find files in cwd |
| `Space+fr` | Normal | Find recent files |
| `Space+fs` | Normal | Find string in cwd (live grep) |
| `Space+fc` | Normal | Find string under cursor |
| `Space+ft` | Normal | Find todos |
| `Ctrl+k` | Telescope | Move to previous result |
| `Ctrl+j` | Telescope | Move to next result |
| `Ctrl+q` | Telescope | Send selected to quickfix list |

#### LSP (Language Server Protocol)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `gr` | Normal | Show LSP references |
| `gD` | Normal | Go to declaration |
| `gd` | Normal | Show LSP definitions |
| `gi` | Normal | Show LSP implementations |
| `gt` | Normal | Show LSP type definitions |
| `K` | Normal | Show documentation for what is under cursor |
| `Space+ca` | Normal/Visual | See available code actions |
| `Space+rn` | Normal | Smart rename |
| `Space+D` | Normal | Show buffer diagnostics |
| `Space+dd` | Normal | Show line diagnostics |
| `[d` | Normal | Go to previous diagnostic |
| `]d` | Normal | Go to next diagnostic |
| `Space+rs` | Normal | Restart LSP |

#### Git (gitsigns)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `]h` | Normal | Next hunk |
| `[h` | Normal | Previous hunk |
| `Space+hs` | Normal/Visual | Stage hunk |
| `Space+hr` | Normal/Visual | Reset hunk |
| `Space+hS` | Normal | Stage buffer |
| `Space+hR` | Normal | Reset buffer |
| `Space+hu` | Normal | Undo stage hunk |
| `Space+hp` | Normal | Preview hunk |
| `Space+hb` | Normal | Blame line |
| `Space+hB` | Normal | Toggle line blame |
| `Space+hd` | Normal | Diff this |
| `Space+hD` | Normal | Diff this ~ |
| `ih` | Operator/Visual | Select hunk (text object) |

#### LazyGit
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+lg` | Normal | Open LazyGit |

#### Debug Adapter (DAP)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+db` | Normal | Toggle breakpoint |
| `Space+dc` | Normal | Continue/Start debug |
| `Space+di` | Normal | Step into |
| `Space+do` | Normal | Step over |
| `Space+dO` | Normal | Step out |
| `Space+dr` | Normal | Toggle REPL |
| `Space+dl` | Normal | Run last |
| `Space+du` | Normal | Toggle debug UI |
| `Space+dt` | Normal | Terminate debug session |
| `Space+dR` | Normal | Open DAP REPL/Console |

#### Testing (neotest)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+tt` | Normal | Run nearest test |
| `Space+tf` | Normal | Run test file |
| `Space+ts` | Normal | Toggle test summary |
| `Space+tc` | Normal | Open test output |
| `Space+tl` | Normal | Run last test |
| `Space+td` | Normal | Debug nearest test with DAP |

#### Session Management (auto-session)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+wr` | Normal | Restore session for cwd |
| `Space+ws` | Normal | Save session |

#### Trouble (Diagnostics)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+xw` | Normal | Open workspace diagnostics |
| `Space+xd` | Normal | Open document diagnostics |
| `Space+xq` | Normal | Open quickfix list |
| `Space+xl` | Normal | Open location list |
| `Space+xt` | Normal | Open todos in trouble |

#### Flash (Motion)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `s` | Normal/Visual/Operator | Flash jump |
| `S` | Normal/Visual/Operator | Flash treesitter |
| `r` | Operator | Remote flash |
| `R` | Operator/Visual | Treesitter search |
| `Ctrl+s` | Command | Toggle flash search |

#### Substitute
| Shortcut | Mode | Description |
|----------|------|-------------|
| `s` | Normal | Substitute with motion |
| `ss` | Normal | Substitute line |
| `S` | Normal | Substitute to end of line |
| `s` | Visual | Substitute in visual mode |

#### Formatting
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+mp` | Normal/Visual | Format file or range |

#### Copilot
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Ctrl+L` | Insert | Accept Copilot suggestion |

#### Copilot Chat
| Shortcut | Mode | Description |
|----------|------|-------------|
| `Space+zc` | Normal | Chat with Copilot |
| `Space+ze` | Visual | Explain code |
| `Space+zn` | Visual | Review code |
| `Space+zf` | Visual | Fix code issues |
| `Space+zo` | Visual | Optimize code |
| `Space+zd` | Visual | Generate docs |
| `Space+zt` | Visual | Generate tests |
| `Space+zm` | Normal | Generate commit message |
| `Space+zs` | Visual | Generate commit for selection |

#### Surround (nvim-surround)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `ys{motion}{char}` | Normal | Add surround |
| `ds{char}` | Normal | Delete surround |
| `cs{target}{replacement}` | Normal | Change surround |
| `S{char}` | Visual | Surround selection |

#### Comment (Comment.nvim)
| Shortcut | Mode | Description |
|----------|------|-------------|
| `gcc` | Normal | Toggle line comment |
| `gbc` | Normal | Toggle block comment |
| `gc{motion}` | Normal | Comment with motion |
| `gc` | Visual | Comment selection |

### Yazi File Manager Shortcuts

#### Navigation
| Shortcut | Description |
|----------|-------------|
| `k` / `↑` | Previous file |
| `j` / `↓` | Next file |
| `h` / `←` | Go to parent directory |
| `l` / `→` / `Enter` | Enter directory / Open file |
| `H` | Go back in history |
| `L` | Go forward in history |
| `gg` | Go to top |
| `G` | Go to bottom |
| `Ctrl+u` | Move up half page |
| `Ctrl+d` | Move down half page |
| `Ctrl+b` | Move up one page |
| `Ctrl+f` | Move down one page |

#### Quick Navigation
| Shortcut | Description |
|----------|-------------|
| `gh` | Go to home directory |
| `gc` | Go to ~/.config |
| `gd` | Go to ~/Downloads |
| `g Space` | Jump interactively |
| `gf` | Follow symlink |
| `z` | Jump via fzf |
| `Z` | Jump via zoxide |

#### Selection
| Shortcut | Description |
|----------|-------------|
| `Space` | Toggle selection and move to next |
| `Ctrl+a` | Select all files |
| `Ctrl+r` | Invert selection |
| `v` | Enter visual mode (selection mode) |
| `V` | Enter visual mode (unset mode) |

#### File Operations
| Shortcut | Description |
|----------|-------------|
| `o` / `Enter` | Open selected files |
| `O` | Open selected files interactively |
| `y` | Yank (copy) selected files |
| `x` | Yank (cut) selected files |
| `p` | Paste yanked files |
| `P` | Paste yanked files (overwrite) |
| `Y` / `X` | Cancel yank status |
| `d` | Trash selected files |
| `D` | Permanently delete selected files |
| `a` | Create file/directory (end with / for directory) |
| `r` | Rename selected file(s) |
| `-` | Symlink absolute path |
| `_` | Symlink relative path |

#### Search and Filter
| Shortcut | Description |
|----------|-------------|
| `s` | Search files by name (fd) |
| `S` | Search files by content (ripgrep) |
| `Ctrl+s` | Cancel ongoing search |
| `f` | Filter files |
| `/` | Find next file |
| `?` | Find previous file |
| `n` | Next found |
| `N` | Previous found |

#### Copy Information
| Shortcut | Description |
|----------|-------------|
| `cc` | Copy file path |
| `cd` | Copy directory path |
| `cf` | Copy filename |
| `cn` | Copy filename without extension |

#### Sorting
| Shortcut | Description |
|----------|-------------|
| `,m` / `,M` | Sort by modified time / reverse |
| `,b` / `,B` | Sort by birth time / reverse |
| `,e` / `,E` | Sort by extension / reverse |
| `,a` / `,A` | Sort alphabetically / reverse |
| `,n` / `,N` | Sort naturally / reverse |
| `,s` / `,S` | Sort by size / reverse |
| `,r` | Sort randomly |

#### Display Modes (Linemode)
| Shortcut | Description |
|----------|-------------|
| `ms` | Show size |
| `mp` | Show permissions |
| `mb` | Show birth time |
| `mm` | Show modified time |
| `mo` | Show owner |
| `mn` | Show none |

#### Tab Management
| Shortcut | Description |
|----------|-------------|
| `t` | Create new tab with current directory |
| `1`-`9` | Switch to tab 1-9 |
| `[` | Switch to previous tab |
| `]` | Switch to next tab |
| `{` | Swap with previous tab |
| `}` | Swap with next tab |

#### Other
| Shortcut | Description |
|----------|-------------|
| `Esc` / `Ctrl+[` | Exit visual mode / Clear selection / Cancel search |
| `q` | Quit yazi |
| `Q` | Quit without outputting cwd-file |
| `Ctrl+c` | Close current tab or quit |
| `Ctrl+z` | Suspend process |
| `.` | Toggle hidden files |
| `;` | Run shell command |
| `:` | Run shell command (blocking) |
| `w` | Show task manager |
| `Tab` | Spot hovered file |
| `~` / `F1` | Open help |

### Zsh Shortcuts

#### History Navigation
| Shortcut | Description |
|----------|-------------|
| `↑` | Search backward in history |
| `↓` | Search forward in history |

#### Aliases
| Alias | Description |
|-------|-------------|
| `cd` | Smart directory jump (zoxide) |
| `ls` | List with icons (eza) |
| `lg` | Open LazyGit |
| `c` | Clear terminal |
| `x` | Exit terminal |
| `y` | Open Yazi file manager |
| `fuck` / `fk` | Correct previous command (thefuck) |

#### FZF Integration
| Shortcut | Description |
|----------|-------------|
| `Ctrl+t` | Fuzzy find files |
| `Ctrl+r` | Fuzzy search command history |
| `Alt+c` | Fuzzy change directory |

## License

Feel free to use and modify these dotfiles for your own setup!
