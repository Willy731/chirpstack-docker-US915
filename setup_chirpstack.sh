#!/bin/bash
set -e
echo "This script will set up ChirpStack on a Raspberry Pi with Docker."
echo "This setup is for US915 LoRaWAN devices."
echo "NOTE: This script is designed to be run on a Raspberry Pi with the WM1302 SPI with Pi Hatand may not work on other systems."

echo "This will install prerequisites, clone the ChirpStack Docker repository, import LoRaWAN device profiles, enable SPI, I2C, and UART, and set up ChirpStack to start on boot."

echo "====================================================="
echo "NOTE: This must be run standalone and will reclone the repository if it is not already clones as '/opt/chirpstack-docker' directory."
echo "====================================================="

echo "[Step 1] Installing prerequisites..."
apt-get update
apt-get install -y build-essential git curl
echo "Installing Docker..."
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing..."
    curl -fsSL https://get.docker.com | sh
fi

echo "Installing Docker Compose..."
apt-get install -y docker-compose

echo "[Step 2] Cloning ChirpStack Docker repository..."


if [ ! -d "/opt/chirpstack-docker" ]; then
    git clone -b feature-us915 https://github.com/Willy731/chirpstack-docker-US915.git "/opt/chirpstack-docker"
else
    echo "Repository already cloned."
fi

cd /opt/chirpstack-docker

if [ ! -f ".imported-lorawan-devices" ]; then
    echo "Importing LoRaWAN device profiles..."
    make import-lorawan-devices
    touch .imported-lorawan-devices
else
    echo "LoRaWAN device profiles already imported. Skipping."
fi

echo "[Step 3] Enabling SPI, I2C, and UART..."
raspi-config nonint do_spi 0
raspi-config nonint do_i2c 0
raspi-config nonint do_serial_cons 1 # Disable serial login shell (1 for false/off)
raspi-config nonint do_serial_hw 0 # Enable serial port hardware (0 for true/on)

echo "[Step 4] Setting up Chirpstack Service start on Boot"

cp service/chirpstack-docker.service /etc/systemd/system/
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable chirpstack-docker
systemctl start chirpstack-docker

echo "[Step 5] Rebooting the system..."

echo "After Reboot run the following command to display the Gateway_EUI: "
echo "====================================================="
echo "sudo docker exec chirpstack-concentratord gateway_eui"
echo "====================================================="
echo "Setup the gateway."
echo "  1. Go to http://localhost:8080 and login with "admin:admin""
echo "      - Change user/pass when able."
echo "      - If login is needed on LAN run 'hostname -I' to get the IP address."
echo "  2. Create a Gateway under the Tenant Section in the Left menu"
echo "      - Use the  gateway_id from the command above as the Gateway ID."
echo "  3. Create a Device Profile"
echo "      - Use one of the templates from the Device Profile Templates option"
echo "  4. Create an Application Profile"
echo "      - Use the Device Profile created above."
echo "  5. Add a Device to the Application. You will need the:"
echo "    1. DevEUI"
echo "    2. AppEUI"
echo "    3. Application Key (Default is 2B7E151628AED2A6ABF7158809CF4F3C)"
reboot
