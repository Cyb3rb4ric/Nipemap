#!/bin/bash

REMOTE_REQUIREMENTS=( "curl" "cpanminus" "git" "nmap" "whois" "geoip-bin")

# update remote host system.
function UPDATE(){
    echo '[*] System update for remote host...'
    sudo apt-get update >/dev/null 2>&1
}

# check/install requirements.
function INSTALL_DEPENDENCIES(){
    for package_name in "${REMOTE_REQUIREMENTS[@]}"; do
        dpkg -s "$package_name" >/dev/null 2>&1 || 
        (echo -e "[*] installing $package_name..." &&
        sudo apt-get install "$package_name" -y >/dev/null 2>&1)
        echo "[#] $package_name installed on remote host."
    done
}

# check/install NIPE.
function INSTALL_NIPE(){
    if ! [ -d ./.nipe ]; then 
        echo '[*] installing NIPE...'
        git clone https://github.com/htrgouvea/nipe .nipe >/dev/null 2>&1 &&
        cd .nipe >/dev/null 2>&1 &&
        cpanm --installdeps . >/dev/null 2>&1 &&
        sudo perl nipe.pl install >/dev/null 2>&1
    fi
        echo '[#] NIPE installed on remote host.'
}

UPDATE
INSTALL_DEPENDENCIES
INSTALL_NIPE