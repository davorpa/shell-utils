#!/usr/bin/env bash

# ====================================
#
# This script shows you a rich color table available to use your bash shell,
# for both properties: foreground and background.
#
# @author   davorpatech
# @since    2020-07-28
# @version  2021-09-03
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

set +e

main() {
    warn_colored_terminal
    print_colored_matrix
    print_usage_examples
}

println() {
    printf "\n"
}

warn_colored_terminal() {
    case "$TERM" in
        xterm-color|*-256color)
            # colored support
            ;;
        *)
            # Output to error stream
            printf >&2 "\e[31mWARN:\e[0m A colored terminal support is required but seems: %s\n" "$TERM"
            ;;
    esac
}

print_colored_matrix() {
    for fgbg in 38 48 ; do # Foreground / Background switch
        println
        for color in {0..255} ; do # 256 Colors
            # Display the color
            printf "\e[${fgbg};5;%sm %3s \e[0m" "$color" "$color";
            # Display 12 colors per line
            [ $(((color + 1) % 12)) == 0 ] && println
        done
        println
    done
}

print_usage_examples() {
    println
    printf " -> USAGE FOREGROUND: \e[38;5;42mecho -e \"\e[38;5;202m"
        printf "\\\e[38;5;"; printf "\e[0m\e[38;5;82m82"; printf "\e[0m\e[38;5;202mm"
            printf "\e[38;5;205m"; printf "\e[38;5;202m"
            printf "\e[0m\e[38;5;82m YOUR TEXT COLORED IN 82 \e[0m\e[38;5;202m"
        printf "\\\e[0m"
    printf "\e[38;5;42m\"\e[0m"
    println
    println
    printf " -> USAGE BACKGROUND: \e[38;5;42mecho -e \"\e[38;5;202m"
        printf "\\\e[48;5;"; printf "\e[0m\e[48;5;33m33"; printf "\e[0m\e[38;5;202mm"
            printf "\e[38;5;205m"; printf "\e[38;5;202m"
            printf "\e[0m\e[48;5;33m YOUR TEXT COLORED IN 33 \e[0m\e[38;5;202m"
        printf "\\\e[0m"
    printf "\e[38;5;42m\"\e[0m"
    println
}

# shellcheck disable=SC2068
main $@
