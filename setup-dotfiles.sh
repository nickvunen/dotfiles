#!/bin/bash

set -e

REINSTALL=false

if [[ "$1" == "--reinstall" ]]; then
    REINSTALL=true
    echo "Reinstall mode enabled - will reinstall all packages"
fi

echo "=== Dotfiles Setup Script ==="
echo ""

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]] || [[ "$ID_LIKE" == *"ubuntu"* ]] || [[ "$ID_LIKE" == *"debian"* ]]; then
            echo "ubuntu"
        elif [[ "$ID" == "arch" ]] || [[ "$ID_LIKE" == *"arch"* ]]; then
            echo "arch"
        else
            echo "unknown"
        fi
    else
        echo "unknown"
    fi
}

prompt_optional_packages() {
    echo ""
    echo "=== Optional Packages ==="
    echo "Ollama is a large package (1GB+) and requires sufficient CPU/GPU resources."
    echo ""
    read -p "Do you want to install Ollama? (y/n) [default: n]: " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_OLLAMA=true
    else
        INSTALL_OLLAMA=false
    fi
}

check_and_switch_to_zsh() {
    echo "Checking current shell..."
    CURRENT_SHELL=$(basename "$SHELL")
    
    if [ "$CURRENT_SHELL" = "bash" ]; then
        echo "Current shell is bash. Switching to zsh..."
        
        if ! command -v zsh &> /dev/null; then
            echo "zsh not found. Installing zsh..."
            install_zsh
        fi
        
        ZSH_PATH=$(which zsh)
        echo "Changing default shell to zsh..."
        chsh -s "$ZSH_PATH"
        echo "Default shell changed to zsh. You'll need to restart your terminal for this to take effect."
    elif [ "$CURRENT_SHELL" = "zsh" ]; then
        echo "Already using zsh. Continuing..."
    else
        echo "Current shell is $CURRENT_SHELL. Switching to zsh..."
        
        if ! command -v zsh &> /dev/null; then
            echo "zsh not found. Installing zsh..."
            install_zsh
        fi
        
        ZSH_PATH=$(which zsh)
        chsh -s "$ZSH_PATH"
        echo "Default shell changed to zsh. You'll need to restart your terminal for this to take effect."
    fi
}

install_zsh() {
    OS=$(detect_os)
    case "$OS" in
        macos)
            brew install zsh
            ;;
        ubuntu)
            sudo apt update
            sudo apt install -y zsh
            ;;
        arch)
            sudo pacman -S --noconfirm zsh
            ;;
        *)
            echo "Unknown OS. Please install zsh manually."
            exit 1
            ;;
    esac
}

install_font() {
    OS=$(detect_os)
    echo ""
    echo "Installing MesloLGS Nerd Font Mono..."

    case "$OS" in
        macos)
            echo "Installing font with Homebrew..."

            if [ "$REINSTALL" = true ] || ! brew list --cask font-meslo-lg-nerd-font &> /dev/null; then
                brew install --cask font-meslo-lg-nerd-font
                echo "MesloLGS Nerd Font installed successfully"
            else
                echo "MesloLGS Nerd Font already installed"
            fi
            ;;
            
        ubuntu)
            echo "Installing font manually..."

            FONT_DIR="$HOME/.local/share/fonts"
            mkdir -p "$FONT_DIR"

            if [ "$REINSTALL" = true ] || ! fc-list | grep -qi "MesloLGS"; then
                echo "Downloading MesloLGS Nerd Font..."
                FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
                if curl -fLo /tmp/Meslo.zip "$FONT_URL"; then
                    unzip -o /tmp/Meslo.zip -d "$FONT_DIR"
                    rm /tmp/Meslo.zip
                    fc-cache -fv
                    echo "MesloLGS Nerd Font installed successfully"
                else
                    echo "Failed to download font. Please install manually from:"
                    echo "  https://github.com/ryanoasis/nerd-fonts/releases"
                fi
            else
                echo "MesloLGS Nerd Font already installed"
            fi
            ;;
            
        arch)
            echo "Installing font with pacman..."

            if [ "$REINSTALL" = true ] || ! pacman -Qi ttf-meslo-nerd &> /dev/null; then
                sudo pacman -S --noconfirm ttf-meslo-nerd
                echo "MesloLGS Nerd Font installed successfully"
            else
                echo "MesloLGS Nerd Font already installed"
            fi
            ;;
            
        *)
            echo "Unknown OS. Please install MesloLGS Nerd Font manually:"
            echo "  - Download from: https://github.com/ryanoasis/nerd-fonts/releases"
            echo "  - Or visit: https://www.nerdfonts.com/font-downloads"
            ;;
    esac
}

