export TERM=xterm-256color

export ORIG_PATH="${PATH}"
# Make sure to use kernel_poll
export KRED_POLL=true

function r13b04 () {
    export PATH="${HOME}/code/erlang/OTP/install/R13B04/bin:${ORIG_PATH}"
    export DIALYZER_PLT="${HOME}/code/erlang/OTP/install/R13B04/dialyzer.plt"
    echo "Erlang: " `which erl`
}

function r14b03 () {
    export PATH="${HOME}/code/erlang/OTP/install/R14B03/bin:${ORIG_PATH}"
    export DIALYZER_PLT="${HOME}/code/erlang/OTP/install/R13B04/dialyzer.plt"
    echo "Erlang: " `which erl`
}

function stderl () {
    export PATH="${ORIG_PATH}"
    echo "Erlang: " `which erl`
}

# Use Klarna Erlang by default, or face the consequences!
r14b03

### Cope on ubuntu
export PATH="/usr/local/share/perl/5.12.4/auto/share/dist/Cope:${ORIG_PATH}"
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root)
ZSH_HIGHLIGHT_STYLES[root]='bg=red'
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
