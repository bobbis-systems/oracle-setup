#!/bin/bash
# =============================================
# Handler: create_user.sh
# Description: Creates the user defined in .env and sets up sudo rights
# =============================================

set -e

echo "👤 Creating user: $CREATE_USER"

# Check if user already exists
if id "$CREATE_USER" &>/dev/null; then
  echo "ℹ️  User '$CREATE_USER' already exists. Skipping creation."
  exit 0
fi

# Create the user and set password
sudo useradd -m -s /bin/bash "$CREATE_USER"
echo "$CREATE_USER:$USER_PASSWORD" | sudo chpasswd

# Add to sudo group if requested
if [ "$ADD_TO_SUDOERS" = "true" ]; then
  echo "➕ Adding '$CREATE_USER' to sudo group..."
  sudo usermod -aG sudo "$CREATE_USER"
fi

# Allow passwordless sudo if requested
if [ "$NO_PASSWORD_SUDO" = "true" ]; then
  echo "🔓 Granting passwordless sudo to '$CREATE_USER'..."
  echo "$CREATE_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$CREATE_USER" > /dev/null
  sudo chmod 0440 "/etc/sudoers.d/$CREATE_USER"
fi

echo "✅ User '$CREATE_USER' created and configured successfully."
