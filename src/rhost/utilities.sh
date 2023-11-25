#!/bin/bash

# Fetch external IP address.
function GET_IP(){
   curl icanhazip.com
}

# Fetch IP address country.
function GET_COUNTRY(){
    local ip
    ip=$1
    geoiplookup "$ip" | awk -F', ' '{print $NF}'
}

# Run a simple Nmap scan and save it to xml file.
function NMAP_SIMPLE_SCAN(){
    local target pwd
    target=$1
    pwd=$2
    nmap "$target" -Pn --disable-arp-ping -n -sV -O -oX "$pwd/.rhost/nmap.xml" >/dev/null;
}

# run whois lookup and save it to txt file.
function WHOIS_LOOKUP(){
    local target pwd
    target=$1
    pwd=$2
    whois "$target" > "$pwd/.rhost/whois.txt" 2>/dev/null
}

# echo blank line.
BLANK_LINE(){
    echo -e "\n"
}