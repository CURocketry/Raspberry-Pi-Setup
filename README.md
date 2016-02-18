# Raspberry-Pi-Setup
This guide will walk through the steps required to setup a development or production environment to develop software for the Cornell Rocketry Team's launch vehicle controller.

## Running the setup script
### What will this do:
* Install programs and dependencies required for running the controller.
* Bind commonly used USB devices to static aliases, and give the current user permission to access tty USB devices.
* Enable the camera and I2C drivers to be loaded by the kernal on startup.

### Development
The development setup script is located in the `development/setup.sh` directory. The development script will ensure that the system is up to date, install development tools, and clone full git repos of all development dependencies.

### Production
The production setup script is located in the `production/setup.sh` directory.

### Running the Setup Process
The setup script sets up the environment for the currently logged in user.

        git clone https://github.com/CURocketry/RaspberryPiSetup
        cd development
        ./setup.sh
Note that some components of the script require root permissions to execute.

## Raspberry Pi Config
Run `sudo raspi-config` to adjust advanced system parameters.


## Setting up SSH and Internet Sharing
Most development will be conducted remotely without access to a monitor or keyboard. Connecting directly to a laptop might be somewhat finicky, but there are two tested ways to connect. These instructions were tested using Windows 10, and may vary between operating systems.

### Enable Internet Sharing (Optional)
Internet sharing is required if you want to share an internet connection through your laptop. To enable:

1. Go to the Network and Sharing Center -> Change Adapter Settings.
2. Right click on the connection you want to share. In this case, it'll probably be Wi-Fi. Right click on Wi-Fi -> properties.
3. Go to the "Sharing" tab. Check "Allow other network users to connect through this computer's internet connection." Select "Ethernet" for the "Home networking connection" option.
4. A prompt may pop up asking to assign a fixed IP to the Ethernet adapter. Click yes. If that prompt does not show up, that's okay. We'll make sure the settings are correct in the next step.
5. Go back to the adapter settings, and right click on Ethernet -> properties. Under the "This connection uses the following items:" heading, look for IPv4, and double click on it.
6. Under the window that shows up, make sure that "Use the following IP addresses: is selected, and a reasonable IP on a different subnet is selected. The default is `192.168.137.1` if you shared with the wifi adapter.  Also make sure that "Use the following DNS server addresses:" is selected and input `8.8.8.8`. Save your settings.
7. Note that it may require you to disconnect from your current network and reconnect, or to restart your computer for the changes to take effect.

### Method 1: Simple Sharing

1. Ensure that the Ethernet adapter has a fixed IP by following steps 5-7 in the Internet Sharing section.
2. Connect the Raspberry Pi to your ethernet port.
3. Open up command prompt, and type in `arp -a`. Look for the fixed IP you previously assigned to your ethernet adapter belonging to one of the "Interface" headings.
4. One of the ip addresses under the `192.168.137.*` subnet will belong to the Raspberry pi if you gave your ethernet adapter an IP address of `192.168.137.1`. If you know the MAC address of your raspberry pi, look for it under the Physical address heading. Try connecting using putty or ssh.

Note that these addresses are dynamically allocated and may change each time you reconnect the Raspberry pi.

### Method 2: DHCP Server
Using a DHCP server allows the laptop to assign an IP address to the Raspberry pi.

1. Download the [DHCP Server for Windows](www.dhcpserver.de), and unzip it.
2. Run `dhcpwiz.exe`. Select Ethernet under the "Network Interfaces dialog." If the corresponding ip address reads `0.0.0.0`, *stop* and follow steps 5-7 in the Internet Sharing section. After ensuring that the Ethernet adapter has a fixes IP address, click next.
3. In the "Supported Protocols" dialog, check HTTP and DNS. Set `8.8.8.8` as the "Forwarding Address". Click next.
4. Keep the default settings under the "Configuring DHCP for interface dialog." Click next.
5. On the "Write INI" dialog, click on the "Write INI file" button. Click next.
6. On the final window, make sure that firewall rules are configured. Check "Run DHCP server immediately" and finish.

Anytime that the DHCP server is running, visit `localhost` in a web browser to view all assigned IP addresses.

### Troubleshooting
* On the Raspberry Pi, edit `/etc/resolv.conf`. Try adding the following lines if they are not already there:

        nameserver 8.8.8.8
        nameserver <ethernet_adapter_ip>
Where `<ethernet_adapter_ip>` is the fixed ip given to your ethernet adapter on the host machine.

### Todo
* Use vagrant for seamless setup.
