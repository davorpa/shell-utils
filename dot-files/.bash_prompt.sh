# bash/zsh git prompt support

##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
__bash_prompt_path() {
    local exit=$?;      # preserve last exit status. must be first
    # How many characters of the $PWD should be kept
    local pwdmaxlen=30;
    # Indicate that there has been dir truncation
    local trunc_symbol="...";

    # override with optional fn args
    pwdmaxlen="${1:-$pwdmaxlen}";
    trunc_symbol="${2:-$trunc_symbol}";

    local dir=${PWD##*/};           # Basename of current working directory.
    local dir_len=${#dir};          # It string length.
    # A global variable
    local text=${PWD/#$HOME/\~};    # Reduce HOME PATH matching to their UNIX symbol.
    local len=${#text}; # It string length.
    pwdmaxlen=$(( ( pwdmaxlen < dir_len ) ? dir_len : pwdmaxlen ));local pwdoffset=$(( len - pwdmaxlen ));
    if [ ${pwdoffset} -gt "0" ]
    then
        text=${text:$pwdoffset:$pwdmaxlen}; # Expansion to max from pos
        text=${trunc_symbol}/${text#*/};    # Prepend truncation without duplicates
    fi
    echo "$text";
    return $exit;   # pop initial exit status
}

# shellcheck disable=SC2154
__bash_debian_chroot() {
    printf -- "%s" "${debian_chroot:+($debian_chroot)}";
}

# shellcheck disable=SC2016
__bash_prompt_titlebar() {
    local exit=$?;      # preserve last exit status. must be first
    local text="";
    # If this is an xterm set the title to user@host:dir
    case $TERM in
        xterm*|rxvt*)
            local workdir="";
            workdir='$(__bash_prompt_path 20)';
#            text='\[\e]0;$(__bash_debian_chroot)\u@\h: \w\a\]';
#            text='\[\e]0;\u:${workdir:+($workdir)}\a\]';
            text="\[\e]0;$(__bash_debian_chroot)\u@\h:${workdir:+($workdir)}\a\]";
            ;;
    esac
    echo "$text";
    return $exit;   # pop initial exit status
}

__git_minutes_since_last_commit() {
    local now last colorize EC;
    now=$(date +%s);
    last=$(git log --pretty=format:'%at' -1 2> /dev/null);
    EC=$?;
    [[ $EC -eq 0 ]] && {
        last=$((now-last));
        last=$((last/60));      # to minutes

        #format output
        colorize=${1:-$colorize};
        if [[ $colorize = yes ]]; then
            case $last in
                [0-9]|10)  local COLOR=$GREEN;;         # <= 20min
                1[1-9]|20) local COLOR=$GREEN;;
                [2-4][1-9]|50) local COLOR=$YELLOW;;    # <= 50min
                *) local COLOR=$RED;;                   # > 50min
            esac
            echo "$COLOR$last$NORMAL";
        elif [[ $colorize = no ]]; then
            echo "$last";
        fi
    }
    return $EC;
}

# shellcheck disable=SC2207
__git_branch_status() {
    local exit=$?;      # preserve last exit status. must be first
    # Input Parameters
    local colorui="never";
    # override with optional fn args
    colorui=${1:-$colorui};

    # extract only "branch...remote" part/column
    local g EC;
    g=( $(git -c color.ui="$colorui" status -sb 2> /dev/null) );
    EC=$?;
    [[ $EC -eq 0 ]] && printf -- "%s" "${g[1]}";
    return $exit;   # pop initial exit status
}

__bash_prompt_repo_git() {
    local exit=$?;      # preserve last exit status. must
    # Input Parameters
    local since EC;
    local pre=' ';
    local start=' (';
    local end=')';
    # override with optional fn args
    pre="${1:-$pre}";
    start="${2:-$start}";
    end="${3:-$end}";

    # If git command found (silent detection)
    if command -v git &>/dev/null; then
        local aux="never";
        if [ -n "${GIT_PS1_SHOWCOLORHINTS-}" ]; then
            pre="$pre$BRIGHT_CYAN"
            start="$RESET$start";
            aux="always";
            since=$(__git_minutes_since_last_commit yes);
        else
            since=$(__git_minutes_since_last_commit no);
        fi
        EC=$?;
        [[ $EC -eq 0 ]] && echo -e "${pre}📦${start}$(__git_branch_status "$aux")|${since}|$(__git_ps1 "%s")${end}";
    fi
    return $exit;   # pop initial exit status
}

# shellcheck disable=SC2016,SC2059,SC2155
__bash_build_prompt() {
    local exit=$?;     # preserve last exit status. must be first
    # Input Parameters
    local colorize;
    # override with optional fn args
    colorize=${1:-$colorize};

    local titlebar workdir repostat;
    titlebar=$(__bash_prompt_titlebar);
    workdir='$(__bash_prompt_path 40)';
    repostat='$(__bash_prompt_repo_git "\n ")';

    local exitico='✅';
    if [[ $exit -eq 0 ]]; then
        exitico=$BRIGHT_GREEN✅$RESET;
    else
        exitico=$BRIGHT_RED$exit!❌$RESET;
    fi

    local UC=$BRIGHT_GREEN;                 # user's color
    [ $UID -eq "0" ] && UC=$BRIGHT_RED;     # root's color

    # Init with remote
#    local format='%s%s\\u@\h:\w\$ ';
#    local format='%s%s\\u@\h:\W\$ ';
    local format="%s%s[%s@%s:%s]%s%s%s 👉 ";
    if [[ $colorize = yes ]]; then
#        format='%s%s\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ';
#        format='%s%s\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ ';
        format="%s%s${BRIGHT_YELLOW}[$UC%s$BRIGHT_BLACK@$UC%s$BRIGHT_YELLOW:$BRIGHT_BLUE%s$BRIGHT_YELLOW]$UC%s$RESET ";
        format+='%s';
        format+="\n %s $BRIGHT_YELLOW👉$RESET ";
    fi

    #echo PS string
    printf -- "$format" "$titlebar" "$(__bash_debian_chroot)" '\u' '\h' "$workdir" "\$" "$repostat" "$exitico";

    return $exit;   # pop initial exit status
}
