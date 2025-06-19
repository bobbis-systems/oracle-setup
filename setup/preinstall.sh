#!/bin/bash
# =============================================
# File: setup/preinstall.sh
# Description: Oracle-Setup Configuration Wizard
# =============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"
EXAMPLE_FILE="$SCRIPT_DIR/.env.example"
INSTALL_SCRIPT="$SCRIPT_DIR/scripts/install.sh"

echo "🧰 Oracle-Setup Config Wizard"
echo "─────────────────────────────"

# Copy .env.example if .env doesn't exist
if [ ! -f "$ENV_FILE" ]; then
  echo "📄 No .env found. Creating from example..."
  cp "$EXAMPLE_FILE" "$ENV_FILE"
fi

# Main menu
echo ""
echo "Choose how you want to proceed:"
echo ""
echo "1) Use interactive wizard (recommended)"
echo "2) Manually edit .env in nano"
echo "3) Use existing .env as-is"
echo "4) Exit"
echo ""
read -p "Enter choice [1]: " choice
choice="${choice:-1}"

# Load .env into environment
load_env() {
  set -a
  source "$ENV_FILE"
  set +a
}

# Interactive wizard
run_interactive_wizard() {
  load_env
  echo ""
  echo "🔧 Interactive Configuration Wizard"
  echo "Press Enter to keep existing value."

  read -p "CREATE_USER [$CREATE_USER]: " input
  CREATE_USER="${input:-$CREATE_USER}"

  read -p "USER_PASSWORD [$USER_PASSWORD]: " input
  USER_PASSWORD="${input:-$USER_PASSWORD}"

  read -p "INSTALL_DOCKER [$INSTALL_DOCKER]: " input
  INSTALL_DOCKER="${input:-$INSTALL_DOCKER}"

  read -p "DOCKER_DIR [$DOCKER_DIR]: " input
  DOCKER_DIR="${input:-$DOCKER_DIR}"

  read -p "SETUP_UFW [$SETUP_UFW]: " input
  SETUP_UFW="${input:-$SETUP_UFW}"

  read -p "ALLOW_HTTP [$ALLOW_HTTP]: " input
  ALLOW_HTTP="${input:-$ALLOW_HTTP}"

  read -p "ALLOW_HTTPS [$ALLOW_HTTPS]: " input
  ALLOW_HTTPS="${input:-$ALLOW_HTTPS}"

  read -p "SETUP_MOTD [$SETUP_MOTD]: " input
  SETUP_MOTD="${input:-$SETUP_MOTD}"

  echo ""
  echo "📋 Review Configuration:"
  echo "CREATE_USER=$CREATE_USER"
  echo "INSTALL_DOCKER=$INSTALL_DOCKER"
  echo "DOCKER_DIR=$DOCKER_DIR"
  echo "SETUP_UFW=$SETUP_UFW"
  echo "ALLOW_HTTP=$ALLOW_HTTP"
  echo "ALLOW_HTTPS=$ALLOW_HTTPS"
  echo "SETUP_MOTD=$SETUP_MOTD"
  echo ""

  read -p "Save & continue with installation? [Y/n]: " confirm
  confirm="${confirm:-Y}"
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    cat > "$ENV_FILE" <<EOF
CREATE_USER=$CREATE_USER
USER_PASSWORD=$USER_PASSWORD
INSTALL_DOCKER=$INSTALL_DOCKER
DOCKER_DIR=$DOCKER_DIR
SETUP_UFW=$SETUP_UFW
ALLOW_HTTP=$ALLOW_HTTP
ALLOW_HTTPS=$ALLOW_HTTPS
SETUP_MOTD=$SETUP_MOTD
EOF
    sudo bash "$INSTALL_SCRIPT"
  else
    echo "❌ Installation aborted."
    exit 0
  fi
}

# Manual edit
manual_edit() {
  echo "📂 Opening .env in nano..."
  sudo nano "$ENV_FILE"
  echo ""
  echo "👉 When you're ready, run:"
  echo "   sudo bash $INSTALL_SCRIPT"
}

# Use existing .env as-is
run_install_as_is() {
  echo "🚀 Running installation with current .env..."
  sudo bash "$INSTALL_SCRIPT"
}

case "$choice" in
  1) run_interactive_wizard ;;
  2) manual_edit ;;
  3) run_install_as_is ;;
  4) echo "❌ Exiting."; exit 0 ;;
  *) echo "❌ Invalid choice."; exit 1 ;;
esac
