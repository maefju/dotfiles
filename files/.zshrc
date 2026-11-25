# ~/.zshrc (symlinked from ~/.dotfiles/files/.zshrc)

# -----------------------------------------------------
# Exports
# -----------------------------------------------------
export EDITOR=nvim
export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"

# -----------------------------------------------------
# History
# -----------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory hist_ignore_dups share_history

# -----------------------------------------------------
# Completion
# -----------------------------------------------------
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# -----------------------------------------------------
# Plugins (pacman: zsh-autosuggestions, zsh-syntax-highlighting)
# -----------------------------------------------------
for p in zsh-autosuggestions zsh-syntax-highlighting; do
  [[ -f /usr/share/zsh/plugins/$p/$p.zsh ]] && source /usr/share/zsh/plugins/$p/$p.zsh
done
unset p

# -----------------------------------------------------
# Tools
# -----------------------------------------------------
command -v fzf >/dev/null && source <(fzf --zsh)              # Ctrl+R fuzzy history
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"
command -v oh-my-posh >/dev/null && eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

# -----------------------------------------------------
# Aliases
# -----------------------------------------------------
alias ..='cd ..'
alias c='clear'
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias v='$EDITOR'
alias vim='$EDITOR'
alias wifi='nmtui'
alias lock='hyprlock'
alias shutdown='systemctl poweroff'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gst='git stash'
alias gsp='git stash; git pull'
alias gfo='git fetch origin'
alias gcheck='git checkout'
alias gcredential='git config credential.helper store'

alias dr="$HOME/dev/docker-restart.sh"

# -----------------------------------------------------
# SOT worktree helpers (create-wt / open-wt / rm-wt / list-wt)
# -----------------------------------------------------
[[ -f ~/dev/sot-worktree.zsh ]] && source ~/dev/sot-worktree.zsh
