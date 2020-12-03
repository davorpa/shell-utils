# ~/.bash_aliases: imported by .bashrc to declare alias definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.


#
# Utility required by all below functions.
# https://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-bash-variable#comment21953456_3232433
#
alias trim="sed -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*\$//g'";

# Clear terminal screen (Windows backwards)
alias cls='clear';


# ====================================
# custom aliases
#

# Search folders 'node_modules' in current directory listing and remove them
alias nmrm="find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;"
( command -v npx &>/dev/null; ) && {
    # interactive using node npkill module
    alias nmrm="npx npkill";
    alias nmrm-root="nmrm -f";
}



# ====================================
# ls aliases
#

alias ll='ls -alF';

alias la='ls -A';

alias l='ls -CF';



# ====================================
# SYSTEM alias
#

# cpuinfo
alias sys-cpuinfo='cat /proc/cpuinfo';
# meminfo
alias sys-meminfo='cat /proc/meminfo';
# swaps
alias sys-swaps='cat /proc/swaps';        #'swapon -s';
# fstab
alias sys-fstab='cat /etc/fstab';

# Swap memory size
alias sys-swap-total='grep SwapTotal /proc/meminfo';
alias sys-swap-cached='grep SwapCached /proc/meminfo';
alias sys-swap-free='grep SwapFree /proc/meminfo';

# Physical memory size
alias sys-mem-total='grep MemTotal /proc/meminfo';
alias sys-mem-available='grep MemAvailable /proc/meminfo';
alias sys-mem-free='grep MemFree /proc/meminfo';

# DNS
alias sys-dnsforce-google8='echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null';
alias sys-dnsforce-google4='echo "nameserver 8.8.4.4" | sudo tee /etc/resolv.conf > /dev/null';
alias sys-dnsforce-cloudflare='echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf > /dev/null';
alias sys-dnsforce-cloudflare1='echo "nameserver 1.0.0.1" | sudo tee /etc/resolv.conf > /dev/null';

# APT
alias sys-autoremove='sudo apt autoremove';

alias sys-update='sudo apt update';

alias sys-upgrade='sudo apt upgrade';

function __ps_aux_top() {
    local SORTCOL=${1:-};       # $1 Required.
    local LINES=${2:-10};       # $2 Optional. Default 10
    local COLS=${COLUMNS:-180}; # Terminal computed columns or 180
    ( ( ( ( (                                         # https://unix.stackexchange.com/a/70675
            exec 3>&- 4>&-;                           # close used file descriptors
            ps aux --width "$COLS" --sort="$SORTCOL"; # execute "ps" command
        );
        echo $? >&3                                   # redirect it EXITCODE to file descriptor 3
      ) | head --lines="${LINES}" >&4;                # do top filter and redirect to file descriptor 4
    ) 3>&1 ) ) 4>&1;                                  # return output of file descriptor 3
    return $?;
}
alias sys-top-ps-rss='__ps_aux_top -rss';
alias sys-top-ps-mem='__ps_aux_top -pmem';
alias sys-top-ps-cpu='__ps_aux_top -pcpu';

function sys-refresh-scripts() {
    # array of paths
    local FILES=(
        "$HOME/bin/*.sh"
        "$HOME/bin/*.pl"
        "$HOME/Documents/repo/shell-utils/scripts/*.sh"
        "$HOME/Documents/repo/shell-utils/scripts/*.pl"
    );
    # iterate expanding array to string
    for f in "${FILES[@]}" ; do
        # grant execute privileges to script owner
        chmod -v u+x "$f";
    done

    # Refresh sources to catch new scripts/commands
    # shellcheck source=.profile disable=SC1091
    source "$HOME/.profile";
}



# ====================================
# GIT aliases
#
alias git-init='git init --initial-branch=main';

# git status
alias gstat="git status";

# git pretty log
alias gl='git log --oneline --graph --decorate --color';
alias gla='gl --all';
# Adds author and relative commit date
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cblue<%an>%Creset" --abbrev-commit --date=relative';
alias glga='glg --all';

# git branch
alias gbh='git branch';
alias gbha='gbh --all';                 # List all local+remotes
alias gbhd='gbh --delete';              # Delete local

# git checkout
alias gco='git checkout';               # Checkout
alias gcom='gco main || gco master';    #... local main

# git fetch
alias gf='git fetch --prune';           # Sync remotes
alias gfa='gf --all';                   # Sync all remotes

# git push
alias gph='git push';
alias gpo='gph origin';                 # ...over remote: origin
alias gpu='gph upstream';               # ...over remote: upstream
alias gpf='gph --force';                # Force push
alias gpfo='gpf origin';                # ...over remote: origin
alias gpfu='gpf upstream';              # ...over remote: upstream

# git commit
alias gcm='git commit'                  # Commit
alias gcma='gcm --amend';               # Amend

# git rebase
alias grbi='git rebase -i';             # Rebase interactive
# shellcheck disable=SC2142
alias grbi-h='grbi HEAD~"$1"';          # ...by HEAD n-position
alias grb-c='git rebase --continue';    # Continue rebase
alias grb-a='git rebase --abort';       # Abort rebase
alias grb-m='git commit --amend "-S"';  # Rename rebase message
