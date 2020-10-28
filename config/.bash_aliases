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
