export PATH=$PATH:~/repos/dotfiles/bin
export PATH="$HOME/.local/bin:$PATH"

export REPOS_DIR="$HOME/repos"
export SSH_KEY="$HOME/.ssh/id_ed25519"

# mise (runtime version manager) — shared, not host-specific, so it lives
# here rather than .zshrc.private
eval "$(~/.local/bin/mise activate zsh)"

# ALIASES
alias ai='llm'
alias cat='bat'
alias ccat='/bin/cat'
alias cl='clear'
alias h='cd $HOME'
alias lg='lazygit'
alias ll='ls -lah'
# alias pn='pnpm'
alias sz="source $HOME/.zshrc"
alias tree="tree -C"
alias v='nvim'

# Claude aliases
# TODO: .claude should be personal, once I get work moved to my devbox
alias claude-personal='CLAUDE_CONFIG_DIR="$HOME/.claude-personal" claude'
alias claude-work='CLAUDE_CONFIG_DIR="$HOME/.claude" claude'

# Filesystem shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
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

# select a repo from the list of your GitHub repos and print the name with owner, e.g. "username/repo-name"
selectRepo() {
  gh repo list --limit 200 --json nameWithOwner,description \
    --jq '.[] | "\(.nameWithOwner)\t\(.description // "")"' |
  fzf --delimiter=$'\t' --with-nth=1,2 --prompt='Repo> ' |
  cut -f1
}

# select a repo from the list of your GitHub repos and clone it
cloneRepo() {
  gh repo list --limit 200 --json nameWithOwner,description \
    --jq '.[] | "\(.nameWithOwner)\t\(.description // "")"' |
  fzf --delimiter=$'\t' --with-nth=1,2 --prompt='Clone repo> ' |
  cut -f1 |
  xargs -r gh repo clone
}

cdRepo() {
  local repo
  repo=$(
    find "$REPOS_DIR" -mindepth 1 -maxdepth 1 -type d |
    xargs -I{} basename {} |
    fzf --prompt='Repo> '
  ) || return

  [ -n "$repo" ] || return
  cd "$REPOS_DIR/$repo" || return
}

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

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# Start ssh-agent if not already running, and add the key if not already
# loaded. Shared across OSes; only the Apple Keychain flag is Mac-specific.
# No-ops cleanly on machines with no local $SSH_KEY (e.g. devbox, which
# relies on agent forwarding instead).
if [ -z "$SSH_AGENT_PID" ] || ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
  eval "$(ssh-agent -s)" > /dev/null
fi

if [ -f "$SSH_KEY" ] && ! ssh-add -l 2>/dev/null | grep -q "$(ssh-keygen -lf "$SSH_KEY" | awk '{print $2}')"; then
  if [[ "$OSTYPE" == darwin* ]]; then
    ssh-add --apple-use-keychain "$SSH_KEY" >/dev/null 2>&1
  else
    ssh-add "$SSH_KEY" >/dev/null 2>&1
  fi
fi

# OS-specific config (see .zshrc.mac / .zshrc.linux)
case "$OSTYPE" in
  darwin*)
    [ -f "$HOME/repos/dotfiles/.zshrc.mac" ] && source "$HOME/repos/dotfiles/.zshrc.mac"
    ;;
  linux*)
    [ -f "$HOME/repos/dotfiles/.zshrc.linux" ] && source "$HOME/repos/dotfiles/.zshrc.linux"
    ;;
esac

# Initialize zoxide.
eval "$(zoxide init zsh --cmd j)"

# LOAD PRIVATE CONFIG
if [ -f "$HOME/.zshrc.private" ]; then
  source "$HOME/.zshrc.private"
fi

# STARSHIP PROMPT
# NOTE: this must be at the end of the file
eval "$(starship init zsh)"
