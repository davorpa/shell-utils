#!/usr/bin/env bash

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


# Warn if know we don't support colors
case "$TERM" in
    xterm-color|*-256color)
        # colored support
        ;;
    *)
        # Output to error stream
        echo >&2 -en "\e[31mWARN:\e[0m A colored terminal support is required but seems: $TERM";
        ;;
esac

#
# Build matrix
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

#
# Show examples with colored sintaxis
#
echo -en "-> USAGE FOREGROUND: \e[38;5;42mecho -e \"\e[38;5;202m";
    echo -n "\e[38;5;"; echo -en "\e[0m\e[38;5;82m82"; echo -en "\e[0m\e[38;5;202mm";
        echo -en "\e[38;5;205m"; echo -en "\e[38;5;202m";
        echo -en "\e[0m\e[38;5;82m YOUR TEXT COLORED IN 82 \e[0m\e[38;5;202m";
    echo -n "\e[0m";
echo -e "\e[38;5;42m\"\e[0m";
echo "";
echo -en "-> USAGE BACKGROUND: \e[38;5;42mecho -e \"\e[38;5;202m";
    echo -n "\e[48;5;"; echo -en "\e[0m\e[48;5;33m33"; echo -en "\e[0m\e[38;5;202mm";
        echo -en "\e[38;5;205m"; echo -en "\e[38;5;202m";
        echo -en "\e[0m\e[48;5;33m YOUR TEXT COLORED IN 33 \e[0m\e[38;5;202m";
    echo -n "\e[0m";
echo -e "\e[38;5;42m\"\e[0m";
echo "";

# SIGNAL SUCCESS :)
exit 0;
