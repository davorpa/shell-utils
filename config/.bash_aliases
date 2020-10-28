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
# ls aliases
#

alias ll='ls -alF';

alias la='ls -A';

alias l='ls -CF';



# ====================================
# System alias
#

# cpuinfo
alias sys-cpuinfo='cat /proc/cpuinfo';

# APT
alias sys-autoremove='sudo apt autoremove';

alias sys-update='sudo apt update';

alias sys-upgrade='sudo apt upgrade';

function __ps_aux_top() {
    local SORTCOL=${1:-};   # $1 Required.
    local LINES=${2:-10};   # $2 Optional. Default 10
    { {                                          # https://unix.stackexchange.com/a/70675
        ps aux --width 180 --sort="$SORTCOL";    # execute "ps" command
        echo $? >&3                              # redirect it EXITCODE to file descriptor 3
      } | head --lines="${LINES}" >&4;           # do top filter and redirect EXITCODE to file descriptor 4
    } 3>&1;                                      # return output of file descriptor 3
    return $?;
}
alias sys-top-ps-rss='__ps_aux_top -rss "$@"';
alias sys-top-ps-mem='__ps_aux_top -pmem "$@"';
alias sys-top-ps-cpu='__ps_aux_top -pcpu "$@"';

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
    source "$HOME/.profile";
}
