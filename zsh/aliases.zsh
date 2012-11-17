# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

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
# all clients with a smaller terminal resolution from the local session. If several clients have the same resolution, the youngest clients will be detached.
alias tmux-p0wn='tmux list-clients | sed "s|^\(/dev/ttys[0-9]\+\).*\[\([0-9]\+x[0-9]\+\).*$|\2 \1|" | sort -r -n | tail -n +2 | cut -d " " -f 2 | xargs -n 1 tmux detach-client -t' 
alias randcow='cowsay -f $(basename $(echo /usr/share/cows/* | tr -s " " "\n" | shuf | head -1) .cow)'
alias cp='nocorrect cp'         # no spelling correction on cp
alias mkdir='nocorrect mkdir'   # no spelling correction on mkdir
alias mv='nocorrect mv'         # no spelling correction on mv
alias rm='nocorrect rm'         # no spelling correction on rm
alias slideshow="feh -zsZFD 5 $1"

alias packer='packer-color'

# TODO should make this a function and pass it an argument, if no argument, try all files
alias notes="ack 'TODO|FIXME|XXX|HACK' --ignore-dir=tmp --ignore-dir=log *"

alias f='find $1 -iname '

# Color manpages with terminfo file
alias man='TERMINFO=~/.config/dotfiles/terminfo/ LESS=C TERM=mostlike PAGER=less man'

# get top 10 shell commands:
alias historymeme='print -l ? ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
alias nautilus='nautilus --no-desktop'

# Requires python-pygments, cats src highlighted to stdout.
# python2-pygments on Arch, python-pygments on ubuntu.
alias ccat='pygmentize -f terminal -g'

# Pretty print json documents (usefull together with ccat)
alias jsonlint='python -mjson.tool'
