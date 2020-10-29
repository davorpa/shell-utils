# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# include .bash_secrets if it exists
if [ -f "$HOME/.bash_secrets" ] ; then
    . "$HOME/.bash_secrets";
fi

# if running bash
if [ -n "$BASH_VERSION" ] ; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc";
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH";
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH";
fi

# set PATH so it includes my shared shell-utils if it exists
if [ -d "$HOME/Documents/repo/shell-utils/scripts" ] ; then
    PATH="$PATH:$HOME/Documents/repo/shell-utils/scripts";
fi

## NVM. A Node/NPM Version Manager to decoupled manage multiple active node.js versions
if [ -d "$HOME/.nvm" ] ; then
    export NVM_DIR="$HOME/.nvm"
    if [ -s "$NVM_DIR/nvm.sh" ] ; then
        # This loads nvm
        . "$NVM_DIR/nvm.sh";
    fi
    if [ -s "$NVM_DIR/bash_completion" ] ; then
        # This loads nvm bash_completion
        . "$NVM_DIR/bash_completion";
    fi
fi

## RENV. A Ruby On Rails Version Manager to decoupled manage multiple active ruby versions
## https://github.com/rbenv/rbenv
## Install first with:
##  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
##
if [ -d "$HOME/.rbenv" ] ; then
    export RBENV_DIR="$HOME/.rbenv";
    if [ -s "$RBENV_DIR/bin/rbenv" ] ; then
        # renv-install-doctor reports:

        #1. $RBENV_DIR/bin/rbenv must be in PATH
        PATH="$RBENV_DIR/bin:$PATH";

        # 2. run "rbenv init" to complete installation

        # 2.1. $RBENV_DIR/shims must exists.
        mkdir -p "${RBENV_DIR}/"{shims,versions};

        # 2.2 Installs autocompletion. This is entirely optional but pretty useful.
        # Sourcing ~/.rbenv/completions/rbenv.bash will set that up.
        # There is also a ~/.rbenv/completions/rbenv.zsh for Zsh users
        if [ -n "$ZSH_VERSION" ]; then
            #  assume Zsh
            if [ -r "$RBENV_DIR/completions/rbenv.zsh" ] ; then
                source "$RBENV_DIR/completions/rbenv.zsh";
            fi
        elif [ -n "$BASH_VERSION" ]; then
            # assume Bash
            if [ -r "$RBENV_DIR/completions/rbenv.bash" ] ; then
                source "$RBENV_DIR/completions/rbenv.bash";
            fi
        fi

        # Load rbenv automatically by appending the following to ~/.bashrc:
        eval "$(rbenv init -)"
    fi
fi
