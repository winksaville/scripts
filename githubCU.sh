#!/bin/bash
# clone and or update a github repo.
#
# Required parameter $1: git repo name like "winksaville" or "seL4"
#
# Required parameter $2: which is the directory name and it
# also assumes that name is the name of the git repo.
#
# Optional second parameter $3: is branch, default to "master"


# At least 2 parameters, <upstreamuser> <repo>
if [ $# -lt 2 ]; then
    echo "Usage: [cloneuser=<cloneuser>] githubCU <upstreamuser> <repo> [ <branch> ]"
    echo " Updates the <repo> from <upstreamuser> from the"
    echo " master branchor optional <branch>."
    echo ""
    echo "   Optionaly if .git doesn't exist and cloneuser env var"
    echo "   does exists the repo will be cloned:"
    echo "      git git@github.com:<cloneuser>/<repo>.git"
    echo "   And also adds upstream it doesn't exist:"
    echo "      git remote add upstream git@github.com:<upstreamuser>/<repo>.git"
    exit
fi

# Turn on commands
#set -x


# First parameter is upstream user name
upstreamuser=$1

# Remove trailing slash of a directory 
repo=$(basename $2)

# Optional second parameter is branch or master if empty
if [ -z "$3" ]; then
    branch=master
else
    branch="$2"
fi

# Create directory if it doesn't exist
if [ ! -d $repo ]; then
    mkdir $repo
fi

# Go into the directory
cd $repo

# If there is no .git directory clone the diretory
if [ ! -d .git ]; then
    if [ -z "$cloneuser" ]; then echo "No cloneuser environment variable"; exit; fi
    git clone git@github.com:$cloneuser/$repo.git .
    if [ $? -ne 0 ]; then echo "Could not clone: git@github.com:$cloneuser/$repo.git"; exit; fi
fi

# Add remote if upstream doesn't exist
remoteNames=$(git remote show)
if [[ $remoteNames == *"upstream"* ]]; then
    found="true"
else
    found="false"
fi

# Add upstream remote if it doesn't exist
if [ "$found" = "false" ]; then
    git remote add upstream git@github.com:$upstreamuser/$repo.git
    if [ $? -ne 0 ]; then
	echo "Could not add upstream git@github.com:$upstreamuser/$repo.git"
	exit
    fi
fi

# Fetch upstream
git fetch upstream
if [ $? -ne 0 ]; then echo "Could not: git fetch upstream"; exit; fi
git checkout $branch 
if [ $? -ne 0 ]; then echo "Could not: git checkout $branch"; exit; fi
git merge upstream/$branch
if [ $? -ne 0 ]; then echo "Could not: git merge upstream/$branch"; exit; fi
git push origin $branch
if [ $? -ne 0 ]; then echo "Could not: git push origin $branch"; exit; fi
