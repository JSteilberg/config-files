# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
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

for i in $HOME/.bash.d/*; do source $i; done
unset i

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u:\[\033[01;34m\]\W\[\033[00m\]\$ '

# some more ls aliases
alias ll='tree -L 3'
alias la='ls -A'
alias l='ls --group-directories-first -halF'
alias lsd='ls --color=auto -ald */'

alias h='history|grep'

alias hr='printf $(printf "\e[$(shuf -i 91-97 -n 1);1m%%%ds\e[0m\n" $(tput cols)) | tr " " ='

alias qqq='exit'
alias qq='exit'

# Python debugging alias
alias pydb='python -m pdb -c continue '

# Git status alias
alias gs="git status"
alias psh="pipenv shell"

export PATH=/usr/local/IDEA/bin:$PATH
export EDITOR='/usr/bin/emacs -nw'

alias python3="/usr/bin/python3.7"
alias edit="/usr/bin/emacs -nw"

# Make emacs non-blocking
macs () {
    fi=${1}
    emacs $fi &
}
alias emacs=macs

# Thanks reddit
alias xclip='xclip -selection clipboard'
alias weather='curl "https://wttr.in/Boston"'
alias shut='sudo shutdown now'
alias diffy="diff --side-by-side --suppress-common-lines"

alias trash="gio trash"

alias killit='kill -9 %%'

alias gitlog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative --branches'

alias ..="cd .." 
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# typos
alias xs=cd
alias exot=exit
alias Grep=grep





function mydf()         # Pretty-print of 'df' output.
{                       # Inspired by 'dfc' utility.
for fs ; do

    if [ ! -d $fs ]
    then
      echo -e $fs" :No such file or directory" ; continue
    fi

    local info=( $(command df -P $fs | awk 'END{ print $2,$3,$5 }') )
    local free=( $(command df -Pkh $fs | awk 'END{ print $4 }') )
    local nbstars=$(( 20 * ${info[1]} / ${info[0]} ))
    local out="["
    for ((j=0;j<20;j++)); do
        if [ ${j} -lt ${nbstars} ]; then
           out=$out"*"
        else
           out=$out"-"
        fi
    done
    out=${info[2]}" "$out"] ("$free" free on "$fs")"
    echo -e $out
done
}

extract() {
if [ -z ${1} ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: extract <archive> [directory]"
    echo "Example: extract presentation.zip."
    echo "Valid archive types are:"
    echo "tar.bz2, tar.gz, tar.xz, tar, bz2, gz, tbz2,"
    echo "tbz, tgz, lzo, rar, zip, 7z, xz, txz, lzma and tlz"
else
    case "$1" in
        *.tar.bz2|*.tbz2|*.tbz)         tar xvjf "$1" ;;
        *.tgz)                          tar zxvf "$1" ;;
        *.tar.gz)                       tar xvzf "$1" ;;
        *.tar.xz)                       tar xvJf "$1" ;;
        *.tar)                          tar xvf "$1" ;;
        *.rar)                          7z x "$1" ;;
        *.zip)                          unzip "$1" ;;
        *.7z)                           7z x "$1" ;;
        *.lzo)                          lzop -d  "$1" ;;
        *.gz)                           gunzip "$1" ;;
        *.bz2)                          bunzip2 "$1" ;;
        *.Z)                            uncompress "$1" ;;
        *.xz|*.txz|*.lzma|*.tlz)        xz -d "$1" ;;
        *) echo "Sorry, '$1' could not be decompressed." ;;
    esac
fi
}
