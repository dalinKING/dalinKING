# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
export EDITOR=hx
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
__custom_starship_prompt() {
    local RET=$? 
    local RESET="\[\e[0m\]"
    local BOLD_RED="\[\e[1;31m\]"
    local BOLD_GREEN="\[\e[1;32m\]"
    local BOLD_YELLOW="\[\e[1;33m\]"
    local BOLD_BLUE="\[\e[1;34m\]"
    local BOLD_MAGENTA="\[\e[1;35m\]"
    local CYAN="\[\e[36m\]"
    local DIM_WHITE="\[\e[2;37m\]"

    # --- 退出状态符 ---
    local prompt_char="❯"
    local status_color=$BOLD_GREEN
    if [ $RET -ne 0 ]; then
        status_color=$BOLD_RED
        prompt_char="[${RET}] ❯"
    fi

    # --- 头部标示与目录 ---
    local user_color=$CYAN
    if [ "$EUID" -eq 0 ]; then
        user_color=$BOLD_RED
    fi
    local header="${user_color} 󰌪 󱗘"
    local dir="${BOLD_BLUE}>.< \w${RESET}"

    # --- Git 状态 ---
    local git_segment=""
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        local git_status=""
        if [[ -n "$(git status --porcelain -unormal 2>/dev/null | head -n1)" ]]; then
            git_status="${BOLD_YELLOW}*${RESET}"
        fi
        git_segment=" ${DIM_WHITE}on ${BOLD_MAGENTA} ${branch}${git_status}${RESET}"
    fi

    # --- 最终拼接 ---
    PS1="\n${header} ${dir}${git_segment}\n${status_color}${prompt_char}${RESET} "
}
PROMPT_COMMAND=__custom_starship_prompt
# set variable identifying the chroot you work in (used in the prompt below)
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
# If this is an xterm set the title to user@host:dir
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
# alias ll='ls -lf'
# alias la='ls -A'
# alias l='ls -CF'

alias ll='ls -lah --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
alias apt='nala'
alias aptl='apt-get'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias ping='ping -c 5'

# Alias definitions.
# You may want to put all your additions into a separate file like
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


. "$HOME/.cargo/env"

# >>> Claude Code Haha PATH >>>
export PATH="$HOME/.local/bin:$PATH"
# <<< Claude Code Haha PATH <<<

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
