#!/bin/bash
# =============================================
# Handler: update_system.sh
# Description: Updates package lists and upgrades the system
# =============================================

set -e

echo "🔧 Updating system packages..."

# Ensure we're on a Debian/Ubuntu-based system
if ! command -v apt &> /dev/null; then
  echo "❌ This system does not use apt. Skipping system update."
  exit 0
fi

# Run update and upgrade
sudo apt update -y && sudo apt upgrade -y

echo "✅ System packages updated successfully."
