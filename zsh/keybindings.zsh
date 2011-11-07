if [[ "$TERM" != emacs ]] ; then
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M emacs "$terminfo[kdch1]" delete-char
    [[ -z "$terminfo[khome]" ]] || bindkey -M emacs "$terminfo[khome]" beginning-of-line
    [[ -z "$terminfo[kend]"  ]] || bindkey -M emacs "$terminfo[kend]"  end-of-line
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
    [[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
    [[ -z "$terminfo[kend]"  ]] || bindkey -M vicmd "$terminfo[kend]"  vi-end-of-line
    [[ -z "$terminfo[cuu1]"  ]] || bindkey -M viins "$terminfo[cuu1]"  vi-up-line-or-history
    [[ -z "$terminfo[cuf1]"  ]] || bindkey -M viins "$terminfo[cuf1]"  vi-forward-char
    [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" vi-up-line-or-history
    [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" vi-down-line-or-history
    [[ -z "$terminfo[kcuf1]" ]] || bindkey -M viins "$terminfo[kcuf1]" vi-forward-char
    [[ -z "$terminfo[kcub1]" ]] || bindkey -M viins "$terminfo[kcub1]" vi-backward-char
    # ncurses stuff:
    [[ "$terminfo[kcuu1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" vi-up-line-or-history
    [[ "$terminfo[kcud1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" vi-down-line-or-history
    [[ "$terminfo[kcuf1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuf1]/O/[}" vi-forward-char
    [[ "$terminfo[kcub1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcub1]/O/[}" vi-backward-char
    [[ "$terminfo[khome]" == $'\eO'* ]] && bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
    [[ "$terminfo[kend]"  == $'\eO'* ]] && bindkey -M viins "${terminfo[kend]/O/[}"  end-of-line
    [[ "$terminfo[khome]" == $'\eO'* ]] && bindkey -M emacs "${terminfo[khome]/O/[}" beginning-of-line
    [[ "$terminfo[kend]"  == $'\eO'* ]] && bindkey -M emacs "${terminfo[kend]/O/[}"  end-of-line
fi

## keybindings (run 'bindkeys' for details, more details via man zshzle)
# use emacs style per default:
bindkey -e
# use vi style:
# bindkey -v

# Disable flow control to be able to use C-s
setopt NO_FLOW_CONTROL

#if [[ "$TERM" == screen ]] ; then
bindkey '\e[1~' beginning-of-line       # home
bindkey '\e[4~' end-of-line             # end
bindkey '\e[A'  up-line-or-search       # cursor up
bindkey '\e[B'  down-line-or-search     # <ESC>-

bindkey '^xp'   history-beginning-search-backward
bindkey '^xP'   history-beginning-search-forward
# bindkey -s '^L' "|less\n"             # ctrl-L pipes to less
# bindkey -s '^B' " &\n"                # ctrl-B runs it in the background
# if terminal type is set to 'rxvt':
bindkey '\e[7~' beginning-of-line       # home
bindkey '\e[8~' end-of-line             # end
#fi

# insert unicode character
# usage example: 'ctrl-x i' 00A7 'ctrl-x i' will give you an §
# See for example http://unicode.org/charts/ for unicode characters code
zrcautoload insert-unicode-char
zle -N insert-unicode-char
bindkey '^Xi' insert-unicode-char


# k Shift-tab Perform backwards menu completion
if [[ -n "$terminfo[kcbt]" ]]; then
    bindkey "$terminfo[kcbt]" reverse-menu-complete
elif [[ -n "$terminfo[cbt]" ]]; then # required for GNU screen
    bindkey "$terminfo[cbt]"  reverse-menu-complete
fi

bindkey '^xA' grml_toggle_abbrev
bindkey "^x^h" commit-to-history

# Kill everything in a word up to its last \kbd{/}
bindkey '\ev' slash-backward-kill-word
bindkey '\e^h' slash-backward-kill-word
bindkey '\e^?' slash-backward-kill-word

# use the new *-pattern-* widgets for incremental history search
if is439 ; then
    bindkey '^r' history-incremental-pattern-search-backward
    bindkey '^s' history-incremental-pattern-search-forward
fi

bindkey ",." globalias

if is4 && zrcautoload insert-files && zle -N insert-files ; then
    #k# Insert files
    bindkey "^Xf" insert-files # C-x-f
fi

bindkey ' '   magic-space    # also do history expansion on space
#k# Trigger menu-complete
bindkey '\ei' menu-complete  # menu completion via esc-i

# press esc-e for editing command line in $EDITOR or $VISUAL
if is4 && zrcautoload edit-command-line && zle -N edit-command-line ; then
    #k# Edit the current line in \kbd{\$EDITOR}
    bindkey '\ee' edit-command-line
fi

if is4 && [[ -n ${(k)modules[zsh/complist]} ]] ; then
    #k# menu selection: pick item but stay in the menu
    bindkey -M menuselect '\e^M' accept-and-menu-complete

    # accept a completion and try to complete again by using menu
    # completion; very useful with completing directories
    # by using 'undo' one's got a simple file browser
    bindkey -M menuselect '^o' accept-and-infer-next-history
fi

bindkey '^Ed' insert-datestamp # yyyy-mm-dd
bindkey '^Eu' insert-unixtime  # unix timestamp
bindkey '\em' insert-last-typed-word
bindkey '^z'  grml-zsh-fg
bindkey '^Os' sudo-command-line
bindkey '^x1' jump_after_first_word