install_packages() {
    OS=$(detect_os)
    echo ""
    echo "Detected OS: $OS"
    echo "Installing required packages..."
    
    case "$OS" in
        macos)
            echo "Installing packages with Homebrew..."
            
            if ! command -v brew &> /dev/null; then
                echo "Homebrew not found. Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            packages=(tmux neovim yazi lazygit fzf zoxide eza fd thefuck wezterm)
            for package in "${packages[@]}"; do
                if ! brew list "$package" &> /dev/null; then
                    echo "Installing $package..."
                    brew install "$package"
                else
                    echo "$package already installed"
                fi
            done
            
            if ! command -v opencode &> /dev/null; then
                echo "Installing opencode..."
                curl -fsSL https://opencode.ai/install | bash
            else
                echo "opencode already installed"
            fi
            
            if [ "$INSTALL_OLLAMA" = true ]; then
                if ! command -v ollama &> /dev/null; then
                    echo "Installing ollama..."
                    brew install ollama
                else
                    echo "ollama already installed"
                fi
            else
                echo "Skipping ollama installation (optional)"
            fi
            ;;

        ubuntu)
            echo "Installing packages with apt..."
            sudo apt update

            sudo apt install -y tmux neovim fzf fd-find sysstat bc zstd
            
            if ! command -v yazi &> /dev/null; then
                echo "Installing yazi..."
                cargo install --locked yazi-fm yazi-cli 2>/dev/null || {
                    echo "Cargo not found. Installing via alternative method..."
                    wget https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip -O /tmp/yazi.zip
                    unzip /tmp/yazi.zip -d /tmp/yazi
                    sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
                    rm -rf /tmp/yazi /tmp/yazi.zip
                }
            fi
            
            if ! command -v lazygit &> /dev/null; then
                echo "Installing lazygit..."
                LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                tar xf /tmp/lazygit.tar.gz -C /tmp/
                sudo install /tmp/lazygit /usr/local/bin
                rm /tmp/lazygit /tmp/lazygit.tar.gz
            fi
            
            if ! command -v zoxide &> /dev/null; then
                echo "Installing zoxide..."
                curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
            fi
            
            if ! command -v eza &> /dev/null; then
                echo "Installing eza..."
                sudo apt install -y gpg
                sudo mkdir -p /etc/apt/keyrings
                wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
                echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
                sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
                sudo apt update
                sudo apt install -y eza
            fi
            
            if ! command -v thefuck &> /dev/null; then
                echo "Installing thefuck..."
                if ! command -v pipx &> /dev/null; then
                    echo "Installing pipx..."
                    sudo apt install -y pipx
                fi
                pipx install thefuck
            fi
            
            if ! command -v wezterm &> /dev/null; then
                echo "Installing wezterm..."
                curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
                echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
                sudo apt update
                sudo apt install -y wezterm
            fi
            
            if ! command -v opencode &> /dev/null; then
                echo "Installing opencode..."
                curl -fsSL https://opencode.ai/install | bash
            else
                echo "opencode already installed"
            fi
            
            if [ "$INSTALL_OLLAMA" = true ]; then
                if ! command -v ollama &> /dev/null; then
                    echo "Installing ollama..."
                    curl -fsSL https://ollama.com/install.sh | sh
                else
                    echo "ollama already installed"
                fi
            else
                echo "Skipping ollama installation (optional)"
            fi
            ;;

        arch)
            echo "Installing packages with pacman..."
            
            packages=(tmux neovim yazi lazygit fzf zoxide eza fd thefuck wezterm sysstat bc)
            for package in "${packages[@]}"; do
                if ! pacman -Qi "$package" &> /dev/null; then
                    echo "Installing $package..."
                    sudo pacman -S --noconfirm "$package"
                else
                    echo "$package already installed"
                fi
            done
            
            if ! command -v opencode &> /dev/null; then
                echo "Installing opencode..."
                curl -fsSL https://opencode.ai/install | bash
            else
                echo "opencode already installed"
            fi
            
            if [ "$INSTALL_OLLAMA" = true ]; then
                if ! pacman -Qi ollama &> /dev/null; then
                    echo "Installing ollama..."
                    sudo pacman -S --noconfirm ollama
                else
                    echo "ollama already installed"
                fi
            else
                echo "Skipping ollama installation (optional)"
            fi
            ;;

        *)
            echo "Unknown OS. Please install packages manually:"
            echo "  - tmux"
            echo "  - neovim (nvim)"
            echo "  - yazi"
            echo "  - lazygit"
            echo "  - fzf"
            echo "  - zoxide"
            echo "  - eza"
            echo "  - fd"
            echo "  - thefuck"
            echo "  - wezterm"
            echo "  - opencode"
            read -p "Press enter to continue with dotfiles setup..."
            ;;
    esac
}

