#!/bin/bash
# =============================================
# Handler: setup_firewall.sh
# Description: Installs and configures UFW based on .env options
# =============================================

set -e

# === Load env and logging ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../.env"
source "$SCRIPT_DIR/../lib/log_init.sh"

log_info "🛡️ Configuring firewall (UFW)..."

# Check if UFW is installed
if ! command -v ufw &> /dev/null; then
  log_info "📦 Installing UFW..."
  sudo apt update && sudo apt install -y ufw
else
  log_info "✅ UFW already installed."
fi

# Enable SSH before enabling firewall to prevent lockout
if [ "$ALLOW_SSH" = "true" ]; then
  sudo ufw allow OpenSSH
  log_info "🔓 SSH access allowed"
fi

# Optional ports
[ "$ALLOW_HTTP" = "true" ] && sudo ufw allow http && log_info "🌐 HTTP allowed"
[ "$ALLOW_HTTPS" = "true" ] && sudo ufw allow https && log_info "🔒 HTTPS allowed"

# Enable firewall if not active
if sudo ufw status | grep -q inactive; then
  log_info "🚪 Enabling UFW..."
  sudo ufw --force enable
else
  log_info "✅ UFW already active."
fi

# Summary
UFW_STATUS=$(sudo ufw status verbose)
log_info "📋 UFW status:\n$UFW_STATUS"

log_success "✅ Firewall configured successfully."
