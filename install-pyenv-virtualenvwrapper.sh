#!/bin/bash
set -ue

shellprofile="~/.bash_profile"
installdir=$(pwd)
pyenvsubdir=".pyenv"
virtualenvsubdir=".virtualenvs"
projectsubdir=""
uselazyloading=true
usehomebrew=false

if $uselazyloading; then
    wrapperinit="virtualenvwrapper_lazy"
else
    wrapperinit="virtualenvwrapper"
fi

if $usehomebrew; then
    brew install pyenv pyenv-virtualenv
else
    git clone git://github.com/yyuu/pyenv.git "$pyenvsubdir"
    git clone https://github.com/yyuu/pyenv-virtualenv.git "$pyenvsubdir/plugins/pyenv-virtualenv"
fi
git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git "$pyenvsubdir/plugins/pyenv-virtualenvwrapper"

# bootstrap 
$usehomebrew || export PATH="$installdir/$pyenvsubdir/bin:$PATH"
export PYENV_ROOT="$installdir"
eval "$(pyenv init -)"
pyenv $wrapperinit

# add to shell profile
echo "export WORKON_HOME=\"${installdir}/${virtualenvsubdir}\" #virtualenvs created here" >> "$shellprofile"
if [ "$projectsubdir" -ne "" ]; then
    echo "export PROJECT_HOME=\"${installdir}/${projectsubdir}\" #projects created here" >> "$shellprofile"
fi
$usehomebrew || echo "export PATH=\"${installdir}/${pyenvsubdir}/bin:\$PATH\"" >> "$shellprofile"
echo <<EOF >> ~/.bash_profile
# initialize pyenv
if which pyenv > /dev/null; then
    eval "\$(pyenv init -)"
    pyenv $wrapperinit
fi
EOF
