#!/bin/bash
# =============================================
# Handler: install_docker.sh
# Description: Installs Docker and Docker Compose, sets up docker group and directory
# =============================================

set -e

echo "🐳 Installing Docker..."

# Check if Docker is already installed
if command -v docker &>/dev/null; then
  echo "✅ Docker is already installed. Skipping."
  exit 0
fi

# Create docker group if it doesn't exist
if ! getent group "$DOCKER_GROUP" > /dev/null; then
  echo "👥 Creating group: $DOCKER_GROUP"
  sudo groupadd "$DOCKER_GROUP"
fi

# Add the user to the Docker group
sudo usermod -aG "$DOCKER_GROUP" "$CREATE_USER"

# Install prerequisites
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine and plugins
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

# Create Docker directory
sudo mkdir -p "$DOCKER_DIR"
sudo chown "$CREATE_USER:$CREATE_USER" "$DOCKER_DIR"

echo "✅ Docker installation complete."
