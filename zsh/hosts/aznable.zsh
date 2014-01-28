export TERM=rxvt-unicode-256color

export ORIG_PATH="${PATH}"

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=/usr/local/share/perl/5.18.1/auto/share/dist/Cope:$PATH

eval "$(rbenv init -)"

BATTERY=1
### Cope on ubuntu
#export PATH="/usr/local/share/perl/5.12.4/auto/share/dist/Cope:${ORIG_PATH}"
#source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root)
#ZSH_HIGHLIGHT_STYLES[root]='bg=red'
#ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
