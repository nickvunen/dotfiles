# AGENTS.md

Personal dotfiles repo (zsh + tmux + Neovim + WezTerm + opencode/Claude agent config + CLI tools). Target OSes: macOS, Ubuntu/Debian, Arch. No tests, no CI, no lint/format/typecheck config — validation is manual.

## Deployment model: copy into `$HOME`, symlinks respected

`setup-dotfiles.sh` copies files into `$HOME`. Editing a file in this repo does **not** change what the user's running shell/editor loads — unless that destination happens to be a symlink back into the repo. After edits, either:

- re-run `./setup-dotfiles.sh` (idempotent, safe), or
- copy the single touched file to its `$HOME` destination.

Mapping (see `copy_dotfiles()` in `setup-dotfiles.sh`):

| Repo path | Home path | Copy helper |
|---|---|---|
| `.tmux.conf` | `~/.tmux.conf` | `copy_unless_symlink` |
| `.wezterm.lua` | `~/.wezterm.lua` | `copy_unless_symlink` |
| `.zshenv` | `~/.zshenv` | `copy_unless_symlink` |
| `.config/nvim/` | `~/.config/nvim/` | `copy_config_dir` |
| `.config/zshrc/` | `~/.config/zshrc/` (sourced from `~/.zshrc`) | `copy_config_dir` |
| `.config/yazi/` | `~/.config/yazi/` | plain `cp -r` |
| `.config/thefuck/` | `~/.config/thefuck/` | plain `cp -r` |
| `.config/opencode/` | `~/.config/opencode/` | `cp -rn` (**no-clobber**) |
| `.config/claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | **symlink** (`link_path`) |
| `.config/codex/AGENTS.md`, `keybindings.json`, `skills/*` | `~/.codex/…` | **symlink** (`link_path`) |
| `.agents/skills/*` | `~/.agents/skills/…` | **symlink** (`link_path`) |
| `.config/claude/settings.json.template` | `~/.claude/settings.json` | `copy_if_missing` |
| `.config/codex/config.toml.template` | `~/.codex/config.toml` | `copy_if_missing` (`__HOME__` → `$HOME`) |

Copy-helper rules worth knowing before touching them:

- `copy_unless_symlink` / `copy_config_dir` skip the destination when it is a symlink or already resolves to the repo. Plain `cp` there aborts the `set -e` run with "are identical (not linked)".
- `copy_config_dir` deliberately omits the trailing slash on the source: `cp -r src/ dest/` would scatter the contents loose into `~/.config/`.
- opencode uses `cp -rn`, so **existing files in `~/.config/opencode/` are never overwritten**. Changing a tracked skill/command/agent file in this repo will not reach a machine that already has it. Copy it by hand.
- `copy_if_missing` seeds the Claude/Codex settings from templates only when absent, replacing `__HOME__` with `$HOME`. Live `settings.json` / `config.toml` hold per-machine state (trusted projects, app-injected MCP env) — update the template by hand, never symlink them.
- `.config/git/ignore` is tracked but **not** copied or wired up by the script.

## setup-dotfiles.sh conventions

- Flags: `--reinstall` (force reinstall of packages, re-run p10k wizard), `--agents-only` / `--claude-only` (run `link_agent_configs` and exit before anything else).
- OS dispatched via `detect_os()` into `macos` / `ubuntu` / `arch` branches inside the single large `install_packages()`. **Adding a tool requires editing all three branches** plus README's "What Gets Installed" table.
- Every install step is guarded (`command -v`, `brew list`, `pacman -Qi`, etc.) — keep new steps idempotent.
- Top-level call order at the bottom of the file is the real program; add new phases there, not inside unrelated functions.
- `cleanup_legacy_packer` removes `~/.local/share/nvim/site/pack/packer` — plugin manager is Lazy.nvim, not packer. Don't reintroduce packer configs.
- `copy_dotfiles` rewrites `~/.zshrc` down to a single `source ~/.config/zshrc/zshrc_extra` line (with timestamped backup) when it finds legacy Oh My Zsh boilerplate. `zshrc_extra` already does the full Oh My Zsh setup; never add a second `source $ZSH/oh-my-zsh.sh`.

## Neovim specifics

- Entry: `.config/nvim/init.lua` → `user.core` + `user.lazy`.
- Plugin manager: **Lazy.nvim** (`.config/nvim/lua/user/lazy.lua`). Imports `user.plugins` and `user.plugins.lsp`. New plugin = new file in `lua/user/plugins/` (auto-imported).
- `.config/nvim/lazy-lock.json` is committed — keep it in sync when bumping plugins.
- `.config/nvim/lua/user/plugins/dap-config.lua` is **gitignored** (personal debug configs). The tracked template is `dap-config.lua.example` — edit that, not a copy.

## opencode / Claude agent config

- `.config/opencode/AGENTS.md` is the user's **global** instruction file (C-3PO persona, memory rules, MR/ticket workflows). It is loaded in every opencode session, including sessions in this repo. Changing it changes agent behaviour everywhere, so treat edits as high-impact.
- Tracked: `opencode.json`, `AGENTS.md`, `cli.json`, `oh-my-opencode-slim.json`, `commands/`.
- Caveman style comes from `mcp/caveman/` (MCP server `instructions`), registered in `opencode.json` and via `claude mcp add`. Codex does not preload MCP instructions, so the same rules live in `.config/codex/AGENTS.md` — keep both in sync.
- Nested ignore file `.config/opencode/.gitignore` hides runtime/secret files: `node_modules`, `package.json`, `package-lock.json`, `bun.lock`, `.gitignore` itself, `service.json`. Root `.gitignore` additionally drops `weave-opencode.json`, `*.bak`, and app state that tools write into `.config/` (`acli/`, `configstore/`, `opencode-mobile/`, …).
- Plugin dependencies (`@opencode-ai/plugin`) are installed outside this repo's history and the setup script does not install them. Don't add a build/install step expecting it to exist.

## Gitignore traps

- `AGENTS.md` and `CLAUDE.md` are ignored **repo-wide**, with explicit negations only for `/AGENTS.md`, `.config/opencode/AGENTS.md`, `.config/claude/CLAUDE.md` and `.config/codex/AGENTS.md`. A new instruction file anywhere else is silently untracked — add a negation if it should be committed.
- Also ignored: `gh/`, `gh-copilot/`, `github-copilot/`, `htop/`, `btop/`, `iterm2/`, `yarn/`, `.config/uv/`, `.weave/`, `.gitconfig`, `*_history`, `*.log`, `*.bak*`. Local git identity is not managed from this repo.

## Keybindings

The README's `## Keyboard Shortcuts` section is the authoritative user-facing reference for tmux / nvim / yazi / zsh bindings. Any new mapping added in config must also be documented there. README's `## Configuration Files` table must also list any new copied config directory.

## Validation

- No unit tests. README documents Docker-based end-to-end checks for Ubuntu and Arch, plus a one-liner that asserts the opencode provider notice fires on a fresh install.
- For Neovim changes: `:checkhealth` and `:Lazy sync` are the real smoke tests.
- Syntax-check bash edits with `shellcheck setup-dotfiles.sh` if available; the script uses `set -e`, so a broken branch aborts the whole run.

## Do not rely on the pre-commit hook

`.git/hooks/pre-commit` is a stale install from another project (hard-coded `/Users/nickvanunen/Geoweb-backend/.../python3.11`) and passes `--skip-on-missing-config`. There is no `.pre-commit-config.yaml` here, so it is a no-op. Do not assume hooks enforce anything.

## Commit style

Short, lowercase, imperative subject. Mix of plain prose (`fix tmux continuum autosave`) and Conventional-ish, sometimes with a PR number (`fix(nvim): restore nvim-treesitter query directives on Neovim 0.12`, `Make setup script idempotent... (#5)`). Match whatever the current change is closer to; don't impose a stricter convention.

The working tree is often dirty with unrelated local-only config. Stage explicit paths; never `git add -A`.
