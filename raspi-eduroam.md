# This guide is for Raspberry Pis connecting to eduroam at UMass Amherst running Raspbian

Try reading this guide first on Github, if that does not suite you continue reading this guide below.

* Try connecting to the UMASS network, open a browser and go to umass.edu
If you see the photo below, the time settings on the raspberry pi need to be reconfigured.

Open the terminal on the menu bar and type the following command (replace YYYY with year, MM with month, and so on. HH must be in 24hr time):

```bash
sudo date -s 'YYYY-MM-DD HH:MM:SS'
```

If you see the updated date in the terminal below where you put in the command, great you date is now configured, try reloading the webpage.
If you do not see this error, move on to the next step

* To get the Raspberry Pi to connect to the eduroam network, a configuration file called the ‘wpa_supplicant’ must be configured correctly
below is the command for configuring this file appropriately. Please fill in your NETID and password into marked fields.

### TODO: FIX the paste section, they do not have internet. 

```bash
sudo tee -s $'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=l
country=US
network={
    ssid="eduroam"
    proto=RSN
    key_mgmt=WPA-EAP
    pairwise=CCMP
    auth_alg=OPEN
    eap=TTLS
    identity="NETID@umass.edu"
    anonymous_identity="NETID@umass.edu"
    password="NETIDPASSWORD"
    phase2="auth=PAP"
}' >> /etc/wpa_supplicant/wpa_supplicant.conf
```

Next we will need to edit the wpa function file in order to fix a bug in the Raspbian OS.

```bash
cd /etc/wpa_supplicant/
sudo vi functions.sh
```

Navigate to line 218 by typing :218 and at the end of this line

```bash
WPA_SUP_OPTIONS="$WPA_SUP_OPTIONS -D nl80211,wext"
```

change this line by swapping the last two library names to read:

```bash
WPA_SUP_OPTIONS="$WPA_SUP_OPTIONS -D wext,nl80211"
```

and then on line 227 (:227) change this:

```bash
WPA_SUP_OPTIONS = "$WPA_SUP_OPTIONS -D nl80211,wext"
```

Great, now the wpa functions.sh script will load these libraries in the right order. Now a similar thing needs to be done in another file called /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant

```bash
cd /lib/dhcpcd/dhcpcd-hooks/
sudo vi 10-wpa_supplicant
```

Around line 58-60ish there is a line containing

```bash
wpa_supplicant_driver="${wpa_supplicant_driver:-nl80211,wext}"
```

we need to again swap the library order to read:

```bash
wpa_supplicant_driver="${wpa_supplicant_driver:-wext,nl80211}"
```

Great, now we can try and reboot.

Barring typos and/or configuration differences between Pi's and versions of the Raspbian OS, the r-pi should now be connected to eduroam.
