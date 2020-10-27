# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# include .bash_secrets if it exists
if [ -f "$HOME/.bash_secrets" ]; then
    . "$HOME/.bash_secrets"
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes my shared shell-utils if it exists
if [ -d "$HOME/Documents/repo/shell-utils/scripts" ] ; then
    PATH="$PATH:$HOME/Documents/repo/shell-utils/scripts"
fi

## NVM. A Node/NPM Version Manager to decoupled manage multiple active node.js versions
if [ -d "$HOME/.nvm" ] ; then
    export NVM_DIR="$HOME/.nvm"
    if [ -s "$NVM_DIR/nvm.sh" ] ; then
        # This loads nvm
        . "$NVM_DIR/nvm.sh"
    fi
    if [ -s "$NVM_DIR/bash_completion" ] ; then
        # This loads nvm bash_completion
        . "$NVM_DIR/bash_completion"
    fi
fi
