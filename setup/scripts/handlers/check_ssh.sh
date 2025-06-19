#!/bin/bash
# =============================================
# Handler: check_ssh.sh
# Description: Verifies SSH is running and configured securely
# =============================================

set -e

# === Load environment and logging ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../.env"
source "$SCRIPT_DIR/../lib/log_init.sh"

echo "🔍 Checking SSH service..."

# Ensure SSH service is installed
if ! systemctl list-unit-files | grep -q ssh; then
  echo "❌ SSH service not found. Installing openssh-server..."
  sudo apt update
  sudo apt install -y openssh-server
fi

# Start and enable SSH
sudo systemctl enable ssh
sudo systemctl start ssh

# Verify SSH is running
if systemctl is-active --quiet ssh; then
  echo "✅ SSH service is running."
else
  echo "❌ SSH service failed to start."
  exit 1
fi

# Optional: security check for root login
if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config; then
  echo "⚠️  Warning: SSH allows root login. Consider disabling this for security."
else
  echo "🔐 Root login over SSH is disabled or secured."
fi
