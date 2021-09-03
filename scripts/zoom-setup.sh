#!/usr/bin/env bash

#---
#
# This shell script written in bash allows you to check for updates of Zoom meetings client
#
# @AUTHOR: davorpa
#
# @SOURCE:
#
#   https://davorpa.github.io/shell-utils/scripts/zoom-setup.sh
#
# @LICENSE:
#
#   This program is free software. It comes without any warranty, to
#   the extent permitted by applicable law. You can redistribute it
#   and/or modify it under the terms of the Do What The Fuck You Want
#   To Public License, Version 2, as published by Davorpa TECH. See
#   https://davorpa.github.io/shell-utils/scripts/COPYING for more details.
#
# @REFERENCES:
# - https://zoom.us/download
# - https://support.zoom.us/hc/es/sections/200704559-Instalacion
# - https://support.zoom.us/hc/es/articles/204206269-Instalacion-o-actualizacion-de-Zoom-en-Linux
# - https://support.zoom.us/hc/en-us/articles/205759689
# - https://support.zoom.us/hc/en-us/articles/201361963
#
#---


# ====================================
# Config vars
#

# TODO: Detect other Unix/Linux distros moreover Debian/Ubuntu
CMD_INSTALL="sudo apt install";
CMD_KEY="sudo apt-key add";

ZOOM_URL="https://zoom.us";
FOLDER="$HOME/Downloads";

# TODO: Detect by OS (Ubuntu|Debian|...) (x64|x32)
VERSION="latest";
ARCH="zoom_amd64.deb";

CERT_URL="$ZOOM_URL/linux/download/pubkey";
DOWNLOAD_URL="$ZOOM_URL/download";
FETCH_URL="$ZOOM_URL/client/$VERSION";
PACKAGE_URL="$FETCH_URL/$ARCH"; # https://zoom.us/client/latest/zoom_amd64.deb


# ====================================
# Error checks
#

# Detect "wget" command

command -v wget >/dev/null 2>&1 || {
    # Output to error stream
    echo >&2 -en "\e[31mFATAL:\e[0m I require \e[34mwget\e[0m to work but seems not installed. Try to set up it first ;)

        \e[38;5;240m$CMD_INSTALL\e[0m \e[34mwget\e[0m

Aborting.
";
    exit 127;    # SIGNAL with error code
};


# ====================================
# Alehop!! DALE AL MAMBO    ;-)
#

# 1. Install/update packages signing key

echo -en "
\e[104m* STEP 1\e[0m: Download and installing package signing keys: \e[96m$CERT_URL\e[0m
";

wget -qO - "$CERT_URL" | $CMD_KEY -;


# 2. Download remote package

echo -en "
\e[104m* STEP 2\e[0m: Downloading package: \e[96m$PACKAGE_URL\e[0m
";

(wget -qcNO "$FOLDER/$ARCH" "$PACKAGE_URL") && EXITCODE=$? || EXITCODE=$?;
[[ $EXITCODE -ne 0 ]] && {
    echo >&2 -en "\e[31m$EXITCODE\e[0m";    # Output to error stream
    exit $EXITCODE;                         # SIGNAL with error code
};


# 3. Install downloaded package

echo -en "
\e[104m* STEP 3\e[0m: Installing downloaded package... \e[96m$FOLDER/$ARCH\e[0m.
";

($CMD_INSTALL "$FOLDER/$ARCH") && EXITCODE=$? || EXITCODE=$?;
[[ $EXITCODE -ne 0 ]] && {
    echo >&2 -en "\e[31m$EXITCODE\e[0m";    # Output to error stream
    exit $EXITCODE;                         # SIGNAL with error code
};


# ====================================
# SIGNAL SUCCESS :)
#
exit 0;
