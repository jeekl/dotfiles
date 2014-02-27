### Prompt setup, based on GRMLs prompt system

EXITCODE="%(?..%?%1v )"
PS2='\`%_> '      # secondary prompt, printed when the shell needs more
                  # information to complete a command.
PS3='?# '         # selection prompt used within a select loop.
PS4='+%N:%i:%_> ' # the execution trace prompt (setopt xtrace).
                  # default: '+%N:%i>'

# display battery status on right side of prompt via running 'BATTERY=1 zsh'
if [[ $BATTERY -gt 0 ]] ; then
    if ! check_com -c acpi ; then
        BATTERY=0
    fi
fi

# set variable debian_chroot if running in a chroot with /etc/debian_chroot
if [[ -z "$debian_chroot" ]] && [[ -r /etc/debian_chroot ]] ; then
    debian_chroot=$(</etc/debian_chroot)
fi

if zrcautoload vcs_info; then
    # `vcs_info' in zsh versions 4.3.10 and below have a broken `_realpath'
    # function, which can cause a lot of trouble with our directory-based
    # profiles. So:
    if [[ ${ZSH_VERSION} == 4.3.<-10> ]] ; then
        function VCS_INFO_realpath () {
            setopt localoptions NO_shwordsplit chaselinks
            ( builtin cd -q $1 2> /dev/null && pwd; )
        }
    fi

    zstyle ':vcs_info:*' max-exports 2

    if [[ -o restricted ]]; then
        zstyle ':vcs_info:*' enable NONE
    fi
fi


# Change vcs_info formats for the grml prompt. The 2nd format sets up
# $vcs_info_msg_1_ to contain "zsh: repo-name" used to set our screen title.
# TODO: The included vcs_info() version still uses $VCS_INFO_message_N_.
#       That needs to be the use of $VCS_INFO_message_N_ needs to be changed
#       to $vcs_info_msg_N_ as soon as we use the included version.
if [[ "$TERM" == dumb ]] ; then
    zstyle ':vcs_info:*' actionformats "(%s%)-[%b|%a] " "zsh: %r"
    zstyle ':vcs_info:*' formats       "(%s%)-[%b] "    "zsh: %r"
else
    # these are the same, just with a lot of colors:
    zstyle ':vcs_info:*' actionformats "${MAGENTA}(${NO_COLOR}%s${MAGENTA})${YELLOW}-${MAGENTA}[${GREEN}%b${YELLOW}|${RED}%a${MAGENTA}]${NO_COLOR} " \
        "zsh: %r"
    zstyle ':vcs_info:*' formats       "${MAGENTA}(${NO_COLOR}%s${MAGENTA})${YELLOW}-${MAGENTA}[${GREEN}%b${MAGENTA}]${NO_COLOR}%} " \
        "zsh: %r"
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat "%b${RED}:${YELLOW}%r"
fi



# Now for the fun part: The grml prompt themes in `promptsys' mode of operation

# This actually defines three prompts:
#
#    - grml
#    - grml-large
#    - grml-chroot
#
# They all share the same code and only differ with respect to which items they
# contain. The main source of documentation is the `prompt_grml_help' function
# below, which gets called when the user does this: prompt -h grml

