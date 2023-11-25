#!/bin/bash

# Imports functions from utilities file.
IMPORT_UTILITIES(){
    source ./src/utilities.sh
}

# Clear the screen and prints ascii art.
function WELCOME(){
    clear
    cat ./src/ascii_art.txt
}

# Ask user for remote host credentials and target.
function USER_INPUT(){  
    read -rp "[?] Please specify your target (IP address/domain): " target
    read -rp "[?] please provide a remote host IP address: " remote_host
    read -rp "[?] please provide the remote host SSH Username: " username
    read -srp "[?] please provide the remote host SSH Password: " password
    BLANK_LINE
}

# creates main script variables.
MAIN_VARS(){
    credentials=("$remote_host" "$username" "$password")
    target_folder="$(pwd)/Targets/$target ($(date +"%FT%T"))"
}

# Remote host credentials check.
function REMOTE_HOST_CONNECTION_CHECK(){
    echo "[*] Connecting to remote host:"
    SSH_COMMAND "${credentials[@]}" " " 2> /dev/null; # to skip warning at first time connection.
    if ! SSH_COMMAND "${credentials[@]}" " " 2> /dev/null; then
        LOG "Failed connecting to remote host at $remote_host";
        echo "[-] Failed connecting to remote host at $remote_host"
        exit 1
    else
        LOG "Successful connection to remote host at $remote_host"
    fi
}

# Copy 'rhost' folder from src and execute remote installation script.
function REMOTE_HOST_INSTALL_SCRIPT(){
    SCP_TO_REMOTE_HOST "${credentials[@]}" ./src/rhost ./.rhost
    if SSH_COMMAND "${credentials[@]}" "echo $password | sudo -S bash ./.rhost/install.sh 2> /dev/null"
    then
        LOG "Nipemap dependencies are installed on remote host at $remote_host"
    else
        LOG "Nipemap dependencies script failed on remote host at $remote_host"
        echo "[-] Nipemap dependencies script failed on remote"
        REMOVE_EVIDENCE
        exit 1
    fi
}

# Run remote script.
function REMOTE_SCRIPT_EXECUTION(){
    if SSH_COMMAND "${credentials[@]}" "echo $password | sudo -S bash ./.rhost/main.sh $target 2> /dev/null";
    then
        LOG "Remote script was executed successfully on $remote_host for target $target"
    else
        LOG "Remote script execution failed at $remote_host for target $target"
        echo "[-] Remote script execution failed!"
        REMOVE_EVIDENCE
        exit 1
    fi
}

# Copy Nmap data to local host.
function COPY_NMAP_SCAN(){
    mkdir -p "$target_folder"
    if SCP_FROM_REMOTE_HOST "${credentials[@]}" "./.rhost/nmap.xml" "$target_folder/nmap.xml" 2> /dev/null;
    then
        LOG "Nmap data collected for: $target"
        echo "[@] Nmap data was saved into $target_folder/nmap.xml"
    else
        LOG "Failed collecting Nmap data for: $target"
        echo "[-] Failed collecting Nmap data"
    fi
}

# Copy Whois data to local host.
function COPY_WHOIS_LOOKUP(){
    mkdir -p "$target_folder"
    if SCP_FROM_REMOTE_HOST "${credentials[@]}" "./.rhost/whois.txt" "$target_folder/whois.txt" 2> /dev/null;
    then
        LOG "Whois data collected for: $target"
        echo "[@] whois data was saved into $target_folder/whois.txt"
    else
        LOG "Failed collecting Whois data for: $target"
        echo "[-] Failed collecting Whois data"
    fi
}

# Creates HTML file from NMAP result.
function BEAUTIFY_NMAP(){
    if XSLTPROC "$target_folder/nmap.xml" "$target_folder/nmap.html" 2> /dev/null;
    then
        LOG "Nmap beatify file created for: $target"
        echo "[@] Nmap data was Beatify and saved into $target_folder/nmap.html"
    else
        LOG "Failed creating Nmap beatify file for: $target"
        echo "[-] Failed creating Nmap beatify file"
    fi
}

# Remove Nipemap code from remote host.
function REMOVE_EVIDENCE(){
    echo ""
    if SSH_COMMAND "${credentials[@]}" "echo $password | sudo -S rm -r .rhost 2> /dev/null" ;
    then
        LOG "Nipemap code was removed from remote host at $remote_host"
        echo "[*] Nipemap code was removed from remote host"
    else
        LOG "Nipemap code was not removed from remote host at $remote_host"
        echo "[-] Nipemap code was not removed from remote host"
    fi
}

IMPORT_UTILITIES
WELCOME
USER_INPUT
MAIN_VARS
REMOTE_HOST_CONNECTION_CHECK
REMOTE_HOST_INSTALL_SCRIPT
REMOTE_SCRIPT_EXECUTION
COPY_NMAP_SCAN
COPY_WHOIS_LOOKUP
BEAUTIFY_NMAP
REMOVE_EVIDENCE
exit 0
