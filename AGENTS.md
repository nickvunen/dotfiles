# AGENTS.md

Personal dotfiles repo (zsh + tmux + Neovim + WezTerm + CLI tools). Target OSes: macOS, Ubuntu/Debian, Arch. No tests, no CI, no lint/format/typecheck config — validation is manual.

## Deployment model: copy, not symlink

`setup-dotfiles.sh` uses `cp -r` to push files into `$HOME`. Editing a file in this repo does **not** change what the user's running shell/editor loads. After edits, either:

- re-run `./setup-dotfiles.sh` (idempotent, safe), or
- manually copy the single touched file to its `$HOME` destination.

Mapping (see `copy_dotfiles` in `setup-dotfiles.sh:419`):

| Repo path | Home path |
|---|---|
| `.tmux.conf` | `~/.tmux.conf` |
| `.wezterm.lua` | `~/.wezterm.lua` |
| `.config/nvim/` | `~/.config/nvim/` |
| `.config/zshrc/` | `~/.config/zshrc/` (sourced from `~/.zshrc`) |
| `.config/yazi/` | `~/.config/yazi/` |
| `.config/thefuck/` | `~/.config/thefuck/` |

`.config/git/` and `.config/opencode/` live in the repo but are not copied by the script.

## setup-dotfiles.sh conventions

- OS dispatched via `detect_os()` into `macos` / `ubuntu` / `arch` branches. **Adding a tool requires editing all three branches** plus README's "What Gets Installed" table.
- Every install step is guarded (`command -v`, `brew list`, `pacman -Qi`, etc.) — keep new steps idempotent.
- The script also cleans legacy `~/.local/share/nvim/site/pack/packer` — plugin manager is Lazy.nvim, not packer. Don't reintroduce packer configs.

## Neovim specifics

- Entry: `.config/nvim/init.lua` → `user.core` + `user.lazy`.
- Plugin manager: **Lazy.nvim** (`.config/nvim/lua/user/lazy.lua`). Imports `user.plugins` and `user.plugins.lsp`. New plugin = new file in `lua/user/plugins/` (auto-imported).
- `.config/nvim/lazy-lock.json` is committed — keep it in sync when bumping plugins.
- `.config/nvim/lua/user/plugins/dap-config.lua` is **gitignored** (personal debug configs). The tracked template is `dap-config.lua.example` — edit that, not a copy.

## Keybindings

The README's `## Keyboard Shortcuts` section is the authoritative user-facing reference for tmux / nvim / yazi / zsh bindings. Any new mapping added in config must also be documented there.

## Gitignored under `.config/`

`gh/`, `gh-copilot/`, `github-copilot/`, `htop/`, `btop/`, `iterm2/`, `opencode/`, `yarn/` — do not commit these even if they exist locally. Local `.gitconfig` is ignored too; commit-time git identity is not managed from this repo.

## Validation

- No unit tests. The README documents Docker-based end-to-end checks for Ubuntu and Arch (`docker run ... ubuntu:22.04 ...`).
- For Neovim changes: `:checkhealth` and `:Lazy sync` are the real smoke tests.
- Syntax-check bash edits with `shellcheck setup-dotfiles.sh` if available; the script uses `set -e` so a broken branch surfaces fast.

## Do not rely on the pre-commit hook

`.git/hooks/pre-commit` is a stale install from another project (hard-coded `/Users/nickvanunen/Geoweb-backend/.../python3.11`) and passes `--skip-on-missing-config`. There is no `.pre-commit-config.yaml` in this repo, so it is a no-op. Do not assume hooks enforce anything.

## Commit style

Short, lowercase, imperative subject. Mix of prose (`fix zsh in tmux to always load`) and Conventional-ish with PR numbers (`Remove Brave browser installation from setup script (#4)`). Match whatever the current change is closer to; don't impose a stricter convention.
