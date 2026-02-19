export PATH=$PATH:~/repos/dotfiles/bin
export PATH=$PATH:/opt/homebrew/bin

# ALIASES
alias ai='llm'
alias cl='clear'
alias h='cd $HOME'
alias lg='lazygit'
alias ll='ls -lah'
alias pn='pnpm'
alias sz='source ~/.zshrc'
alias v='nvim'
alias z="source $HOME/.zshrc"

# Filesystem shortcuts
alias cdots="cd $HOME/repos/dotfiles"
alias dots="cd $HOME/repos/dotfiles/ && nvim ./README.md"
alias lab="cd $HOME/repos/homelab"
alias repos="cd $HOME/repos"

# fzf helpers
# (g)it (b)ranch
alias gb="git branch --all | sed "s/^..//" | fzf"
# (g)it (m)erge
alias gm="git branch --all | sed "s/^..//" | fzf | xargs git merge"
# (g)it (c)heckout local branches
alias gco="git branch | sed "s/^..//" | fzf | xargs git switch"
# (g)it (c)heckout (r)emote branches
alias gcr="git branch --all | sed "s/^..//" | fzf | xargs git switch"

# Colorize with grc
alias ls='grc ls'
alias ifconfig='grc ifconfig'
alias df='grc df'
alias whois='grc whois'
alias ping='grc ping'
alias traceroute='grc traceroute'
alias ps='grc ps'
alias nmap='grc nmap'
alias netstat='grc netstat'
alias dig='grc dig'

# Obsidian
export OBSIDIAN_VAULT='$HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Obsidian\ Vaults/techn0tes/'
# (o)pen (o)bsidian
alias oo="$OBSIDIAN_VAULT && nvim ."
# (o)pen inbox files for (r)
alias or="$OBSIDIAN_VAULT/inbox/*.md"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Add SSH keys to ssh-agent
eval $(ssh-agent -s)
ssh-add

# LOAD PRIVATE CONFIG
if [ -f "$HOME/.zshrc.private" ]; then
  source "$HOME/.zshrc.private"
fi

# STARSHIP PROMPT
# NOTE: this must be at the end of the file
eval "$(starship init zsh)"
