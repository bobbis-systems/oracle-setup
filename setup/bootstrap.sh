#!/bin/bash
# =============================================
# File: setup/bootstrap.sh
# Description: Bootstrap script for Oracle VMs
# Usage: curl -fsSL .../bootstrap.sh | bash
# =============================================

set -e

echo "🧰 Starting oracle-setup bootstrap..."

# === Ensure Git is installed ===
if ! command -v git &>/dev/null; then
  echo "🔧 Git is not installed. Attempting to install..."

  if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
      ubuntu|debian)
        sudo apt update && sudo apt install -y git
        ;;
      alpine)
        sudo apk update && sudo apk add git
        ;;
      centos|rhel|fedora)
        sudo yum install -y git
        ;;
      *)
        echo "❌ Unsupported distro: $ID — please install Git manually."
        exit 1
        ;;
    esac
  else
    echo "❌ Unknown OS. Please install Git manually and re-run."
    exit 1
  fi
fi

echo "✅ Git is available."

# === Create /opt/scripts if it doesn't exist ===
if [ ! -d /opt/scripts ]; then
  echo "📁 Creating /opt/scripts directory..."
  sudo mkdir -p /opt/scripts
  sudo chown $USER:$USER /opt/scripts
fi

# === Clone the repo ===
if [ -d /opt/scripts/oracle-setup ]; then
  echo "📦 Repo already exists at /opt/scripts/oracle-setup. Skipping clone."
else
  echo "📥 Cloning oracle-setup..."
  git clone https://github.com/bobbis-systems/oracle-setup.git /opt/scripts/oracle-setup
fi

# === Navigate and start install ===
cd /opt/scripts/oracle-setup/setup/

# Copy .env.example if .env doesn't exist
if [ ! -f .env ]; then
  cp .env.example .env
  echo "⚠️  Remember to edit /opt/scripts/oracle-setup/setup/.env before running full install."
fi

# Run the installer
echo "🚀 Launching installer..."
sudo bash scripts/install.sh
