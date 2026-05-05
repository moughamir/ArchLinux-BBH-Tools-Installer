#!/bin/bash

# Enable strict error handling
set -e
set -o pipefail

# Setup logging
LOG_FILE="/tmp/bbh-installer-$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE")
exec 2>&1

# Cleanup trap for temporary files
cleanup() {
    if [[ -n "$TMPDIR" && -d "$TMPDIR" ]]; then
        rm -rf "$TMPDIR"
    fi
}
trap cleanup EXIT

# Check if running on Arch Linux
if [[ ! -f /etc/arch-release ]]; then
    echo "ERROR: This script is designed for Arch Linux only."
    exit 1
fi

# Warn about privilege escalation
echo "========================================================"
echo "NOTICE: This script will request sudo privileges to:"
echo "  - Update system packages"
echo "  - Install multiple tools from pacman and AUR"
echo "========================================================"
echo ""

# Install paru if not present
if ! command -v paru &> /dev/null; then
    echo "[INFO] Installing paru AUR helper..."
    sudo pacman -S --needed base-devel git || { echo "ERROR: Failed to install base-devel and git"; exit 1; }
    
    TMPDIR=$(mktemp -d) || { echo "ERROR: Failed to create temporary directory"; exit 1; }
    trap cleanup EXIT
    
    echo "[INFO] Cloning paru from AUR..."
    if ! git clone https://aur.archlinux.org/paru.git "$TMPDIR/paru"; then
        echo "ERROR: Failed to clone paru repository"
        exit 1
    fi
    
    cd "$TMPDIR/paru" || exit 1
    
    echo "[INFO] Building and installing paru..."
    if ! makepkg -si; then
        echo "ERROR: Failed to build/install paru"
        exit 1
    fi
    
    cd - > /dev/null || exit 1
    
    # Verify paru installation
    if command -v paru &> /dev/null; then
        echo "[OK] Paru installed successfully"
    else
        echo "ERROR: Paru installation verification failed"
        exit 1
    fi
fi

# Define colors
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m"

# Define functions to display headers and messages
display_header() {
    echo -e "${GREEN}"
    echo "*******************************************************"
    echo "        Welcome to Bug Bounty Hunting Tools! 🐞        "
    echo "   This script will install the most popular tools.    "
    echo "*******************************************************"
    echo -e "${NC}"
}

display_promotion() {
    echo -e "${BLUE}"
    echo "*******************************************************"
    echo "              Hack with passion 🔥                     "
    echo "   Follow me on Twitter/Instagram @withamankr          "
    echo "*******************************************************"
    echo -e "${NC}"
}

display_motivation() {
    echo -e "${RED}"
    echo "*******************************************************"
    echo "                Happy hunting! 🕵️‍♂️🕵️‍♀️                   "
    echo "          Remember, persistence pays off.              "
    echo "*******************************************************"
    echo -e "${NC}"
}

