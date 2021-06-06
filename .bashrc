export TERM=xterm-256color

alias vimg='ristretto'
alias xcopy='xclip -selection c'
alias xpaste='xclip -selection c -o'

# colorize aliases
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

# git aliases
git config --global alias.co "checkout"
git config --global alias.ss "status -s"
git config --global alias.cb "checkout -b"
git config --global alias.cm "commit -m"
git config --global alias.lol "log --oneline"
