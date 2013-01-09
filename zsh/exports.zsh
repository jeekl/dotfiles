if check_com -c vim ; then
    export EDITOR=${EDITOR:-vim}
else
    export EDITOR=${EDITOR:-vi}
fi
export PAGER=${PAGER:-less}
export MAIL=${MAIL:-/var/mail/$USER}
export SHELL='/bin/zsh'

# set PDF reader
export PDFREADER="epdfview"
export PDFVIEWER="epdfview"

# Set the default image viewer.
export IMAGEVIEWER="feh"

# Set the default web browser.
if [ -z "$DISPLAY" ]
then
    export BROWSER="elinks"
else
    # export BROWSER="conkeror"
    export BROWSER="firefox"
fi

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# set terminal property (used e.g. by msgid-chooser)
export COLORTERM="yes"
