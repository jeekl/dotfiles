# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Ruby stuff
alias ss='thin --stats "/thin/stats" start'
alias sg='ruby script/generate'
alias sd='ruby script/destroy'
alias sp='ruby script/plugin'
alias ssp='ruby script/spec'
alias rdbm='rake db:migrate'
alias sc='ruby script/console'
alias sd='ruby script/server --debugger'
alias devlog='tail -f log/development.log'

# Find ruby file
alias rfind='find . -name *.rb | xargs grep -n'
alias afind='ack-grep -il'

alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias history='fc -l 1'
alias ls='ls -hF --color=always'
alias l='ls -laFh'
alias sl=ls
alias da='date "+%A, %B %d, %Y [%T]"'
alias hist='history | grep $1'      # requires an argument
alias openports='netstat --all --numeric --programs --inet'
alias pg='ps -Af | grep $1'         # requires an argument
alias diff='colordiff'              # requires colordiff package
alias grep='grep --color=auto -n'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias recentfiles='ls -al --time-style=+%D | grep `date +%D`'
alias svnday='svn log --revision {`date +%Y-%m-%d`}:HEAD'
alias termsize='echo $COLUMNS x $LINES'
alias path='echo -e "${PATH//:/\n}"'
alias tmux='TERM=xterm-256color tmux-attach'
alias tmux-attach='tmux attach || tmux new'
alias randcow='cowsay -f $(basename $(echo /usr/share/cows/* | tr -s " " "\n" | shuf | head -1) .cow)'
alias cp='nocorrect cp'         # no spelling correction on cp
alias mkdir='nocorrect mkdir'   # no spelling correction on mkdir
alias mv='nocorrect mv'         # no spelling correction on mv
alias rm='nocorrect rm'         # no spelling correction on rm

# TODO should make this a function and pass it an argument, if no argument, try all files
alias notes="ack 'TODO|FIXME|XXX|HACK' --ignore-dir=tmp --ignore-dir=log *"

alias f='find $1 -iname '

# Color manpages with terminfo file
alias man='TERMINFO=~/.config/dotfiles/terminfo/ LESS=C TERM=mostlike PAGER=less man'

# get top 10 shell commands:
alias historymeme='print -l ? ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
alias nautilus='nautilus --no-desktop'
