#!/bin/bash

set -e

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
            
            if ! brew list --cask font-meslo-lg-nerd-font &> /dev/null; then
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
            
            if ! fc-list | grep -qi "MesloLGS"; then
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
            
            if ! pacman -Qi ttf-meslo-nerd &> /dev/null; then
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
            ;;
            
        ubuntu)
            echo "Installing packages with apt..."
            sudo apt update
            
            sudo apt install -y tmux neovim fzf fd-find
            
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
                sudo apt install -y python3-pip
                pip3 install thefuck --user
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
            ;;
            
        arch)
            echo "Installing packages with pacman..."
            
            packages=(tmux neovim yazi lazygit fzf zoxide eza fd thefuck wezterm)
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

install_fzf_git() {
    echo ""
    echo "Installing fzf-git.sh..."
    
    if [ ! -f ~/.fzf-git.sh ]; then
        curl -o ~/.fzf-git.sh https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh
        echo "fzf-git.sh installed to ~/.fzf-git.sh"
    else
        echo "fzf-git.sh already exists"
    fi
}

setup_ohmyzsh() {
    echo ""
    echo "Setting up Oh My Zsh..."
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh My Zsh already installed"
    fi
    
    echo "Installing zsh plugins..."
    
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    else
        echo "zsh-autosuggestions already installed"
    fi
    
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
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
    
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        echo "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    else
        echo "Powerlevel10k already installed"
    fi
}

copy_dotfiles() {
    echo ""
    echo "Copying dotfiles..."
    
    echo "Copying .tmux.conf to home directory..."
    cp .tmux.conf ~/
    
    echo "Copying .wezterm.lua to home directory..."
    cp .wezterm.lua ~/
    
    echo "Copying nvim config to ~/.config/nvim/..."
    mkdir -p ~/.config/nvim
    cp -r .config/nvim/ ~/.config/
    
    echo "Copying zshrc config to ~/.config/zshrc/..."
    mkdir -p ~/.config/zshrc
    cp -r .config/zshrc/ ~/.config/
    
    if [ -f ~/.zshrc ]; then
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
}

run_p10k_configure() {
    echo ""
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

install_packages

install_font

install_wget_if_needed

install_fzf_git

setup_ohmyzsh

setup_powerlevel10k

copy_dotfiles

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
