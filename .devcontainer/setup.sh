#!/bin/bash
set -e

# Install Caddy
echo "Installing Caddy..."
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt-get update
sudo apt-get install -y caddy

# Install PMTiles CLI
echo "Installing PMTiles CLI..."
# Install jq for JSON parsing (lightweight, no python needed)
sudo apt-get install -y jq

# Get the latest PMTiles release URL
PMTILES_URL=$(curl -s https://api.github.com/repos/protomaps/go-pmtiles/releases/latest | jq -r '.assets[] | select(.name | contains("Linux_x86_64")) | .browser_download_url')

if [ -z "$PMTILES_URL" ]; then
    echo "Error: Could not find PMTiles download URL"
    exit 1
fi

# Download and install PMTiles
curl -L "$PMTILES_URL" -o /tmp/pmtiles.tar.gz
tar -xzf /tmp/pmtiles.tar.gz -C /tmp
sudo mv /tmp/pmtiles /usr/local/bin/pmtiles
sudo chmod +x /usr/local/bin/pmtiles
rm /tmp/pmtiles.tar.gz

echo "Setup complete! Caddy and PMTiles CLI are installed."