function prompt_grml_help () {
        cat <<__EOF0__
  prompt grml

    This is the prompt as used by the grml-live system <http://grml.org>. It is
    a rather simple one-line prompt, that by default looks something like this:

        <user>@<host> <current-working-directory>[ <vcs_info-data>]%

    The prompt itself integrates with zsh's prompt themes system (as you are
    witnessing right now) and is configurable to a certain degree. In
    particular, these aspects are customisable:

        - The items used in the prompt (e.g. you can remove \`user' from
          the list of activated items, which will cause the user name to
          be omitted from the prompt string).

        - The attributes used with the items are customisable via strings
          used before and after the actual item.

    The available items are: at, battery, change-root, date, grml-chroot,
    history, host, jobs, newline, path, percent, rc, rc-always, sad-smiley,
    shell-level, time, user, vcs

    The actual configuration is done via zsh's \`zstyle' mechanism. The
    context, that is used while looking up styles is:

        ':prompt:grml:<left-or-right>:<subcontext>'

    Here <left-or-right> is either \`left' or \`right', signifying whether the
    style should affect the left or the right prompt. <subcontext> is either
    \`setup' or 'items:<item>', where \`<item>' is one of the available items.

    The styles:

        - use-rprompt (boolean): If \`true' (the default), print a sad smiley
          in $RPROMPT if the last command a returned non-successful error code.
          (This in only valid if <left-or-right> is "right"; ignored otherwise)

        - items (list): The list of items used in the prompt. If \`vcs' is
          present in the list, the theme's code invokes \`vcs_info'
          accordingly. Default (left): rc change-root user at host path vcs
          percent; Default (right): sad-smiley

    Available styles in 'items:<item>' are: pre, post. These are strings that
    are inserted before (pre) and after (post) the item in question. Thus, the
    following would cause the user name to be printed in red instead of the
    default blue:

        zstyle ':prompt:grml:*:items:user' pre '%F{red}'

    Note, that the \`post' style may remain at its default value, because its
    default value is '%f', which turns the foreground text attribute off (which
    is exactly, what is still required with the new \`pre' value).
__EOF0__
}

function prompt_grml-chroot_help () {
    cat <<__EOF0__
  prompt grml-chroot

    This is a variation of the grml prompt, see: prompt -h grml

    The main difference is the default value of the \`items' style. The rest
    behaves exactly the same. Here are the defaults for \`grml-chroot':

        - left: grml-chroot user at host path percent
        - right: (empty list)
__EOF0__
}

function prompt_grml-large_help () {
    cat <<__EOF0__
  prompt grml-large

    This is a variation of the grml prompt, see: prompt -h grml

    The main difference is the default value of the \`items' style. In
    particular, this theme uses _two_ lines instead of one with the plain
    \`grml' theme. The rest behaves exactly the same. Here are the defaults
    for \`grml-large':

        - left: rc jobs history shell-level change-root time date newline user
                at host path vcs percent
        - right: sad-smiley
__EOF0__
}

function grml_prompt_setup () {
    emulate -L zsh
    autoload -Uz vcs_info
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd prompt_$1_precmd
}

function prompt_grml_setup () {
    grml_prompt_setup grml
}

function prompt_grml-chroot_setup () {
    grml_prompt_setup grml-chroot
}

function prompt_grml-large_setup () {
    grml_prompt_setup grml-large
}

# These maps define default tokens and pre-/post-decoration for items to be
# used within the themes. All defaults may be customised in a context sensitive
# matter by using zsh's `zstyle' mechanism.
typeset -gA grml_prompt_pre_default \
            grml_prompt_post_default \
            grml_prompt_token_default \
            grml_prompt_token_function

grml_prompt_pre_default=(
    at                ''
    battery           ' '
    change-root       ''
    date              '%F{blue}'
    grml-chroot       '%F{red}'
    history           '%F{green}'
    host              ''
    jobs              '%F{cyan}'
    newline           ''
    path              '%B'
    percent           ''
    rc                '%B%F{red}'
    rc-always         ''
    sad-smiley        ''
    shell-level       '%F{red}'
    time              '%F{blue}'
    user              '%B%F{blue}'
    vcs               ''
)

grml_prompt_post_default=(
    at                ''
    battery           ''
    change-root       ''
    date              '%f'
    grml-chroot       '%f '
    history           '%f'
    host              ''
    jobs              '%f'
    newline           ''
    path              '%b'
    percent           ''
    rc                '%f%b'
    rc-always         ''
    sad-smiley        ''
    shell-level       '%f'
    time              '%f'
    user              '%f%b'
    vcs               ''
)

grml_prompt_token_default=(
    at                '@'
    battery           'PERCENT'
    change-root       'debian_chroot'
    date              '%D{%Y-%m-%d}'
    grml-chroot       'GRML_CHROOT'
    history           '{history#%!} '
    host              '%m '
    jobs              '[%j running job(s)] '
    newline           $'\n'
    path              '%40<..<%~%<< '
    percent           '%# '
    rc                '%(?..%? )'
    rc-always         '%?'
    sad-smiley        '%(?..:-()'
    shell-level       '%(3L.+ .)'
    time              '%D{%H:%M:%S} '
    user              '%n'
    vcs               '0'
)

function grml_theme_has_token () {
    if (( ARGC != 1 )); then
        printf 'usage: grml_theme_has_token <name>\n'
        return 1
    fi
    (( ${+grml_prompt_token_default[$1]} ))
}

function GRML_theme_add_token_usage () {
    cat <<__EOF__
  Usage: grml_theme_add_token <name> [-f|-i] <token/function> [<pre> <post>]

    <name> is the name for the newly added token. If the \`-f' or \`-i' options
    are used, <token/function> is the name of the function (see below for
    details). Otherwise it is the literal token string to be used. <pre> and
    <post> are optional.

  Options:

    -f <function>   Use a function named \`<function>' each time the token
                    is to be expanded.

    -i <function>   Use a function named \`<function>' to initialise the
                    value of the token _once_ at runtime.

    The functions are called with one argument: the token's new name. The
    return value is expected in the \$REPLY parameter. The use of these
    options is mutually exclusive.

    There is a utility function \`grml_theme_has_token', which you can use
    to test if a token exists before trying to add it. This can be a guard
    for situations in which a \`grml_theme_add_token' call may happen more
    than once.

  Example:

    To add a new token \`day' that expands to the current weekday in the
    current locale in green foreground colour, use this:

      grml_theme_add_token day '%D{%A}' '%F{green}' '%f'

    Another example would be support for \$VIRTUAL_ENV:

      function virtual_env_prompt () {
        REPLY=\${VIRTUAL_ENV+\${VIRTUAL_ENV:t} }
      }
      grml_theme_add_token virtual-env -f virtual_env_prompt

    After that, you will be able to use a changed \`items' style to
    assemble your prompt.
__EOF__
}

function grml_theme_add_token () {
    emulate -L zsh
    local name token pre post
    local -i init funcall

    if (( ARGC == 0 )); then
        GRML_theme_add_token_usage
        return 0
    fi

    init=0
    funcall=0
    pre=''
    post=''
    name=$1
    shift
    if [[ $1 == '-f' ]]; then
        funcall=1
        shift
    elif [[ $1 == '-i' ]]; then
        init=1
        shift
    fi

    if (( ARGC == 0 )); then
        printf '
grml_theme_add_token: No token-string/function-name provided!\n\n'
        GRML_theme_add_token_usage
        return 1
    fi
    token=$1
    shift
    if (( ARGC != 0 && ARGC != 2 )); then
        printf '
grml_theme_add_token: <pre> and <post> need to by specified _both_!\n\n'
        GRML_theme_add_token_usage
        return 1
    fi
    if (( ARGC )); then
        pre=$1
        post=$2
        shift 2
    fi

    if grml_theme_has_token $name; then
        printf '
grml_theme_add_token: Token `%s'\'' exists! Giving up!\n\n' $name
        GRML_theme_add_token_usage
        return 2
    fi
    if (( init )); then
        $token $name
        token=$REPLY
    fi
    grml_prompt_pre_default[$name]=$pre
    grml_prompt_post_default[$name]=$post
    if (( funcall )); then
        grml_prompt_token_function[$name]=$token
        grml_prompt_token_default[$name]=23
    else
        grml_prompt_token_default[$name]=$token
    fi
}

function grml_typeset_and_wrap () {
    emulate -L zsh
    local target="$1"
    local new="$2"
    local left="$3"
    local right="$4"

    if (( ${+parameters[$new]} )); then
        typeset -g "${target}=${(P)target}${left}${(P)new}${right}"
    fi
}

function grml_prompt_addto () {
    emulate -L zsh
    local target="$1"
    local lr it apre apost new v
    local -a items
    shift

    [[ $target == PS1 ]] && lr=left || lr=right
    zstyle -a ":prompt:${grmltheme}:${lr}:setup" items items || items=( "$@" )
    typeset -g "${target}="
    for it in "${items[@]}"; do
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" pre apre \
            || apre=${grml_prompt_pre_default[$it]}
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" post apost \
            || apost=${grml_prompt_post_default[$it]}
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" token new \
            || new=${grml_prompt_token_default[$it]}
        typeset -g "${target}=${(P)target}${apre}"
        if (( ${+grml_prompt_token_function[$it]} )); then
            ${grml_prompt_token_function[$it]} $it
            typeset -g "${target}=${(P)target}${REPLY}"
        else
            case $it in
            battery)
                grml_typeset_and_wrap $target $new '' ''
                ;;
            change-root)
                grml_typeset_and_wrap $target $new '(' ')'
                ;;
            grml-chroot)
                if [[ -n ${(P)new} ]]; then
                    typeset -g "${target}=${(P)target}(CHROOT)"
                fi
                ;;
            vcs)
                v="vcs_info_msg_${new}_"
                if (( ! vcscalled )); then
                    vcs_info
                    vcscalled=1
                fi
                if (( ${+parameters[$v]} )) && [[ -n "${(P)v}" ]]; then
                    typeset -g "${target}=${(P)target}${(P)v}"
                fi
                ;;
            *) typeset -g "${target}=${(P)target}${new}" ;;
            esac
        fi
        typeset -g "${target}=${(P)target}${apost}"
    done
}

function prompt_grml_precmd () {
    emulate -L zsh
    local grmltheme=grml
    local -a left_items right_items
    left_items=(rc change-root user at host path vcs percent)
    right_items=(sad-smiley)

    prompt_grml_precmd_worker
}

function prompt_grml-chroot_precmd () {
    emulate -L zsh
    local grmltheme=grml-chroot
    local -a left_items right_items
    left_items=(grml-chroot user at host path percent)
    right_items=()

    prompt_grml_precmd_worker
}

function prompt_grml-large_precmd () {
    emulate -L zsh
    local grmltheme=grml-large
    local -a left_items right_items
    left_items=(rc jobs history shell-level change-root time date newline
                user at host path vcs percent)
    right_items=(sad-smiley)

    prompt_grml_precmd_worker
}

function prompt_grml_precmd_worker () {
    emulate -L zsh
    local -i vcscalled=0

    grml_prompt_addto PS1 "${left_items[@]}"
    if zstyle -T ":prompt:${grmltheme}:right:setup" use-rprompt; then
        grml_prompt_addto RPS1 "${right_items[@]}"
    fi
}

grml_prompt_fallback() {
    setopt prompt_subst
    precmd() {
        (( ${+functions[vcs_info]} )) && vcs_info
    }

    p0="${RED}%(?..%? )${WHITE}${debian_chroot:+($debian_chroot)}"
    p1="${BLUE}%n${NO_COLOR}@%m %40<...<%B%~%b%<< "'${vcs_info_msg_0_}'"%# "
    if (( EUID == 0 )); then
        PROMPT="${BLUE}${p0}${RED}${p1}"
    else
        PROMPT="${RED}${p0}${BLUE}${p1}"
    fi
    unset p0 p1
}

