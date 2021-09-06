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

set -e

main() {
    usage
    warn_colored_terminal
    [ $# -eq 0 ] && { print_colored_matrix; }
    # shellcheck disable=SC2068
    print_usage_examples $@
}

usage() {
    printf "\nusage: %s [foreground_color] [background_color]\n" "$(basename "$0")";
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
    local __fgcolor=${1:-82}     # default: 82
    local __bgcolor=${2:-33}     # default: 33

    ! warn_color_range "$__fgcolor" "foreground" && __fgcolor=82  # if invalid, recover default
    ! warn_color_range "$__bgcolor" "background" && __bgcolor=33

    println
    printf " -> FOREGROUND SNIPPET: \e[38;5;42mecho -e \"\e[0m";
        __highlighted_template 38 "$__fgcolor"
        printf "\e[38;5;42m\"\e[0m"
    println
    printf "                        \e[38;5;42m printf \"\e[0m"
        __highlighted_template 38 "$__fgcolor"
        printf "\e[38;5;42m\\\n\"\e[0m"
    println
    println
    printf " -> BACKGROUND SNIPPET: \e[38;5;42mecho -e \"\e[0m"
        __highlighted_template 48 "$__bgcolor"
        printf "\e[38;5;42m\"\e[0m"
    println
    printf "                        \e[38;5;42m printf \"\e[0m"
        __highlighted_template 48 "$__bgcolor"
        printf "\e[38;5;42m\\\n\"\e[0m"
    println
}

__highlighted_template() {
    local fgbg=$1
    local color=$2
    printf "\e[38;5;202m\\\e[%s;5;" "$fgbg";
        printf "\e[0m\e[%s;5;%sm%s" "$fgbg" "$color" "$color"
        printf "\e[0m\e[38;5;202mm\e[38;5;105m\e[38;5;202m"
        printf "\e[0m\e[%s;5;%sm YOUR TEXT COLORED IN %s \e[0m\e[38;5;202m" "$fgbg" "$color" "$color"
    printf "\\\e[0m"
}

warn_color_range() {
    local __varcolor=$1
    local __varlabel=$2
    local __varret=0
    if [ -z "${__varcolor##*[!0-9]*}" ]; then
        __varret=1
    elif  [ "$__varcolor" -lt 0 ]; then
        __varret=11
    elif  [ "$__varcolor" -gt 255 ]; then
        __varret=12
    fi
    [ $__varret -ne 0 ] && printf >&2 "\e[31mWARN:\e[0m %s color code is invalid (0..255): %s\n" "$__varlabel" "$__varcolor"
    return $__varret
}

println() {
    printf "\n"
}

# shellcheck disable=SC2068
main $@
