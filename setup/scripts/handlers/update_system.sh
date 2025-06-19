#!/bin/bash
# =============================================
# Handler: update_system.sh
# Description: Updates package lists and upgrades the system
# =============================================

set -e

# === Load environment and logging ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../.env"
source "$SCRIPT_DIR/../lib/log_init.sh"

log_info "🔧 Updating system packages..."

# Ensure we're on a Debian/Ubuntu-based system
if ! command -v apt &> /dev/null; then
  log_warn "This system does not use apt. Skipping system update."
  exit 0
fi

# Update and upgrade
sudo apt update -y && sudo apt upgrade -y

log_success "✅ System packages updated successfully."
