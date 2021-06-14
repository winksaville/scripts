# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi
set -o histexpand

# Determine machine we're running on
# from: https://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux
unameOut="$(uname -s)"
unameVerOut="$(uname -v)"
#echo unameVerOut=${unameVerOut}
case "${unameOut}" in
    Linux*)     [[ ${unameVerOut} =~ .*Microsoft*. ]] && machine=WSL || machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
#echo machine=${machine}

# Default to home directory, needed by Msys sometimes
#cd ~

# Set TERM to fix gradle
case "$machine" in
    Linux)     term=xterm;;
    WSL)       term=xterm;;
    Mac)       term=xterm;;
    Cygwin)    term=cygwin;;
    MinGw)     term=cygwin;;
    *)         term=UNKNOWN;;
esac

[[ "$newTerm" != "" ]] && term=$newTerm

export TERM=$term

# On MingGw export MSYS
[[ "${machine}" == MinGw ]] && export MSYS=winsymlinks:nativestrict

export GPG_TTY=$(tty)

shopt -s expand_aliases

# Add Command not found hook so pkgfile is used to teill where it is
command_not_found_file="/usr/share/doc/pkgfile/command-not-found.bash"
[ -f "$command_not_found_file" ] && source "$command_not_found_file"

# Add flutter-completion
source ~/scripts/flutter-completion.bash

# Add git-completion and prompt for bash
source ~/scripts/git-completion.bash
source ~/scripts/git-prompt.sh
#source ~/scripts/git-stree-completion.bash

# Add ninja completion
source ~/scripts/ninja-bash-completion

command -v keychain > /dev/null 2>&1 && eval `keychain --nogui --eval id_rsa`

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
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
command -v lesspipe > /dev/null 2>&1 && eval "$(SHELL=/bin/sh lesspipe)"

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
#
# Paste the code below to see some color choices:
#     for C in {32..47}; do echo -en "\e[0;${C}m$C "; done

force_color_prompt=yes
if [ -z "$force_color_prompt" ]; then
    command -v tput > /dev/null 2>&1
    if (( $? == 0 )); then
       # We have color support; assume it's compliant with Ecma-48
       # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
       # a case would tend to support setf rather than setaf.)
       [ tput setaf 1 >&/dev/null ] && color_prompt=yes || color_prompt=
    fi
else
    color_prompt=yes
fi

