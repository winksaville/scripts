# Scripts

These are scripts and configuration files I've
created over time and when initializing a Linux
system I clone this from github and execute
`initialize.sh` ASAP.

```
wink@3900x 22-11-04T21:03:23.570Z:~/scripts (master)
$ cat initialize.sh 
#!/usr/bin/env bash

# Enable error options
set -Eeuo pipefail

# Enable debug
#set -x

mkdir -p ~/.config
mkdir -p ~/.ssh
cp ~/scripts/bashrc ~/.bashrc
cp ~/scripts/bash_profile ~/.bash_profile
cp ~/scripts/gitconfig ~/.gitconfig
cp ~/scripts/vimrc ~/.vimrc
cp -r ~/scripts/vim ~/.vim/
cp -r ~/scripts/nvim ~/.config/

mkdir -p ~/.config/terminator
cp config-terminator-config ~/.config/terminator/config

cp ~/scripts/ssh/config ~/.ssh/
chmod 600 ~/.ssh/config

mkdir -p ~/bin
cp ~/scripts/update-lighthouse.sh ~/bin/
cp ~/scripts/remove-all-from-docker.sh ~/bin/
cp ~/scripts/screensaver-lock-display-off ~/bin/
```

