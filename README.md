# Dotfiles

Personal macOS development environment managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
git clone git@github.com:bing107/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

The bootstrap script handles everything: Homebrew, packages, oh-my-zsh, symlinks, Neovim, tmux plugins, NVM, and fzf. After it finishes, open a new terminal and you're ready to go.

## What's Included

### Zsh (`zsh/.zshrc`)

- **Theme:** agnoster (requires a Nerd Font)
- **Plugins:** git, z (directory jumping)
- **Modern CLI replacements:**
  - `cat` -> [bat](https://github.com/sharkdp/bat)
  - `ls` / `ll` / `tree` -> [eza](https://github.com/eza-community/eza)
- **Aliases:**
  | Alias | Command |
  |-------|---------|
  | `vim` / `vi` | `nvim` |
  | `k` | `kubectl` |
  | `dev` | `cd ~/development` |
  | `dots` | `cd ~/.dotfiles` |
  | `gs` | `git status` |
  | `glog` | `git log --oneline --graph --decorate -20` |
  | `zshrc` | Edit `.zshrc` in nvim |
  | `tmuxrc` | Edit `tmux.conf` in nvim |
  | `nvimrc` | Edit nvim `init.lua` in nvim |
- **Tool inits** (conditional — no errors if not installed): NVM, SDKMAN, kubectl completion, fzf
- **Zsh plugins** (via Homebrew): zsh-autocomplete, zsh-autosuggestions, zsh-syntax-highlighting
- **Auto-starts tmux** on new interactive shells (skipped inside VS Code, SSH, or existing tmux sessions)

### Tmux (`tmux/.config/tmux/tmux.conf`)

- **Prefix:** `C-a` (instead of default `C-b`)
- **Theme:** [Catppuccin Mocha](https://github.com/catppuccin/tmux) with battery, directory, session, and date/time in the status bar
- **Status bar** at the top
- **Mouse support** enabled (click panes, drag to resize)
- **Vim-style pane switching:** `C-a h/j/k/l`
- **Reload config:** `C-a r`
- **Plugin manager:** [TPM](https://github.com/tmux-plugins/tpm) (auto-installs on first run)

### Neovim (`nvim/.config/nvim/`)

Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) with custom plugins:
- autotag
- lspsaga

## Repository Structure

```
~/.dotfiles/
├── Brewfile                          # Homebrew packages
├── install.sh                        # Bootstrap script
├── zsh/
│   └── .zshrc                        # -> ~/.zshrc
├── tmux/
│   └── .config/tmux/tmux.conf        # -> ~/.config/tmux/tmux.conf
└── nvim/
    └── .config/nvim/                  # -> ~/.config/nvim/
        ├── init.lua
        └── lua/custom/plugins/
```

Each top-level directory (`zsh/`, `tmux/`, `nvim/`) is a stow package. Running `stow zsh` from `~/.dotfiles` creates a symlink from `~/.zshrc` pointing to `~/.dotfiles/zsh/.zshrc`, and so on.

## Machine-Specific Config

Configs that shouldn't be shared across machines go in these files (not tracked by git):

| File | Purpose |
|------|---------|
| `~/.zshrc.local` | Machine-specific aliases and overrides |
| `~/.env.secrets` | API keys and tokens |

Both are sourced automatically by `.zshrc` if they exist.

## Manual Steps After Install

1. **Install tmux plugins:** Open tmux, press `C-a I` (capital I)
2. **Set your terminal font** to a Nerd Font (e.g., Hack Nerd Font or Ubuntu Nerd Font)
3. **Add secrets:** Edit `~/.env.secrets` with your API keys
4. **Install Node.js:** `nvm install --lts`

## Adding/Removing Packages

Edit the `Brewfile` and run:

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

## Managing Dotfiles

```bash
# Link a package
cd ~/.dotfiles && stow zsh

# Unlink a package
cd ~/.dotfiles && stow -D zsh

# Re-link after changes (unlink + link)
cd ~/.dotfiles && stow -R zsh
```
