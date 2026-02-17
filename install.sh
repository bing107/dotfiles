#!/bin/bash
# Dotfiles bootstrap script
# Usage: git clone git@github.com:bing107/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Starting dotfiles setup..."

# 1. Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "==> Homebrew already installed"
fi

# 2. Install packages from Brewfile
echo "==> Installing Homebrew packages..."
brew bundle --file="$DOTFILES/Brewfile"

# 3. Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing oh-my-zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # Remove the default .zshrc that oh-my-zsh creates (stow will link ours)
  rm -f "$HOME/.zshrc"
else
  echo "==> oh-my-zsh already installed"
fi

# 4. Stow dotfiles
echo "==> Linking dotfiles with stow..."
cd "$DOTFILES"
# Remove .zshrc only if it's a real file (not a symlink from a previous stow run)
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && rm -f "$HOME/.zshrc"
stow --restow --target="$HOME" zsh tmux

# 5. Kickstart.nvim
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "==> Cloning kickstart.nvim..."
  git clone https://github.com/nvim-lua/kickstart.nvim.git "$HOME/.config/nvim"
fi
# Remove files that stow will manage so it can link over them
for f in $(cd "$DOTFILES/nvim" && find . -type f); do
  rm -f "$HOME/$f"
done
stow --restow --target="$HOME" nvim

# 6. TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  echo "==> Installing TPM..."
  mkdir -p "$HOME/.config/tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
else
  echo "==> TPM already installed"
fi

# 7. Catppuccin tmux theme (manual — TPM has a naming conflict with this plugin)
if [ ! -d "$HOME/.config/tmux/plugins/catppuccin" ]; then
  echo "==> Installing Catppuccin tmux theme..."
  mkdir -p "$HOME/.config/tmux/plugins/catppuccin"
  git clone https://github.com/catppuccin/tmux.git "$HOME/.config/tmux/plugins/catppuccin/tmux"
else
  echo "==> Catppuccin tmux theme already installed"
fi

# 7. NVM
if [ ! -d "$HOME/.nvm" ]; then
  echo "==> Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
  echo "==> NVM already installed"
fi

# 8. fzf keybindings
if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
  echo "==> Setting up fzf keybindings..."
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# 9. Secrets template
if [ ! -f "$HOME/.env.secrets" ]; then
  echo "==> Creating secrets template..."
  cat > "$HOME/.env.secrets" <<'EOF'
# API keys and tokens — this file is NOT tracked by git
# export OPENAI_API_KEY=""
# export ANTHROPIC_API_KEY=""
EOF
fi

echo ""
echo "==> Done! Next steps:"
echo "  1. Open a new terminal — tmux will auto-start"
echo "  2. In tmux, press C-a I to install remaining tmux plugins (battery, etc.)"
echo "  3. Edit ~/.env.secrets to add your API keys"
echo "  4. (Optional) Create ~/.zshrc.local for machine-specific config"
