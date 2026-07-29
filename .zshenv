# Skip the unconditional `compinit` that Debian/Ubuntu's /etc/zsh/zshrc runs
# before ~/.zshrc is even read. Oh My Zsh (sourced from ~/.config/zshrc/zshrc_extra)
# calls compinit itself, later, against an fpath that's already been filtered
# to drop dead vendor-completions symlinks (e.g. Docker Desktop's WSL
# integration when Docker Desktop isn't running). Without this, that early
# system compinit call scans the unfiltered fpath and warns on every shell start.
skip_global_compinit=1
