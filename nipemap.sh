#!/bin/bash

#########################################################
# Nipemap - An Anonymous Remote Port Scanning Tool      #
#########################################################

# Description:
# Nipemap is an interactive script that allows you to perform anonymous port scanning
# on a target using Nipe (a TOR network gateway) and NMAP. The script connects to
# a remote host via SSH, installs the necessary dependencies, initiates the TOR
# gateway with Nipe, and then runs an NMAP scan on the target. The scan results
# are then copied back to the local host, and the script is deleted from the remote host.

# Prerequisites:
# - A connection to remote linux host (Debian based) with sudo privileges.

# Usage:
# Run the following command form Nipemap directory: sudo bash ./nipemap

# Note:
# - Use this tool responsibly and in accordance with applicable laws and regulations.

# Author: Cyb3rb4ric
# Email: magencyber@proton.me
# Network Research school project

#######################################################################


# Exit if script is execute without sudo.
function CHECK_SUDO(){
    if [ "$EUID" -ne 0 ]
        then echo "Please run with sudo."
        exit 1
    fi
}

# Execute local dependencies script.
function lOCAL_DEPENDENCIES_SCRIPT(){
    if ! source ./src/install.sh; then
        exit 1
    fi
}

# Execute main script.
function CALL_MAIN_SCRIPT(){
    if ! source ./src/main.sh; then 
        exit 1
    fi
}


CHECK_SUDO
lOCAL_DEPENDENCIES_SCRIPT
CALL_MAIN_SCRIPT
exit 0