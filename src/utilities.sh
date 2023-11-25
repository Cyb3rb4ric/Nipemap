#!/bin/bash

# Appends log entry to Nipemap's log file.  
function LOG(){
    echo "$(date) - $1" >> /var/log/nipemap.log
}

# Warper command for 'sshpass'.
function SSH_COMMAND(){
    local credentials command
    credentials=("$@")
    command=$4
    sshpass -p "${credentials[2]}" ssh -o StrictHostKeyChecking=no "${credentials[1]}"@"${credentials[0]}" "$command"
}

# Copy directory with SCP to remote host.
function SCP_TO_REMOTE_HOST(){
    local credentials file_path dst_path
    credentials=("$@")
    file_path=$4
    dst_path=$5
    sshpass -p "${credentials[2]}" scp -o StrictHostKeyChecking=no -r "$file_path" "${credentials[1]}"@"${credentials[0]}":"$dst_path"
}

# Copy directory with SCP from remote host.
function SCP_FROM_REMOTE_HOST(){
    local credentials file_path dst_path
    credentials=("$@")
    file_path=$4
    dst_path=$5
    sshpass -p "${credentials[2]}" scp -o StrictHostKeyChecking=no -r "${credentials[1]}"@"${credentials[0]}":"$file_path" "$dst_path"
}

# xml to html.
function XSLTPROC(){
    local xml html 
    xml=$1
    html=$2
    xsltproc "$xml" -o "$html"
}

# echo blank line.
BLANK_LINE(){
    echo -e "\n"
}