if zrcautoload promptinit && promptinit 2>/dev/null ; then
    # Since we define the required functions in here and not in files in
    # $fpath, we need to stick the theme's name into `$prompt_themes'
    # ourselves, since promptinit does not pick them up otherwise.
    prompt_themes+=( grml grml-chroot grml-large )
    # Also, keep the array sorted...
    prompt_themes=( "${(@on)prompt_themes}" )
else
    print 'Notice: no promptinit available :('
    grml_prompt_fallback
fi

if is437; then
    # The prompt themes use modern features of zsh, that require at least
    # version 4.3.7 of the shell. Use the fallback otherwise.
    if [[ $BATTERY -gt 0 ]]; then
        zstyle ':prompt:grml:right:setup' items sad-smiley battery
        add-zsh-hook precmd battery
    fi
    if [[ "$TERM" == dumb ]] ; then
        zstyle ":prompt:grml(|-large|-chroot):*:items:grml-chroot" pre ''
        zstyle ":prompt:grml(|-large|-chroot):*:items:grml-chroot" post ' '
        for i in rc user path jobs history date time shell-level; do
            zstyle ":prompt:grml(|-large|-chroot):*:items:$i" pre ''
            zstyle ":prompt:grml(|-large|-chroot):*:items:$i" post ''
        done
        unset i
        zstyle ':prompt:grml(|-large|-chroot):right:setup' use-rprompt false
    elif (( EUID == 0 )); then
        zstyle ':prompt:grml(|-large|-chroot):*:items:user' pre '%B%F{red}'
    fi

    # Finally enable one of the prompts.
    if [[ -n $GRML_CHROOT ]]; then
        prompt grml-chroot
    elif [[ $GRMLPROMPT -gt 0 ]]; then
        prompt grml-large
    else
        prompt grml
    fi
