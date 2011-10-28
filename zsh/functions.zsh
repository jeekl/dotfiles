# check for versions (compatibility reasons)
is4() {
    [[ $ZSH_VERSION == <4->* ]] && return 0
    return 1
}

is41() {
    [[ $ZSH_VERSION == 4.<1->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is42() {
    [[ $ZSH_VERSION == 4.<2->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is425() {
    [[ $ZSH_VERSION == 4.2.<5->* || $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is43() {
    [[ $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is433() {
    [[ $ZSH_VERSION == 4.3.<3->* || $ZSH_VERSION == 4.<4->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is439() {
    [[ $ZSH_VERSION == 4.3.<9->* || $ZSH_VERSION == 4.<4->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

isdarwin() {
    [[ $OSTYPE == darwin* ]] && return 0
    return 1
}


# are we running within an utf environment?
isutfenv() {
    case "$LANG $CHARSET $LANGUAGE" in
        *utf*) return 0 ;;
        *UTF*) return 0 ;;
        *)     return 1 ;;
    esac
}

# autoload wrapper - use this one instead of autoload directly
# We need to define this function as early as this, because autoloading
# 'is-at-least()' needs it.
function zrcautoload() {
    emulate -L zsh
    setopt extended_glob
    local fdir ffile
    local -i ffound

    ffile=$1
    (( found = 0 ))
    for fdir in ${fpath} ; do
        [[ -e ${fdir}/${ffile} ]] && (( ffound = 1 ))
    done

    (( ffound == 0 )) && return 1
    if [[ $ZSH_VERSION == 3.1.<6-> || $ZSH_VERSION == <4->* ]] ; then
        autoload -U ${ffile} || return 1
    else
        autoload ${ffile} || return 1
    fi
    return 0
}


# this function checks if a command exists and returns either true
# or false. This avoids using 'which' and 'whence', which will
# avoid problems with aliases for which on certain weird systems. :-)
# Usage: check_com [-c|-g] word
#   -c  only checks for external commands
#   -g  does the usual tests and also checks for global aliases
check_com () {
    emulate -L zsh
    local -i comonly gatoo

    if [[ $1 == '-c' ]] ; then
        (( comonly = 1 ))
        shift
    elif [[ $1 == '-g' ]] ; then
        (( gatoo = 1 ))
    else
        (( comonly = 0 ))
        (( gatoo = 0 ))
    fi

    if (( ${#argv} != 1 )) ; then
        printf 'usage: check_com [-c] <command>\n' >&2
        return 1
    fi

    if (( comonly > 0 )) ; then
        [[ -n ${commands[$1]}  ]] && return 0
        return 1
    fi

    if   [[ -n ${commands[$1]}    ]] \
      || [[ -n ${functions[$1]}   ]] \
      || [[ -n ${aliases[$1]}     ]] \
      || [[ -n ${reswords[(r)$1]} ]] ; then

        return 0
    fi

    if (( gatoo > 0 )) && [[ -n ${galiases[$1]} ]] ; then
        return 0
    fi

    return 1
}

# creates an alias and precedes the command with
# sudo if $EUID is not zero.
salias () {
    emulate -L zsh
    local only=0 ; local multi=0
    while [[ $1 == -* ]] ; do
        case $1 in
            (-o) only=1 ;;
            (-a) multi=1 ;;
            (--) shift ; break ;;
            (-h)
                printf 'usage: salias [-h|-o|-a] <alias-expression>\n'
                printf '  -h      shows this help text.\n'
                printf '  -a      replace '\'' ; '\'' sequences with '\'' ; sudo '\''.\n'
                printf '          be careful using this option.\n'
                printf '  -o      only sets an alias if a preceding sudo would be needed.\n'
                return 0
                ;;
            (*) printf "unkown option: '%s'\n" "$1" ; return 1 ;;
        esac
        shift
    done

    if (( ${#argv} > 1 )) ; then
        printf 'Too many arguments %s\n' "${#argv}"
        return 1
    fi

    key="${1%%\=*}" ;  val="${1#*\=}"
    if (( EUID == 0 )) && (( only == 0 )); then
        alias -- "${key}=${val}"
    elif (( EUID > 0 )) ; then
        (( multi > 0 )) && val="${val// ; / ; sudo }"
        alias -- "${key}=sudo ${val}"
    fi

    return 0
}


# Check if we can read given files and source those we can.
xsource () {
    if (( ${#argv} < 1 )) ; then
        printf 'usage: xsource FILE(s)...\n' >&2
        return 1
    fi

    while (( ${#argv} > 0 )) ; do
        [[ -r "$1" ]] && source "$1"
        shift
    done
    return 0
}

# Check if we can read a given file and 'cat(1)' it.
xcat () {
    emulate -L zsh
    if (( ${#argv} != 1 )) ; then
        printf 'usage: xcat FILE\n' >&2
        return 1
    fi

    [[ -r $1 ]] && cat $1
    return 0
}


# Remove these functions again, they are of use only in these
# setup files. This should be called at the end of .zshrc.
xunfunction() {
    emulate -L zsh
    local -a funcs
    funcs=(salias xcat xsource xunfunction zrcautoload)

    for func in $funcs ; do
        [[ -n ${functions[$func]} ]] \
            && unfunction $func
    done
    return 0
}

grml_toggle_abbrev () {
    if (( ${NOABBREVIATION} > 0 )) ; then
        NOABBREVIATION=0
    else
        NOABBREVIATION=1
    fi
}

zle -N grml_toggle_abbrev

# add a command line to the shells history without executing it
commit-to-history () {
    print -s ${(z)BUFFER}
    zle send-break
}
zle -N commit-to-history

# only slash should be considered as a word separator:
slash-backward-kill-word () {
    local WORDCHARS="${WORDCHARS:s@/@}"
    # zle backward-word
    zle backward-kill-word
}
zle -N slash-backward-kill-word


# accept-line wrapper

# This widget can prevent unwanted autocorrections from command-name
# to _command-name, rehash automatically on enter and call any number
# of builtin and user-defined widgets in different contexts.
#
# For a broader description, see:
# <http://bewatermyfriend.org/posts/2007/12-26.11-50-38-tooltime.html>
#
# The code is imported from the file 'zsh/functions/accept-line' from
# <http://ft.bewatermyfriend.org/comp/zsh/zsh-dotfiles.tar.bz2>, which
# distributed under the same terms as zsh itself.

# A newly added command will may not be found or will cause false
# correction attempts, if you got auto-correction set. By setting the
# following style, we force accept-line() to rehash, if it cannot
# find the first word on the command line in the $command[] hash.
zstyle ':acceptline:*' rehash true

function Accept-Line () {
    emulate -L zsh
    local -a subs
    local -xi aldone
    local sub

    zstyle -a ":acceptline:${alcontext}" actions subs

    (( ${#subs} < 1 )) && return 0

    (( aldone = 0 ))
    for sub in ${subs} ; do
        [[ ${sub} == 'accept-line' ]] && sub='.accept-line'
        zle ${sub}

        (( aldone > 0 )) && break
    done
}

function Accept-Line-getdefault () {
    emulate -L zsh
    local default_action

    zstyle -s ":acceptline:${alcontext}" default_action default_action
    case ${default_action} in
        ((accept-line|))
            printf ".accept-line"
            ;;
        (*)
            printf ${default_action}
            ;;
    esac
}

function accept-line() {
    emulate -L zsh
    local -a cmdline
    local -x alcontext
    local buf com fname format msg default_action

    alcontext='default'
    buf="${BUFFER}"
    cmdline=(${(z)BUFFER})
    com="${cmdline[1]}"
    fname="_${com}"

    zstyle -t ":acceptline:${alcontext}" rehash \
        && [[ -z ${commands[$com]} ]]           \
        && rehash

    if    [[ -n ${reswords[(r)$com]} ]] \
       || [[ -n ${aliases[$com]}     ]] \
       || [[ -n ${functions[$com]}   ]] \
       || [[ -n ${builtins[$com]}    ]] \
       || [[ -n ${commands[$com]}    ]] ; then

        # there is something sensible to execute, just do it.
        alcontext='normal'
        zle Accept-Line

        default_action=$(Accept-Line-getdefault)
        zstyle -T ":acceptline:${alcontext}" call_default \
            && zle ${default_action}
        return
    fi

    if    [[ -o correct              ]] \
       || [[ -o correctall           ]] \
       && [[ -n ${functions[$fname]} ]] ; then

        # nothing there to execute but there is a function called
        # _command_name; a completion widget. Makes no sense to
        # call it on the commandline, but the correct{,all} options
        # will ask for it nevertheless, so warn the user.
        if [[ ${LASTWIDGET} == 'accept-line' ]] ; then
            # Okay, we warned the user before, he called us again,
            # so have it his way.
            alcontext='force'
            zle Accept-Line

            default_action=$(Accept-Line-getdefault)
            zstyle -T ":acceptline:${alcontext}" call_default \
                && zle ${default_action}
            return
        fi

        # prepare warning message for the user, configurable via zstyle.
        zstyle -s ":acceptline:${alcontext}" compwarnfmt msg

        if [[ -z ${msg} ]] ; then
            msg="%c will not execute and completion %f exists."
        fi

        zformat -f msg "${msg}" "c:${com}" "f:${fname}"

        zle -M -- "${msg}"
        return
    elif [[ -n ${buf//[$' \t\n']##/} ]] ; then
        # If we are here, the commandline contains something that is not
        # executable, which is neither subject to _command_name correction
        # and is not empty. might be a variable assignment
        alcontext='misc'
        zle Accept-Line

        default_action=$(Accept-Line-getdefault)
        zstyle -T ":acceptline:${alcontext}" call_default \
            && zle ${default_action}
        return
    fi

    # If we got this far, the commandline only contains whitespace, or is empty.
    alcontext='empty'
    zle Accept-Line

    default_action=$(Accept-Line-getdefault)
    zstyle -T ":acceptline:${alcontext}" call_default \
        && zle ${default_action}
}

zle -N accept-line
zle -N Accept-Line

globalias () {
    emulate -L zsh
    setopt extendedglob
    local MATCH

    if (( NOABBREVIATION > 0 )) ; then
        LBUFFER="${LBUFFER},."
        return 0
    fi

    matched_chars='[.-|_a-zA-Z0-9]#'
    LBUFFER=${LBUFFER%%(#m)[.-|_a-zA-Z0-9]#}
    LBUFFER+=${abk[$MATCH]:-$MATCH}
}
zle -N globalias

insert-datestamp () {LBUFFER+=${(%):-'%D{%Y-%m-%d}'};}
insert-unixtime () {LBUFFER+=${(%):-'%D{%s}'};}
zle -N insert-datestamp
zle -N insert-unixtime

# press esc-m for inserting last typed word again (thanks to caphuso!)
insert-last-typed-word () {zle insert-last-word -- 0 -1};
zle -N insert-last-typed-word;

function grml-zsh-fg () {
  if (( ${#jobstates} )); then
    zle .push-input
    [[ -o hist_ignore_space ]] && BUFFER=' ' || BUFFER=''
    BUFFER="${BUFFER}fg"
    zle .accept-line
  else
    zle -M 'No background jobs. Doing nothing.'
  fi
}
zle -N grml-zsh-fg

# run command line as user root via sudo:
sudo-command-line () {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
}
zle -N sudo-command-line

# jump behind the first word on the cmdline.
# useful to add options.
function jump_after_first_word () {
    local words
    words=(${(z)BUFFER})
    if (( ${#words} <= 1 )) ; then
        CURSOR=${#BUFFER}
    else
        CURSOR=${#${words[1]}}
    fi
}
zle -N jump_after_first_word

chpwd () {
    local -ax my_stack
    my_stack=( ${PWD} ${dirstack} )
    if is42 ; then
        builtin print -l ${(u)my_stack} >! ${DIRSTACKFILE}
    else
        uprint my_stack >! ${DIRSTACKFILE}
    fi
}


# a wrapper for vim, that deals with title setting
#   VIM_OPTIONS
#       set this array to a set of options to vim you always want
#       to have set when calling vim (in .zshrc.local), like:
#           VIM_OPTIONS=( -p )
#       This will cause vim to send every file given on the
#       commandline to be send to it's own tab (needs vim7).
vim () {
    VIM_PLEASE_SET_TITLE='yes' command vim ${VIM_OPTIONS} "$@"
}

# directory based profiles
if is433 ; then
CHPWD_PROFILE='default'
function chpwd_profiles () {
    # Say you want certain settings to be active in certain directories.
    # This is what you want.
    #
    # zstyle ':chpwd:profiles:/usr/src/grml(|/|/*)'   profile grml
    # zstyle ':chpwd:profiles:/usr/src/debian(|/|/*)' profile debian
    #
    # When that's done and you enter a directory that matches the pattern
    # in the third part of the context, a function called chpwd_profile_grml,
    # for example, is called (if it exists).
    #
    # If no pattern matches (read: no profile is detected) the profile is
    # set to 'default', which means chpwd_profile_default is attempted to
    # be called.
    #
    # A word about the context (the ':chpwd:profiles:*' stuff in the zstyle
    # command) which is used: The third part in the context is matched against
    # ${PWD}. That's why using a pattern such as /foo/bar(|/|/*) makes sense.
    # Because that way the profile is detected for all these values of ${PWD}:
    #   /foo/bar
    #   /foo/bar/
    #   /foo/bar/baz
    # So, if you want to make double damn sure a profile works in /foo/bar
    # and everywhere deeper in that tree, just use (|/|/*) and be happy.
    #
    # The name of the detected profile will be available in a variable called
    # 'profile' in your functions. You don't need to do anything, it'll just
    # be there.
    #
    # Then there is the parameter $CHPWD_PROFILE is set to the profile, that
    # was is currently active. That way you can avoid running code for a
    # profile that is already active, by running code such as the following
    # at the start of your function:
    #
    # function chpwd_profile_grml() {
    #     [[ ${profile} == ${CHPWD_PROFILE} ]] && return 1
    #   ...
    # }
    #
    # The initial value for $CHPWD_PROFILE is 'default'.
    #
    # Version requirement:
    #   This feature requires zsh 4.3.3 or newer.
    #   If you use this feature and need to know whether it is active in your
    #   current shell, there are several ways to do that. Here are two simple
    #   ways:
    #
    #   a) If knowing if the profiles feature is active when zsh starts is
    #      good enough for you, you can put the following snippet into your
    #      .zshrc.local:
    #
    #   (( ${+functions[chpwd_profiles]} )) && print "directory profiles active"
    #
    #   b) If that is not good enough, and you would prefer to be notified
    #      whenever a profile changes, you can solve that by making sure you
    #      start *every* profile function you create like this:
    #
    #   function chpwd_profile_myprofilename() {
    #       [[ ${profile} == ${CHPWD_PROFILE} ]] && return 1
    #       print "chpwd(): Switching to profile: $profile"
    #     ...
    #   }
    #
    #      That makes sure you only get notified if a profile is *changed*,
    #      not everytime you change directory, which would probably piss
    #      you off fairly quickly. :-)
    #
    # There you go. Now have fun with that.
    local -x profile

    zstyle -s ":chpwd:profiles:${PWD}" profile profile || profile='default'
    if (( ${+functions[chpwd_profile_$profile]} )) ; then
        chpwd_profile_${profile}
    fi

    CHPWD_PROFILE="${profile}"
    return 0
}
chpwd_functions=( ${chpwd_functions} chpwd_profiles )

fi # is433

battery () {
if [[ $BATTERY -gt 0 ]] ; then
    PERCENT="${${"$(acpi 2>/dev/null)"}/(#b)[[:space:]]#Battery <->: [^0-9]##, (<->)%*/${match[1]}}"
    if [[ -z "$PERCENT" ]] ; then
        PERCENT='acpi not present'
    else
        if [[ "$PERCENT" -lt 20 ]] ; then
            PERCENT="warning: ${PERCENT}%%"
        else
            PERCENT="${PERCENT}%%"
        fi
    fi
fi
}


function command_not_found_handler() {
    emulate -L zsh
    if [[ -x ${GRML_ZSH_CNF_HANDLER} ]] ; then
        ${GRML_ZSH_CNF_HANDLER} $1
    fi
    return 1
}


function ESC_print () {
    info_print $'\ek' $'\e\\' "$@"
}
function set_title () {
    info_print  $'\e]0;' $'\a' "$@"
}

function info_print () {
    local esc_begin esc_end
    esc_begin="$1"
    esc_end="$2"
    shift 2
    printf '%s' ${esc_begin}
    for item in "$@" ; do
        printf '%s ' "$item"
    done
    printf '%s' "${esc_end}"
}



# Indent source code
smart-indent () {
    indent -npro -kr -i8 -ts8 -sob -l80 -ss -ncs "$@"
}

# RFC 2396 URL encoding in Z-Shell
urlencode () {
    emulate -L zsh
    setopt extendedglob
    input=( ${(s::)1} )
    print ${(j::)input/(#b)([^A-Za-z0-9_.!~*\'\(\)-])/%${(l:2::0:)$(([##16]#match))}}
}

# Simple thumbnails generator
genthumbs () {
    rm -rf thumb-* index.html
    echo "
<html>
  <head>
    <title>Images</title>
  </head>
  <body>" > index.html
    for f in *.(gif|jpeg|jpg|png) ; do
        convert -size 100x200 "$f" -resize 100x200 thumb-"$f"
        echo "    <a href=\"$f\"><img src=\"thumb-$f\"></a>" >> index.html
    done
    echo "
  </body>
</html>" >> index.html
}

# Show some status info
status () {
    print
    print "Date..: "$(date "+%Y-%m-%d %H:%M:%S")
    print "Shell.: Zsh $ZSH_VERSION (PID = $$, $SHLVL nests)"
    print "Term..: $TTY ($TERM), ${BAUD:+$BAUD bauds, }$COLUMNS x $LINES chars"
    print "Login.: $LOGNAME (UID = $EUID) on $HOST"
    print "System: $(cat /etc/[A-Za-z]*[_-][rv]e[lr]*)"
    print "Uptime:$(uptime)"
    print
}


# Reload given functions
reloadfunctio () {
    for func in $argv ; do
        unfunction $func
        autoload $func
    done
}

# Find all files in \$PATH with setuid bit set
suidfind () { ls -latg $path | grep '^...s' }

# Display ANSI colors
ansi-colors () {
    typeset esc="\033[" line1 line2
    echo " _ _ _40 _ _ _41_ _ _ _42 _ _ 43_ _ _ 44_ _ _45 _ _ _ 46_ _ _ 47_ _ _ 49_ _"
    for fore in 30 31 32 33 34 35 36 37; do
        line1="$fore "
        line2="   "
        for back in 40 41 42 43 44 45 46 47 49; do
            line1="${line1}${esc}${back};${fore}m Normal ${esc}0m"
            line2="${line2}${esc}${back};${fore};1m Bold   ${esc}0m"
        done
        echo -e "$line1\n$line2"
    done
}


# List an archive's content
show-archive () {
    emulate -L zsh
    if [[ -f $1 ]] ; then
        case $1 in
            *.tar.gz)      gunzip -c $1 | tar -tf - -- ;;
            *.tar)         tar -tf $1 ;;
            *.tgz)         tar -ztf $1 ;;
            *.zip)         unzip -l $1 ;;
            *.bz2)         bzless $1 ;;
            *.deb)         dpkg-deb --fsys-tarfile $1 | tar -tf - -- ;;
            *)             echo "'$1' Error. Please go away" ;;
        esac
    else
        echo "'$1' is not a valid archive"
    fi
}


# Usage: simple-extract <file>
extract () {
    emulate -L zsh
    if [[ -f $1 ]] ; then
        case $1 in
            *.tar.bz2)  bzip2 -v -d $1      ;;
            *.tar.gz)   tar -xvzf $1        ;;
            *.rar)      unrar $1            ;;
            *.deb)      ar -x $1            ;;
            *.bz2)      bzip2 -d $1         ;;
            *.lzh)      lha x $1            ;;
            *.gz)       gunzip -d $1        ;;
            *.tar)      tar -xvf $1         ;;
            *.tgz)      gunzip -d $1        ;;
            *.tbz2)     tar -jxvf $1        ;;
            *.zip)      unzip $1            ;;
            *.Z)        uncompress $1       ;;
            *)          echo "'$1' Error. Please go away" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Use vim to convert plaintext to HTML
2html () {
    emulate -L zsh
    vim -u NONE -n -c ':syntax on' -c ':so $VIMRUNTIME/syntax/2html.vim' -c ':wqa' $1 &>/dev/null
}

#f5# Clean up directory - remove well known tempfiles
purge-temp-files () {
    FILES=(*~(N) .*~(N) \#*\#(N) *.o(N) a.out(N) *.core(N) *.cmo(N) *.cmi(N) .*.swp(N))
    NBFILES=${#FILES}
    if [[ $NBFILES > 0 ]] ; then
        print $FILES
        local ans
        echo -n "Remove these files? [y/n] "
        read -q ans
        if [[ $ans == "y" ]] ; then
            rm ${FILES}
            echo ">> $PWD purged, $NBFILES files removed"
        else
            echo "Ok. .. then not.."
        fi
    fi
}


# Jump between directories
# note: option AUTO_PUSHD has to be set
d () {
    emulate -L zsh
    autoload -U colors
    local color=$fg_bold[blue]
    integer i=0
    dirs -p | while read dir; do
        local num="${$(printf "%-4d " $i)/ /.}"
        printf " %s  $color%s$reset_color\n" $num $dir
        (( i++ ))
    done
    integer dir=-1
    read -r 'dir?Jump to directory: ' || return
    (( dir == -1 )) && return
    if (( dir < 0 || dir >= i )); then
        echo d: no such directory stack entry: $dir
        return 1
    fi
    cd ~$dir
}


# Print a specific line of file(s).
linenr () {
    emulate -L zsh
    if [ $# -lt 2 ] ; then
       print "Usage: linenr <number>[,<number>] <file>" ; return 1
    elif [ $# -eq 2 ] ; then
         local number=$1
         local file=$2
         command ed -s $file <<< "${number}n"
    else
         local number=$1
         shift
         for file in "$@" ; do
             if [ ! -d $file ] ; then
                echo "${file}:"
                command ed -s $file <<< "${number}n" 2> /dev/null
             else
                continue
             fi
         done | less
    fi
}

ssl-cert-info () {
    emulate -L zsh
    if [[ -z $1 ]] ; then
        printf 'usage: ssl-cert-info <file>\n'
        return 1
    fi
    openssl x509 -noout -text -in $1
    ssl-cert-fingerprints $1
}

ssl-cert-fingerprints () {
    emulate -L zsh
    local i
    if [[ -z $1 ]] ; then
        printf 'usage: ssl-cert-fingerprints <file>\n'
        return 1
    fi
    for i in ${ssl_hashes}
        do ssl-cert-$i $1;
    done
}

# print hex value of a number
hex () {
    emulate -L zsh
    [[ -n "$1" ]] && printf "%x\n" $1 || { print 'Usage: hex <number-to-convert>' ; return 1 }
}


# make sure it is not assigned yet
[[ -n ${aliases[utf2iso]} ]] && unalias utf2iso
utf2iso () {
    if isutfenv ; then
        for ENV in $(env | command grep -i '.utf') ; do
            eval export "$(echo $ENV | sed 's/UTF-8/iso885915/ ; s/utf8/iso885915/')"
        done
    fi
}

# make sure it is not assigned yet
[[ -n ${aliases[iso2utf]} ]] && unalias iso2utf
iso2utf () {
    if ! isutfenv ; then
        for ENV in $(env | command grep -i '\.iso') ; do
            eval export "$(echo $ENV | sed 's/iso.*/UTF-8/ ; s/ISO.*/UTF-8/')"
        done
    fi
}

backup () { cp $1 `basename $1`-`date +%Y%m%d%H%M`.backup; }

#replace_spaces_in_filenames () {
#    for a in ./**/*\ *(Dod);
#    do mv $a ${a:h}/${a:t:gs/ /_};
#}

# Simple wiki function. Show furst paragraph of wikipedia results.
wiki() { 
    if [[ -z $1 ]] ; then
        printf 'Simple wikipedia search\nusage: wiki <search term>\n'
        return 1
    fi

    dig +short txt $1.wp.dg.cx; 
}

source-host-config () {
    host=${$(hostname)//.*/}
    if [ -f "$HOME/.zsh/hosts/${host}.zsh" ] ; then
        source "$HOME/.zsh/hosts/${host}.zsh"
    fi
}
