#!/bin/bash

target=$1
pwd=$(pwd)

# Imports functions from utilities file.
IMPORT(){
    source ./.rhost/utilities.sh
}

# Check uptime and real external remote host IP address.
function CONNECTION_STATUS(){
    real_ip=$(GET_IP)
    real_ip_country=$(GET_COUNTRY "$real_ip")
    BLANK_LINE
    echo "[*] Remote host connection status:"
    echo "Uptime: $(uptime)"
    echo "IP address: $real_ip ($real_ip_country)"
}

# Preform simple Nmap scan and Whois lookup.
function NMAP_AND_WHOIS_SCAN(){
    echo "[*] Preform Whois lookup and Nmap scan:"
    NMAP_SIMPLE_SCAN "$target" "$pwd"
    WHOIS_LOOKUP "$target" "$pwd"
}

# Preform anonymity check, if fails then exit.
function NIPE_CHECK(){
    BLANK_LINE
    echo "[*] External anonymous connection check:"
    if [ "$real_ip_country" == "$spoof_ip_country" ]; then
        NIPE_STOP
        echo "[-] Anonymity check failed!"
        exit 1
    fi
    echo "Spoofed IP address: $spoof_ip ($spoof_ip_country)" 
    BLANK_LINE
}

# stops nipe connection.
function NIPE_STOP(){
    cd "$pwd/.nipe" && sudo perl nipe.pl stop
}

# Connect with nipe and exit if anonymous check fails.
function NIPE_START(){
    cd "$pwd/.nipe" && sudo perl nipe.pl start
    spoof_ip=$(GET_IP)
    spoof_ip_country=$(GET_COUNTRY "$spoof_ip")  
}

IMPORT
NIPE_STOP
CONNECTION_STATUS
NIPE_START
NIPE_CHECK
NMAP_AND_WHOIS_SCAN
NIPE_STOP
exit 0
