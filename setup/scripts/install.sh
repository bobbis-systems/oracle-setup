#!/bin/bash
# =============================================
# File: setup/scripts/install.sh
# Description: Main installer logic
# =============================================

set -e

# === Load environment config ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ .env file not found at $ENV_FILE"
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

echo "🚀 Starting oracle-setup installation..."
echo "🧪 Target OS: $(grep ^ID= /etc/os-release | cut -d= -f2)"

# === Call handlers based on flags ===

if [ "$UPDATE_SYSTEM" = "true" ]; then
  bash "$SCRIPT_DIR/handlers/update_system.sh"
fi

if [ "$INSTALL_CORE_TOOLS" = "true" ]; then
  bash "$SCRIPT_DIR/handlers/install_core_tools.sh"
fi

if [ "$CREATE_USER" != "" ]; then
  bash "$SCRIPT_DIR/handlers/create_user.sh"
fi

if [ "$INSTALL_DOCKER" = "true" ]; then
  bash "$SCRIPT_DIR/handlers/install_docker.sh"
fi

if [ "$SETUP_UFW" = "true" ]; then
  bash "$SCRIPT_DIR/handlers/setup_firewall.sh"
fi

if [ "$CHECK_SSH" = "true" ]; then
  bash "$SCRIPT_DIR/handlers/check_ssh.sh"
fi

if [ "$SETUP_MOTD" = "true" ]; then
  bash "$SCRIPT_DIR/handlers/setup_motd.sh"
fi

# === Finalize ===
bash "$SCRIPT_DIR/handlers/verify_install.sh"

echo "✅ Install complete. You may want to reboot or logout/login to apply group changes."
