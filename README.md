    # Nipemap.sh

    Nipemap is an interactive script that facilitates anonymous port scanning and Whois lookup on a target using Nipe (TOR network gateway) and NMAP from a remote host. The script establishes an SSH connection with the remote host, installs necessary dependencies, initiates the TOR gateway with Nipe, and performs an NMAP scan and Whois lookup on the target. The scan results are then securely copied back to the local host, and the script is removed from the remote host to leave no evidence.

    ## Usage

    1. Open a terminal and navigate to the Nipemap directory.
    2. Run the following command to execute the script with sudo privileges:
    ```bash

    sudo bash ./nipemap.sh

    ```

    ## Script Special Features

    - **Hidden Folders**: NIPE installation and scripts on the remote host are stored in hidden folders to avoid drawing attention.
    - **Secure Deletion**: The script and scan results are deleted from the remote host, even in cases where the main script fails during execution on the remote host, leaving no trace behind.
    - **Log File**: Nipemap maintains a log file at `/var/log/nipemap.log`.
    - **Silent Dependency Installation**: Dependencies are installed silently on both the remote host and the localhost without requiring user interaction.
    - **Organized Scan Results**: Scan results are stored in the "Targets" folder (inside the project directory) on the localhost, with each scan result stored in a directory named after the target and timestamp of the scan.
    - **Multiple Formats**: NMAP scans are stored in both XML and HTML formats. The HTML version can be opened in any browser, providing a clean and neat representation of the scan results.

    ## Script Walkthrough

    1. **Localhost**: The script checks if it is running with sudo privileges; otherwise, it exits.
    2. **Localhost**: Dependencies (sshpass, xsltproc) are quietly installed if needed on the localhost.
    3. **Localhost**: User inputs SSH credentials and the target to scan.
    4. **Localhost**: Connection check is performed to verify connectivity with the remote host.
    5. **Localhost**: The remote host scripts are copied using SCP.
    6. **Localhost**: The installation script is executed remotely, installing necessary dependencies (nipe, curl, cpanminus, git, nmap, whois, geoip-bin) on the remote host.
    7. **Localhost**: The main script is executed remotely on the remote host.
    8. **Remote host**: The script ensures that Nipe is stopped, and then checks the external IP, geolocation, and host uptime.
    9. **Remote host**: Nipe is started, and a check is performed to verify the external connection is anonymous and not from the host's real country.
    10. **Remote host**: An NMAP scan is conducted on the target (IP address/domain) to identify open ports and services, saving the results in an XML file.
    11. **Remote host**: A Whois lookup is performed on the target, saving the results in a TXT file.
    12. **Remote host**: Nipe is stopped to terminate the anonymous connection.
    13. **Localhost**: The NMAP scan file and Whois lookup results are copied from the remote host to the local host.
    14. **Localhost**: The NMAP scan results are beautified using the "xsltproc" tool and saved as an HTML file.
    15. **Localhost**: The scan results and script code are remotely deleted from the remote host to ensure no evidence remains.


    Please use this tool responsibly and in accordance with applicable laws and regulations.

    Author: Cyb3rb4ric
    Email: magencyber@proton.me
    