#if [[ "${machine}" == Linux || "${machine}" == WSL ]]; then
  if [[ "$color_prompt" == yes ]]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\e[0;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[0;36m\]$(__git_ps1 " (%s)")\[\e[00m\]\r\n\$ '
  else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1 " (%s)")\r\n\$ '
  fi
#fi
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
command -v dircolors > /dev/null 2>&1
if (( $? == 0 )); then

    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    export LS_COLORS="ow=01;34:di=01;34"
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

alias sudo='sudo '
alias vi='vim -p $*'
alias vim='vim -p $*'

#alias dvpy='conda activate dvpy38'

#export GOPATH="$HOME/prgs/go"
#export GOBIN="$HOME/prgs/go/bin"
#export GOROOT="$HOME/foss/go"
#export GOROOT_FINAL="/opt/go/bin"
export GO111MODULE="on"

export SYSTEMD_EDITOR="vim"
export VISUAL="vim"

# NODE & NPM env variables
export npm_config_prefix="$HOME/.npm-globalX"
NPM_GLOBAL="$npm_config_prefix"
#MANPATH="$NPM_GLOBAL/share/man:$(manpath)"
NODE_PATH="$NPM_GLOBAL/lib/node_modules:$NODE_PATH"

# Android setup ANDROID_SDK_ROOT
for ask in  "/Users/winksaville/Library/Android/sdk" "/Users/wink/Library/Android/sdk" "${HOME}/Android/Sdk";  do
  if [ -d "$ask" ]; then
    export ANDROID_SDK_ROOT=${ask}
    break
  else
    # Give it a name that should never exist
    export ANDROID_SDK_ROOT=_NoSuchDir_
  fi
done
#echo ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT

append_path() {
  [ -z "$2" ] && path=PATH || path=$2
  dlr_path="\$$path"
  #echo pp path=$path
  #echo pp dlr_path=$dlr_path
  eval_dlr_path=$(eval "echo $dlr_path")
  #echo eval_ldr_path=$eval_dlr_path
  [ -z  "$eval_dlr_path" ] && eval "export $path=$1" || eval "export $path=$dlr_path:$1"
}
append_path_if_exists() {
  [ -d "$1" ] && append_path $1 $2
}
prepend_path() {
  [ -z "$2" ] && path=PATH || path=$2
  dlr_path="\$$path"
  #echo pp path=$path
  #echo pp dlr_path=$dlr_path
  eval_dlr_path=$(eval "echo $dlr_path")
  #echo eval_ldr_path=$eval_dlr_path
  [ -z  "$eval_dlr_path" ] && eval "export $path=$1" || eval "export $path=$1:$dlr_path"
}
prepend_path_if_exists() {
  [ -d "$1" ] && prepend_path $1 $2
}

if [[ "${machine}" == WSL ]]; then
	export GIT_BASH_HOME=/mnt/c/Users/wink
else
	# Give it a name that should never exist
	export GIT_BASH_HOME=_NoSuchDir_
fi

if [[ "${machine}" == Mac ]]; then
	export mac_arch=$(arch)
	printf "machine=%s mac_arch=%s\n" $machine $mac_arch
	case "${mac_arch}" in
	    arm64)
		    echo arm64
		    prepend_path "/opt/homebrew/bin:/opt/homebrew/sbin"
		    prepend_path_if_exists "/opt/homebrew/opt/icu4c/bin"
		    prepend_path_if_exists "/opt/homebrew/opt/icu4c/sbin"

  		    if [ -d "/opt/homebrew/opt/icu4c/lib" ]; then
			    echo Adding LDFLAGS for icu4/lib and CPPFLAGS for /icu4c/include
			    echo Should these be specific to build or maybe an alias?
			    export LDFLAGS="-L/opt/homebrew/opt/icu4c/lib"
  		    	    export CPPFLAGS="-I/opt/homebrew/opt/icu4c/include"
		    fi
		    ;;

	    i386)
		    echo i386
		    prepend_path "/usr/local/bin"
		    ;;
	    *)
		    echo other
		    printf "mac_arch=%s is UNKNOWN\n" $mac_arch
		    ;;
	esac
fi

prepend_path_if_exists "$HOME/bin"
prepend_path_if_exists "$GIT_BASH_HOME/bin"
prepend_path_if_exists "$HOME/bin/arduino-1.8.9"
prepend_path_if_exists "$HOME/local/gcc-arm-none-eabi-8-2018-q4-major/bin"
prepend_path_if_exists "$HOME/opt/x-tools/i386-unknown-elf/bin"
prepend_path_if_exists "$HOME/opt/x-tools/arm-unknown-eabi/bin"
prepend_path_if_exists "$HOME/opt/bin"
prepend_path_if_exists "$HOME/local/bin"
#prepend_path_if_exists "$HOME/llvm-clang/bin"
prepend_path_if_exists "${ANDROID_SDK_ROOT}/bin"
prepend_path_if_exists "${ANDROID_SDK_ROOT}/tools"
prepend_path_if_exists "${ANDROID_SDK_ROOT}/tools/bin"
prepend_path_if_exists "${ANDROID_SDK_ROOT}/platform-tools"
prepend_path_if_exists "${ANDROID_SDK_ROOT}/emulator"
prepend_path_if_exists "$NPM_GLOBAL/bin"

# For home on linux and elsewhere?
prepend_path_if_exists "$HOME/go/bin"
# For "everyone" on mac's
prepend_path_if_exists "/usr/local/go/bin"

prepend_path_if_exists "$HOME/fuchsia/.jiri_root/bin"
prepend_path_if_exists "$HOME/.cargo/bin"
prepend_path_if_exists "$HOME/prgs/flutter/flutter/bin"
prepend_path_if_exists "$HOME/.pub-cache/bin"
prepend_path_if_exists "$HOME/opt/fah"
prepend_path_if_exists "$HOME/opt/idea-IC/bin"
prepend_path_if_exists "$HOME/fuchsia/.jiri_root/bin"
prepend_path_if_exists "$HOME/.cargo/bin"
#prepend_path_if_exists "/opt/anaconda/bin"
#prepend_path_if_exists "/opt/cuda/bin"
#prepend_path_if_exists "$HOME/prgs/flutter/framework/bin"
#prepend_path_if_exists "$HOME/prgs/flutter/framework/.pub-cache/bin"