else
    grml_prompt_fallback
fi

# Terminal-title wizardry

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
    printf '%s' "$*"
    printf '%s' "${esc_end}"
}

function grml_reset_screen_title () {
    # adjust title of xterm
    # see http://www.faqs.org/docs/Linux-mini/Xterm-Title.html
    [[ ${NOTITLE:-} -gt 0 ]] && return 0
    case $TERM in
        (xterm*|rxvt*)
            set_title ${(%):-"%n@%m: %~"}
            ;;
    esac
}

function grml_vcs_to_screen_title () {
    if [[ $TERM == screen* ]] ; then
        if [[ -n ${vcs_info_msg_1_} ]] ; then
            ESC_print ${vcs_info_msg_1_}
        else
            ESC_print "zsh"
        fi
    fi
}

function grml_maintain_name () {
    # set hostname if not running on host with name 'grml'
    if [[ -n "$HOSTNAME" ]] && [[ "$HOSTNAME" != $(hostname) ]] ; then
       NAME="@$HOSTNAME"
    fi
}

function grml_cmd_to_screen_title () {
    # get the name of the program currently running and hostname of local
    # machine set screen window title if running in a screen
    if [[ "$TERM" == screen* ]] ; then
        local CMD="${1[(wr)^(*=*|sudo|ssh|-*)]}$NAME"
        ESC_print ${CMD}
    fi
}

function grml_control_xterm_title () {
    case $TERM in
        (xterm*|rxvt*)
            set_title "${(%):-"%n@%m:"}" "$1"
            ;;
    esac
}

zrcautoload add-zsh-hook || add-zsh-hook () { :; }
if [[ $NOPRECMD -eq 0 ]]; then
    add-zsh-hook precmd grml_reset_screen_title
    add-zsh-hook precmd grml_vcs_to_screen_title
    add-zsh-hook preexec _check_for_battery
    add-zsh-hook preexec grml_maintain_name
    add-zsh-hook preexec grml_cmd_to_screen_title
    if [[ $NOTITLE -eq 0 ]]; then
        add-zsh-hook preexec grml_control_xterm_title
    fi
fi

setopt promptsubst
for x in user at host path percent; do
  zstyle ":prompt:grml:left:items:$x" post '%f%b'
done

zstyle ':prompt:grml:left:items:user' pre "%B${GREEN}"
zstyle ':prompt:grml:left:items:at' pre "%B${BLUE}"
zstyle ':prompt:grml:left:items:host' pre "%B${WHITE}"
zstyle ':prompt:grml:left:items:path' pre "%B${BOLD_CYAN}"
zstyle ':prompt:grml:left:items:path' token '%40<..<%~%<< '
zstyle ':prompt:grml:left:items:percent' pre "%B${WHITE}"
zstyle ':prompt:grml:left:items:vcs' pre '$VENV_PROMPT'
zstyle ':prompt:grml:right:items:sad-smiley' pre '%B%F{196}'

# The zsh linters will give a random error on this if the ${c part is in the
# zstyle command. No idea why, but wth.
zstyle ':vcs_info:*' unstagedstr "%F{160}" # ${c[16]}
zstyle ':vcs_info:*' stagedstr "%F{202}" # ${c[18]}

# zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true

local gitformat="%B%F{237}(%a%F{083}%u%c%b%m%F{237}) " # 14, 15
zstyle ':vcs_info:git*' formats $gitformat
zstyle ':vcs_info:git*' actionformats $gitformat

zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash git-action

zstyle ':prompt:grml:left:setup' items rc change-root user at host path vcs percent
