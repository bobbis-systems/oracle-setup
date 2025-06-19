#!/bin/bash
# =============================================
# Handler: install_core_tools.sh
# Description: Installs nano, curl, wget, git, htop, etc.
# =============================================

set -e

echo "🛠️ Installing core tools..."

# Ensure we're on a Debian/Ubuntu-based system
if ! command -v apt &> /dev/null; then
  echo "❌ This system does not use apt. Skipping core tools installation."
  exit 0
fi

# Install useful core packages
sudo apt update
sudo apt install -y \
  nano \
  curl \
  wget \
  git \
  htop \
  unzip \
  lsb-release \
  ca-certificates \
  software-properties-common

echo "✅ Core tools installed successfully."
