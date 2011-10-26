## Command history configuration
HISTFILE=$HOME/.config/dotfiles/cache/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_dups	# ignore duplication command history list
setopt share_history 	# share command history data

setopt hist_verify	# let the user edit the command line after history expansion (e.g. !ls) instead of immediately running it
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space

setopt SHARE_HISTORY	# Share history for all sessions
setopt APPEND_HISTORY

