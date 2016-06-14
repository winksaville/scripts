# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

set -o vi

# Add Command not found hook so pkgfile is used to teill where it is
source /usr/share/doc/pkgfile/command-not-found.bash

# Add git-completion and prompt for bash
source ~/scripts/git-completion.bash
source ~/scripts/git-prompt.sh
#source ~/scripts/git-stree-completion.bash

eval `keychain --nogui --eval id_rsa`

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
    xterm-color) color_prompt=yes;;
esac

# Turn on various GIT_PS1 flags
GIT_PS1_DESCRIBE_STYLE=branch
GIT_PS1_SHOWCOLORHINTS=yes
GIT_PS1_HIDE_IF_PWD_IGNORED=yes

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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
  PS1='${debian_chroot:+($debian_chroot)}\[\e[0;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[0;36m\]$(__git_ps1 " (%s)")\[\e[00m\]\r\n\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1 " (%s)")\r\n\$ '
fi
unset color_prompt force_color_prompt

#PS1='[\u@\h \W$(__git_ps1 " (%s)")]\n\$ '

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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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

multiple-file-vim() {
  vim -p $*
}
alias vi=multiple-file-vim
alias vim=multiple-file-vim

# I'm paranoid don't have a trailing ':' if LD_LIBRARY_PATH is empty
#if [ "$LD_LIBRARY_PATH" = "" ]; then
#    export LD_LIBRARY_PATH="/usr/local/lib"
#else
#    export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
#fi
#export LD_LIBRARY_PATH="/opt/protobuf-master/lib:$LD_LIBRARY_PATH"

#export GOPATH="/home/wink/prgs/go"
#export GOBIN="/home/wink/prgs/go/bin"
#export GOROOT="/home/wink/foss/go"
#export GOROOT_FINAL="/opt/go/bin"

export SYSTEMD_EDITOR="vim"
export VISUAL="vim"

export PATH="$HOME/opt/x-tools/x86_64-unknown-elf/bin:$PATH"
export PATH="$HOME/opt/x-tools/i386-unknown-elf/bin:$PATH"
export PATH="$HOME/opt/x-tools/arm-unknown-eabi/bin:$PATH"
export PATH="$HOME/opt/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/foss/meson:$PATH"
export PATH="$HOME/.gem/ruby/2.3.0/bin:$PATH"
export PATH="$HOME/foss/southwest-checkin/vendor/bundle/ruby/2.3.0/bin:$PATH"
#export PATH="$HOME/Android/android-studio/bin:$PATH"
#export PATH="$HOME/Android/Sdk/platform-tools:$PATH"