setup_tmux_plugins() {
    echo ""
    echo "Setting up tmux plugins..."

    TPM_DIR="$HOME/.tmux/plugins/tpm"

    if [ "$REINSTALL" = true ] || [ ! -d "$TPM_DIR" ]; then
        echo "Cloning TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    else
        echo "TPM already installed"
    fi

    if [ -f "$HOME/.tmux.conf" ] && [ -x "$TPM_DIR/bin/install_plugins" ]; then
        echo "Installing tmux plugins via TPM..."
        "$TPM_DIR/bin/install_plugins" || echo "Plugin install hit an issue; run 'prefix + I' inside tmux to retry."
    fi
}

cleanup_legacy_packer() {
    echo ""
    echo "Cleaning up legacy packer directory (migrating to Lazy.nvim)..."
    
    PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer"
    if [ -d "$PACKER_DIR" ]; then
        echo "Removing legacy packer directory: $PACKER_DIR"
        rm -rf "$PACKER_DIR"
        echo "Legacy packer directory removed successfully"
    else
        echo "No legacy packer directory found (already clean)"
    fi
}

install_neovim_providers() {
    echo ""
    echo "Installing Neovim providers..."
    
    # Install npm neovim module for Node.js provider
    if command -v npm &> /dev/null; then
        if ! npm list -g neovim &> /dev/null; then
            echo "Installing npm neovim module..."
            npm install -g neovim
        else
            echo "npm neovim module already installed"
        fi
    else
        echo "npm not found. Skipping Node.js provider installation."
        echo "Install Node.js and npm, then run: npm install -g neovim"
    fi
    
    # Install pip neovim module for Python provider
    if command -v pip3 &> /dev/null; then
        if ! pip3 show pynvim &> /dev/null; then
            echo "Installing pynvim (Python neovim module)..."
            pip3 install pynvim --user
        else
            echo "pynvim (Python neovim module) already installed"
        fi
    elif command -v pip &> /dev/null; then
        if ! pip show pynvim &> /dev/null; then
            echo "Installing pynvim (Python neovim module)..."
            pip install pynvim --user
        else
            echo "pynvim (Python neovim module) already installed"
        fi
    else
        echo "pip not found. Skipping Python provider installation."
        echo "Install Python and pip, then run: pip3 install pynvim"
    fi
    
    # Install Ruby neovim module for Ruby provider (optional)
    if command -v ruby &> /dev/null && command -v gem &> /dev/null; then
        if ! gem list neovim -i &> /dev/null; then
            echo "Installing Ruby neovim module..."
            gem install neovim
        else
            echo "Ruby neovim module already installed"
        fi
    else
        echo "Ruby not found. Skipping Ruby provider installation (optional)."
    fi
}

install_wget_if_needed() {
    OS=$(detect_os)
    echo ""
    echo "Checking wget installation (required for Mason/tooling)..."

    if command -v wget &> /dev/null; then
        echo "wget already installed"
        return
    fi

    echo "Installing wget..."
    case "$OS" in
        macos)
            brew install wget
            ;;
        ubuntu)
            sudo apt install -y wget
            ;;
        arch)
            sudo pacman -S --noconfirm wget
            ;;
        *)
            echo "Unknown OS. Please install wget manually."
            ;;
    esac
}

install_unzip_if_needed() {
    OS=$(detect_os)
    echo ""
    echo "Checking unzip installation (required for extracting archives)..."

    if command -v unzip &> /dev/null; then
        echo "unzip already installed"
        return
    fi

    echo "Installing unzip..."
    case "$OS" in
        macos)
            brew install unzip
            ;;
        ubuntu)
            sudo apt install -y unzip
            ;;
        arch)
            sudo pacman -S --noconfirm unzip
            ;;
        *)
            echo "Unknown OS. Please install unzip manually."
            ;;
    esac
}

