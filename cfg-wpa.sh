#!/bin/sh
# TO RUN THIS SCRIPT:
# chmod +x ./cfg-wpa.sh
# ./cfg-wpa.sh
echo "Enter netid username in format: NETIDUSERNAME@umass.edu"
read B_USERNAME

echo "Enter netid password"
read B_PASSWORD


echo 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US
network={
    ssid="eduroam"
    proto=RSN
    key_mgmt=WPA-EAP
    pairwise=CCMP
    auth_alg=OPEN
    eap=TTLS
    identity="/$B_USERNAME"
    anonymous_identity="/$B_USERNAME"
    password="/$B_PASSWORD"
    phase2="auth=PAP"
}' | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf