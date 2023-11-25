#!/bin/bash

LOCAL_REQUIREMENTS=("sshpass" "xsltproc")

# check/install local host requirements.
function INSTALL_LOCAL_DEPENDENCIES(){
    for package_name in "${LOCAL_REQUIREMENTS[@]}"; do
        dpkg -s "$package_name" >/dev/null 2>&1 || 
        (echo -e "[*] installing $package_name..." &&
        sudo apt-get install "$package_name" -y >/dev/null 2>&1)
    done
}

INSTALL_LOCAL_DEPENDENCIES
