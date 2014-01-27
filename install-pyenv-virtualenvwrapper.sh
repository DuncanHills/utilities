#!/bin/bash

installdir = $(pwd)
git clone git://github.com/yyuu/pyenv.git .pyenv
cd .pyenv/plugins
git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git

# bootstrap 
export PATH="$installdir/bin:$PATH"
export PYENV_ROOT="$installdir"
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy

# add to profile
echo "export PATH=\"$installdir/bin:$PATH\"" >> ~/.bash_profile
echo <<'EOF' >> ~/.bash_profile
if which pyenv > /dev/null; then
    export PYENV_ROOT="$(pyenv root)/.pyenv"
    eval "$(pyenv init -)"
    pyenv virtualenvwrapper_lazy
fi
EOF
