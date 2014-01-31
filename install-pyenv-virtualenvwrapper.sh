#!/bin/bash
set -ue

# Installs virtualenv, virtualenvwrapper, and pyenv
# Take a look at the variables below for options.

# Sets up everything in the current directory. You probably want to run this in ~
installdir=$(pwd)
# Change this if you aren't using bash or want to put it somewhere else
# (like .bashrc on Ubuntu).
shellprofile="${HOME}/.bash_profile"
# Where pyenv lives.
pyenvsubdir=".pyenv"
# Where virtualenvs live.
virtualenvsubdir=".virtualenvs"
# Subdirectory where new projects will be created.
projectsubdir=""
# Disable to initialize virtualenvwrapper when the shell starts. Can be a bit slow,
# but if lazy loading is enabled you won't get tab completion until after your first
# virtualenvwrapper command is executed "e.g. `workon`"
uselazyloading=true
# Set this to true if you are on OS X and using homebrew (you should be)
usehomebrew=false

gitclobber() {
    if [ -z "$1" -o -z "$2" ]; then
        echo "Wrong number of arguments to gitclobber()" &>2
    fi

    rm -rf "${2}/.git"
    git clone --no-checkout "$1" .gitclobber
    mv -f .gitclobber/.git "$2"
    rm -r .gitclobber
    git --git-dir="${2}/.git" --work-tree="$2" reset --hard HEAD
}

if $uselazyloading; then
    wrapperinit="virtualenvwrapper_lazy"
else
    wrapperinit="virtualenvwrapper"
fi

if $usehomebrew; then
    brew install pyenv pyenv-virtualenv
else
    gitclobber git://github.com/yyuu/pyenv.git "$pyenvsubdir/plugins/pyenv"
    gitclobber https://github.com/yyuu/pyenv-virtualenv.git "$pyenvsubdir/plugins/pyenv-virtualenv"
fi
gitclobber https://github.com/yyuu/pyenv-virtualenvwrapper.git "$pyenvsubdir/plugins/pyenv-virtualenvwrapper"

# add to shell profile
echo "# virtualenvwrapper settings" >> "$shellprofile"
echo "export WORKON_HOME=\"${installdir}/${virtualenvsubdir}\" #virtualenvs created here" >> "$shellprofile"
if [ "$projectsubdir" != "" ]; then
    echo "export PROJECT_HOME=\"${installdir}/${projectsubdir}\" #projects created here" >> "$shellprofile"
fi
$usehomebrew || echo "export PATH=\"${installdir}/${pyenvsubdir}/bin:\$PATH\"" >> "$shellprofile"
cat >> "$shellprofile" <<EOF
# initialize pyenv
if which pyenv > /dev/null; then
    eval "\$(pyenv init -)"
    pyenv $wrapperinit
fi
EOF

# restart shell
echo "\`. ${shellprofile}\` or open a new shell session to use pyenv and virtualenvwrapper."