display_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Define function to install tools
install_tools() {
    # Print header
    display_message "${YELLOW}" "\n#######################################################"
    display_message "${YELLOW}" "#                                                     #"
    display_message "${YELLOW}" "#         Bug Bounty Hunting Tools Installer          #"
    display_message "${YELLOW}" "#                                                     #"
    display_message "${YELLOW}" "#######################################################"
    display_message "${NC}" ""

    # Update system
    display_message "${YELLOW}" "Updating system packages..."
    if paru -Syu; then
        display_message "${GREEN}" "System updated successfully."
    else
        display_message "${RED}" "WARNING: System update had issues, continuing anyway..."
    fi
    display_message "${BLUE}" "#######################################################"
    display_message "${NC}" ""

    # Prompt user to confirm installation
    echo ""
    echo "========================================================"
    read -p "Type 'yes' to proceed with installation (or anything else to cancel): " choice
    echo "========================================================"
    echo ""

    # If user confirms installation
    if [[ "$choice" == "yes" ]]; then
        display_message "${YELLOW}" "\nStarting installation..."
        display_message "${YELLOW}" "Log file: $LOG_FILE"

        # Install subdomain enumeration tools
        display_message "${GREEN}" "Installing subdomain enumeration tools..."
        if paru -S --noconfirm amass subfinder assetfinder subdomainizer sublister findomain; then
            display_message "${GREEN}" "Subdomain enumeration tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some subdomain enumeration tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install subdomain takeover tools
        display_message "${GREEN}" "Installing subdomain takeover tools..."
        if paru -S --noconfirm subjack subover autosubtakeover tko-subs; then
            display_message "${GREEN}" "Subdomain takeover tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some subdomain takeover tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install cloud workflow tools
        display_message "${GREEN}" "Installing cloud workflow tools..."
        if paru -S --noconfirm aws-cli aws-recon festin lazys3 s3brute flumberboozle slurp; then
            display_message "${GREEN}" "Cloud workflow tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some cloud workflow tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install fuzzing tools
        display_message "${GREEN}" "Installing fuzzing tools..."
        if paru -S --noconfirm gobuster wfuzz ffuf dirsearch; then
            display_message "${GREEN}" "Fuzzing tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some fuzzing tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install visual inspection tools
        display_message "${GREEN}" "Installing visual inspection tools..."
        if paru -S --noconfirm aquatone gowitness httpscreenshot; then
            display_message "${GREEN}" "Visual inspection tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some visual inspection tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install content discovery tools
        display_message "${GREEN}" "Installing content discovery tools..."
        if paru -S --noconfirm gospider hakrawler photon paramspider; then
            display_message "${GREEN}" "Content discovery tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some content discovery tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install CMS tools
        display_message "${GREEN}" "Installing CMS tools..."
        if paru -S --noconfirm wpscan drupwn wig; then
            display_message "${GREEN}" "CMS tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some CMS tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install GIT enum tools
        display_message "${GREEN}" "Installing GIT enum tools..."
        if paru -S --noconfirm githound gitgraber trufflehog gitscanner; then
            display_message "${GREEN}" "GIT enum tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some GIT enum tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install frameworks
        display_message "${GREEN}" "Installing frameworks..."
        if paru -S --noconfirm metasploit-framework armitage beef; then
            display_message "${GREEN}" "Frameworks installed successfully."
        else
            display_message "${RED}" "WARNING: Some frameworks failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install wordlists
        display_message "${GREEN}" "Installing wordlists..."
        if paru -S --noconfirm wordlists seclists dirb; then
            display_message "${GREEN}" "Wordlists installed successfully."
        else
            display_message "${RED}" "WARNING: Some wordlists failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install port scanning tools
        display_message "${GREEN}" "Installing port scanning tools..."
        if paru -S --noconfirm nmap masscan unicornscan; then
            display_message "${GREEN}" "Port scanning tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some port scanning tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install fingerprint & CVE tools
        display_message "${GREEN}" "Installing fingerprint & CVE tools..."
        if paru -S --noconfirm whatweb nikto wpscan sqlmap joomscan; then
            display_message "${GREEN}" "Fingerprint & CVE tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some fingerprint & CVE tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        # Install JS enum tools
        display_message "${GREEN}" "Installing JS enum tools..."
        if paru -S --noconfirm linkfinder jsbeautifier jsdetox subjs; then
            display_message "${GREEN}" "JS enum tools installed successfully."
        else
            display_message "${RED}" "WARNING: Some JS enum tools failed to install."
        fi
        display_message "${BLUE}" "#######################################################"
        display_message "${NC}" ""

        display_message "${YELLOW}" "\n#######################################################"
        display_message "${YELLOW}" "#                                                     #"
        display_message "${YELLOW}" "#          All tools installed successfully.          #"
        display_message "${YELLOW}" "#            Project  BBH Tools Installer             #"
        display_message "${YELLOW}" "#          Installation log: $LOG_FILE              #"
        display_message "${YELLOW}" "#                                                     #"
        display_message "${YELLOW}" "#######################################################"
    else
        display_message "${RED}" "\n#######################################################"
        display_message "${RED}" "#          Installation cancelled by user.            #"
        display_message "${RED}" "#                                                     #"
        display_message "${RED}" "#######################################################"
    fi
}

# Call functions
display_header
display_promotion
display_motivation
install_tools
