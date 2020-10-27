#!/bin/bash

# ====================================
#
# This script shows you a rich color table available to use your bash shell,
# for both properties: foreground and background.
#
# @AUTHOR: davorpa
#
# @SOURCE:
#
#   https://davorpa.github.io/shell-utils/scripts/color-table-256.sh
#
# @LICENSE:
#
#   This program is free software. It comes without any warranty, to
#   the extent permitted by applicable law. You can redistribute it
#   and/or modify it under the terms of the Do What The Fuck You Want
#   To Public License, Version 2, as published by Davorpa TECH. See
#   https://davorpa.github.io/shell-utils/scripts/COPYING
#   for more details.
#

for fgbg in 38 48 ; do # Foreground / Background switch
    for color in {0..255} ; do # 256 Colors
        # Display the color
        printf "\e[${fgbg};5;%sm %3s \e[0m" "$color" "$color";
        # Display 12 colors per line
        if [ $((($color + 1) % 12)) == 4 ] ; then
            echo "";      # New line
        fi
    done
    echo "";              # New line
done

# SIGNAL SUCCESS :)
exit 0;
