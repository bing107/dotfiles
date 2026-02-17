# oh-my-zsh setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git z)
source $ZSH/oh-my-zsh.sh

# Editor
export EDITOR=nvim
export VISUAL=nvim

# Aliases (shared across all machines)
alias vim=nvim  vi=nvim  k=kubectl
alias cat="bat"  ls="eza --icons"  ll="eza -la --icons --git"  tree="eza --tree --icons"
alias dev="cd ~/development"  dots="cd ~/.dotfiles"
alias gs="git status"  glog="git log --oneline --graph --decorate -20"
alias zshrc="nvim ~/.dotfiles/zsh/.zshrc"
alias tmuxrc="nvim ~/.dotfiles/tmux/.config/tmux/tmux.conf"
alias nvimrc="nvim ~/.dotfiles/nvim/.config/nvim/init.lua"

# Tool inits (conditional — no errors if tool not installed)
[[ -f "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
command -v kubectl &>/dev/null && source <(kubectl completion zsh)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Zsh plugins (after SDKMAN to avoid function-not-found)
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Zoxide
eval "$(zoxide init zsh)"

# PATH
export PATH="$HOME/.local/bin:/opt/homebrew/opt/postgresql@16/bin:$PATH"

# Hide user@host in agnoster prompt
export DEFAULT_USER=$USER
prompt_context(){}

# Machine-specific overrides (not in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Secrets (not in git)
[[ -f ~/.env.secrets ]] && source ~/.env.secrets

# Auto-start tmux
if [[ -z "$TMUX" && -z "$SSH_CONNECTION" && "$TERM_PROGRAM" != "vscode" && -t 0 ]]; then
  tmux new-session -A -s main
fi