install_fzf_git() {
    echo ""
    echo "Installing fzf-git.sh..."

    if [ "$REINSTALL" = true ] || [ ! -f ~/.fzf-git.sh ]; then
        curl -o ~/.fzf-git.sh https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh
        echo "fzf-git.sh installed to ~/.fzf-git.sh"
    else
        echo "fzf-git.sh already exists"
    fi
}

setup_ohmyzsh() {
    echo ""
    echo "Setting up Oh My Zsh..."

    if [ "$REINSTALL" = true ] || [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh My Zsh already installed"
    fi

    echo "Installing zsh plugins..."

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [ "$REINSTALL" = true ] || [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    else
        echo "zsh-autosuggestions already installed"
    fi

    if [ "$REINSTALL" = true ] || [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        echo "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    else
        echo "zsh-syntax-highlighting already installed"
    fi
}

setup_powerlevel10k() {
    echo ""
    echo "Setting up Powerlevel10k..."

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [ "$REINSTALL" = true ] || [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        echo "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    else
        echo "Powerlevel10k already installed"
    fi
}

copy_if_missing() {
    local src="$1"
    local dest="$2"
    if [ ! -f "$src" ]; then
        echo "  [ERROR] template not found: $src"
        return 1
    fi
    if [ -e "$dest" ]; then
        echo "  [skipped] $dest (already exists)"
    elif cp "$src" "$dest"; then
        echo "  [created] $dest"
    else
        echo "  [ERROR] failed to copy $src -> $dest"
        return 1
    fi
}

# Copy a file into place unless the destination is already a symlink. Some
# machines symlink these back into the repo instead of copying; plain `cp`
# follows the symlink and resolves to the source itself, failing with
# "cp: <src> and <dest> are identical (not linked)" and aborting the run.
copy_unless_symlink() {
    local src="$1"
    local dest="$2"
    if [ -L "$dest" ]; then
        echo "  [skipped] $dest is a symlink -> $(readlink "$dest")"
        return 0
    fi
    if cp "$src" "$dest"; then
        echo "  [copied] $dest"
    else
        echo "  [ERROR] failed to copy $src -> $dest"
        return 1
    fi
}

# Copy a directory from the repo into ~/.config/.
#
# Two traps this avoids:
#   1. `cp -r src/ dest/` (trailing slash) makes BSD cp copy the *contents* of
#      src into dest, scattering init.lua/lua/... loose in ~/.config instead of
#      creating ~/.config/<name>. The trailing slash is deliberately omitted.
#   2. Some machines symlink ~/.config straight at this repo, so the source and
#      destination are literally the same directory and copying would duplicate
#      the tree into itself.
copy_config_dir() {
    local src="$1"
    local name
    name="$(basename "$src")"
    local dest="$HOME/.config/$name"

    if [ "$(cd "$src" 2>/dev/null && pwd -P)" = "$(cd "$dest" 2>/dev/null && pwd -P)" ]; then
        echo "  [skipped] $dest already resolves to $src"
        return 0
    fi

    mkdir -p "$HOME/.config"
    if cp -r "$src" "$HOME/.config/"; then
        echo "  [copied] $dest"
    else
        echo "  [ERROR] failed to copy $src -> $dest"
        return 1
    fi
}

copy_dotfiles() {
    echo ""
    echo "Copying dotfiles..."

    echo "Copying .tmux.conf to home directory..."
    copy_unless_symlink .tmux.conf ~/.tmux.conf

    echo "Copying .wezterm.lua to home directory..."
    copy_unless_symlink .wezterm.lua ~/.wezterm.lua

    echo "Copying .zshenv to home directory..."
    copy_unless_symlink .zshenv ~/.zshenv

    echo "Copying nvim config to ~/.config/nvim/..."
    copy_config_dir .config/nvim

    echo "Copying zshrc config to ~/.config/zshrc/..."
    copy_config_dir .config/zshrc

    # zshrc_extra already contains a full Oh My Zsh setup (theme, plugins,
    # instant prompt block, compinit-safe fpath handling). If ~/.zshrc is a
    # pre-existing file (e.g. from Oh My Zsh's own installer) that still has
    # its own `source $ZSH/oh-my-zsh.sh` call, appending our source line would
    # make Oh My Zsh - and compinit - load twice per shell start: once from
    # the leftover boilerplate, once from zshrc_extra. That's slow and can
    # double up compinit warnings. Detect that case and collapse ~/.zshrc down
    # to just the source line, backing up the original first.
    if [ -f ~/.zshrc ] && grep -q 'source \$ZSH/oh-my-zsh\.sh' ~/.zshrc; then
        BACKUP=~/.zshrc.pre-dotfiles-backup-$(date +%Y%m%d%H%M%S)
        echo "Found legacy Oh My Zsh boilerplate in ~/.zshrc (sources oh-my-zsh.sh directly)."
        echo "Backing up to $BACKUP and replacing with a single source line..."
        cp ~/.zshrc "$BACKUP"
        echo "source ~/.config/zshrc/zshrc_extra" > ~/.zshrc
    elif [ -f ~/.zshrc ]; then
        if ! grep -q "source ~/.config/zshrc/zshrc_extra" ~/.zshrc; then
            echo "Adding source line to ~/.zshrc..."
            echo "" >> ~/.zshrc
            echo "source ~/.config/zshrc/zshrc_extra" >> ~/.zshrc
        else
            echo "Source line already exists in ~/.zshrc, skipping..."
        fi
    else
        echo "Creating ~/.zshrc and adding source line..."
        echo "source ~/.config/zshrc/zshrc_extra" > ~/.zshrc
    fi
    
    echo "Copying yazi config to ~/.config/yazi/..."
    mkdir -p ~/.config/yazi
    cp -r .config/yazi/ ~/.config/
    
    echo "Copying thefuck config to ~/.config/thefuck/..."
    mkdir -p ~/.config/thefuck
    cp -r .config/thefuck/ ~/.config/

    echo "Copying opencode config to ~/.config/opencode/ (no-clobber)..."
    mkdir -p ~/.config/opencode
    # -n preserves any local opencode.json / weave-opencode.json the user has
    # already created (those files are gitignored — see README "Post-Installation
    # Authentication" for how to set them up).
    cp -rn .config/opencode/. ~/.config/opencode/
    copy_if_missing "$HOME/.config/opencode/opencode.json.template" "$HOME/.config/opencode/opencode.json"
    copy_if_missing "$HOME/.config/opencode/weave-opencode.json.template" "$HOME/.config/opencode/weave-opencode.json"
}

check_opencode_provider() {
    local cfg="$HOME/.config/opencode/opencode.json"
    if [ -f "$cfg" ] && ! grep -q '"provider"' "$cfg"; then
        echo ""
        echo "╔══════════════════════════════════════════════════════════════╗"
        echo "║          ACTION REQUIRED: opencode provider not set          ║"
        echo "╠══════════════════════════════════════════════════════════════╣"
        echo "║  ~/.config/opencode/opencode.json has no \"provider\" key.     ║"
        echo "║                                                              ║"
        echo "║  To fix, either:                                             ║"
        echo "║    opencode auth login                                       ║"
        echo "║  or hand-edit the file and add your provider config.         ║"
        echo "║                                                              ║"
        echo "║  Docs: https://opencode.ai/docs/providers                   ║"
        echo "╚══════════════════════════════════════════════════════════════╝"
        echo ""
    fi
}

run_p10k_configure() {
    echo ""

    if [ "$REINSTALL" = false ] && [ -f "$HOME/.p10k.zsh" ]; then
        echo "Powerlevel10k is already configured (found ~/.p10k.zsh)"
        echo "Skipping configuration wizard."
        return
    fi

    echo "=== Powerlevel10k Configuration ==="
    echo "The configuration wizard will now start."
    echo "This will help you customize your prompt appearance."
    echo ""
    read -p "Press enter to start p10k configuration wizard..."

    if command -v zsh &> /dev/null; then
        zsh -i -c "source ~/.zshrc 2>/dev/null; p10k configure"
    else
        echo "Zsh not available. Please run 'p10k configure' manually after restarting your terminal."
    fi
}

check_and_switch_to_zsh

prompt_optional_packages

install_unzip_if_needed

install_packages

install_font

install_wget_if_needed

install_fzf_git

setup_ohmyzsh

setup_powerlevel10k

copy_dotfiles

check_opencode_provider

setup_tmux_plugins

cleanup_legacy_packer

install_neovim_providers

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Dotfiles have been set up successfully!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: exec zsh"
echo "2. The Powerlevel10k configuration wizard will start automatically"
echo "3. If it doesn't start, run: p10k configure"
echo ""

run_p10k_configure