# Update PYTHONPATH, this is needed for meson
#prepend_path $HOME/opt/lib/python3.5/site-packages PYTHONPATH

# Update PYTHONPATH, for code-aster
#  NOTE: we may want to use sys.path see:
#   https://stackoverflow.com/questions/34632870/how-to-set-pythonpath-differently-for-version-2-and-3
#   https://docs.python.org/2.7/library/site.html
#prepend_path /lib/python2.7/site-packages PYTHONPATH

# Allow "local" node module to be executed
prepend_path "./node_modules/.bin"

# Emscripten support
prepend_path_if_exists "$HOME/foss/emscripten"

# binaryen
prepend_path_if_exists "$HOME/foss/binaryen/bin"

# pony-0.20 see https://medium.com/@bpdp/latest-pony-in-arch-linux-dea6427bd77f
#prepend_path_if_exists "$HOME/opt/pony-0.20.0/bin"

# For a locally built llvm update LD_LIBRARY_PATH
#prepend_path $HOME/llvm-clang/lib LD_LIBRARY_PATH

# Set up nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
export NVM_SOURCE="/usr/share/nvm"
[ -s "$NVM_SOURCE/nvm.sh" ] && . "$NVM_SOURCE/nvm.sh"

# Add RVM (Ruby Version Manager) to PATH for scripting. Make sure this is the last PATH variable change.
append_path_if_exists PATH="$PATH:$HOME/.rvm/bin"

# Add docker id
export DOCKER_ID_USER="winksaville"

# Depot tools from chromimum for Fuchsia and chromimum
append_path_if_exists $HOME/foss/depot_tools

# Add virtualenvwrapper
#export WORKON_HOME=~/.virtualenvs
#source /usr/bin/virtualenvwrapper_lazy.sh

export CCACHE_DIR=~/.ccache

# Start gpg-agent

if [[ "${machine}" == WSL ]]; then
  # If the terminal that actually rung gpg-agne-relay.sh
  # is killed then things don't work. Better would be if
  # if was run as a system service. Maybe something like:
  # https://superuser.com/a/1514776/362684
  ~/scripts/gpg-agent-relay.sh &
elif [[ "${machine}" == Mac ]]; then
	case "${mac_arch}" in
	    arm64)
		    agent="gpg-agent-mac-arm64-info"
		    ;;

	    i386)
		    agent="gpg-agent-mac-i386-info"
		    ;;
	    *)
		    echo other
		    printf "mac_arch=%s is UNKNOWN\n" $mac_arch
		    ;;
	esac
	agent=gpg-agent.conf
        if [ -f "~/.gnupg/${agent}" ] && [ -n "$(pgrep gpg-agent)" ]; then
                echo "current agent=${agent}"
                source ~.gnupg/${agent}
                #export GPG_AGENT_INFO
        else
                echo new agent="${agent}"
		eval $(gpg-agent --daemon --enable-ssh-support)
        fi
fi

export SSH_AUTH_SOC=`gpgconf --list-dirs agent-ssh-socket`
export GPG_TTY=$(tty)

# Use miniconda3 instead of anaconda and default to conda-forge
# So on Arch Linux install miniconda3 via [aur](https://aur.archlinux.org/packages/miniconda3/)
# This only adds /opt/miniconda3/condabin to PATH and condabin/ ONLY contains `conda`
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

alias deact='conda deactivate'
alias act-base='conda activate base'
alias cq-dev='conda activate cq-dev'
alias cq='conda activate cq'
alias cqgui-master='conda activate cqgui-master'
alias nb-dev='conda activate nb-dev'
alias py-38='conda activate py-38'
alias py-helix='conda activate py-helix'
alias py38-helix='conda activate py38-helix'

source "$HOME/.cargo/env"
