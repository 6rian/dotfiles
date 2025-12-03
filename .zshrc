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
alias gBranch="git branch --all | sed "s/^..//" | fzf"
alias gMergeBranch="git branch --all | sed "s/^..//" | fzf | xargs git merge"
alias gSwitchBranch="git branch --all | sed "s/^..//" | fzf | xargs git switch"

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

# OBSIDIAN
export OBSIDIAN_VAULT='$HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Obsidian\ Vaults/techn0tes/'
# (o)pen (o)bsidian
alias oo="$OBSIDIAN_VAULT && nvim ."
# (o)pen inbox files for (r)
alias or="$OBSIDIAN_VAULT/inbox/*.md"

# AVANTE AI FOR NVIM CONFIG
# export AVANTE_ANTHROPIC_API_KEY=your-anthropic-api-key
export AVANTE_OPENAI_API_KEY=your-openai-api-key
# export AVANTE_AZURE_OPENAI_API_KEY=your-azure-api-key
# export AVANTE_GEMINI_API_KEY=your-gemini-api-key
# export AVANTE_CO_API_KEY=your-cohere-api-key
# export AVANTE_AIHUBMIX_API_KEY=your-aihubmix-api-key

# # OHMYZSH CONFIG
# if [ -d "$HOME/.oh-my-zsh" ]; then
#   # Path to your Oh My Zsh installation.
#   export ZSH="$HOME/.oh-my-zsh"
#
#   # Set name of the theme to load --- if set to "random", it will
#   # load a random theme each time Oh My Zsh is loaded, in which case,
#   # to know which specific one was loaded, run: echo $RANDOM_THEME
#   # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#   ZSH_THEME="re5et"
#   # re5et
#   # lukerandall
#   # nicoulaj
#   # jispwoso
#   # gnzh
#   # jtriley
#   # jonathan
#   # xiong-chiamiov-plus
#
#   # Set list of themes to pick from when loading at random
#   # Setting this variable when ZSH_THEME=random will cause zsh to load
#   # a theme from this variable instead of looking in $ZSH/themes/
#   # If set to an empty array, this variable will have no effect.
#   # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
#
#   # Uncomment the following line to use case-sensitive completion.
#   # CASE_SENSITIVE="true"
#
#   # Uncomment the following line to use hyphen-insensitive completion.
#   # Case-sensitive completion must be off. _ and - will be interchangeable.
#   # HYPHEN_INSENSITIVE="true"
#
#   # Uncomment one of the following lines to change the auto-update behavior
#   # zstyle ':omz:update' mode disabled  # disable automatic updates
#   zstyle ':omz:update' mode auto      # update automatically without asking
#   # zstyle ':omz:update' mode reminder  # just remind me to update when it's time
#
#   # Uncomment the following line to change how often to auto-update (in days).
#   # zstyle ':omz:update' frequency 13
#
#   # Uncomment the following line if pasting URLs and other text is messed up.
#   # DISABLE_MAGIC_FUNCTIONS="true"
#
#   # Uncomment the following line to disable colors in ls.
#   # DISABLE_LS_COLORS="true"
#
#   # Uncomment the following line to disable auto-setting terminal title.
#   # DISABLE_AUTO_TITLE="true"
#
#   # Uncomment the following line to enable command auto-correction.
#   # ENABLE_CORRECTION="true"
#
#   # Uncomment the following line to display red dots whilst waiting for completion.
#   # You can also set it to another string to have that shown instead of the default red dots.
#   # e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
#   # Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
#   # COMPLETION_WAITING_DOTS="true"
#
#   # Uncomment the following line if you want to disable marking untracked files
#   # under VCS as dirty. This makes repository status check for large repositories
#   # much, much faster.
#   # DISABLE_UNTRACKED_FILES_DIRTY="true"
#
#   # Uncomment the following line if you want to change the command execution time
#   # stamp shown in the history command output.
#   # You can set one of the optional three formats:
#   # "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
#   # or set a custom format using the strftime function format specifications,
#   # see 'man strftime' for details.
#   # HIST_STAMPS="mm/dd/yyyy"
#
#   # Would you like to use another custom folder than $ZSH/custom?
#   # ZSH_CUSTOM=/path/to/new-custom-folder
#
#   # Which plugins would you like to load?
#   # Standard plugins can be found in $ZSH/plugins/
#   # Custom plugins may be added to $ZSH_CUSTOM/plugins/
#   # Example format: plugins=(rails git textmate ruby lighthouse)
#   # Add wisely, as too many plugins slow down shell startup.
#   plugins=(git)
#
#   source $ZSH/oh-my-zsh.sh
# fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# LOAD PRIVATE CONFIG
if [ -f "$HOME/.zshrc.private" ]; then
  source "$HOME/.zshrc.private"
fi

# STARSHIP PROMPT
# NOTE: this must be at the end of the file
eval "$(starship init zsh)"
