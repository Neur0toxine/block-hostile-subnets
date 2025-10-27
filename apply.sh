#!/bin/bash

ASNL="AS_Network_List"
SKIPA="CyberOK_Skipa_ips"
VENV_NAME="../venv"

if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

cd "$ASNL" || { echo "ASNLectory $ASNL not found"; exit 1; }

if [ ! -d "$VENV_NAME" ]; then
    cd ..
    python3 -m venv "$VENV_NAME"
    source "$VENV_NAME/bin/activate"
    pip install -r "$ASNL/requirements.txt"
else
    source "$VENV_NAME/bin/activate"
    cd ..
fi

cd "$ASNL"

bash blacklists_updater_txt.sh

(cd "./../$SKIPA/" && git pull)
cat "./../$SKIPA/"lists/skipa_cidr.txt >> ./blacklists/blacklist.txt
cat "./../$SKIPA/"lists/skipa_cidr.txt >> ./blacklists/blacklist-v4.txt
sort -u -o ./blacklists/blacklist.txt ./blacklists/blacklist.txt
sort -u -o ./blacklists/blacklist-v4.txt ./blacklists/blacklist-v4.txt

bash blacklists_updater_iptables.sh

deactivate
cd ..

ipset restore < "$ASNL/blacklists_iptables/blacklist.ipset"
iptables -D INPUT -m set --match-set blacklist-v4 src -j DROP 2>/dev/null || true
iptables -D FORWARD -m set --match-set blacklist-v4 src -j DROP 2>/dev/null || true
ip6tables -D INPUT -m set --match-set blacklist-v6 src -j DROP 2>/dev/null || true
ip6tables -D FORWARD -m set --match-set blacklist-v6 src -j DROP 2>/dev/null || true
iptables -I INPUT -m set --match-set blacklist-v4 src -j DROP 2>/dev/null || true
iptables -I FORWARD -m set --match-set blacklist-v4 src -j DROP 2>/dev/null || true
ip6tables -I INPUT -m set --match-set blacklist-v6 src -j DROP 2>/dev/null || true
ip6tables -I FORWARD -m set --match-set blacklist-v6 src -j DROP 2>/dev/null || true
