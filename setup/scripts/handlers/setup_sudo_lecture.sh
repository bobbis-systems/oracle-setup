#!/bin/bash
# =============================================
# Handler: setup_sudo_lecture.sh
# Description: Installs a custom sudo lecture message
# =============================================

set -e

# === Load environment and logging ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../.env"
source "$SCRIPT_DIR/../lib/log_init.sh"

log_info "🎭 Installing custom sudo lecture..."

# === Ensure sudoers.d exists ===
if [ ! -d /etc/sudoers.d ]; then
  log_warn "Creating missing sudoers.d directory..."
  sudo mkdir -p /etc/sudoers.d
  sudo chmod 0750 /etc/sudoers.d
fi

# === Always show lecture ===
echo "Defaults        lecture=always" | sudo tee /etc/sudoers.d/lecture > /dev/null
sudo chmod 0440 /etc/sudoers.d/lecture

# === Set custom lecture message ===
sudo tee /etc/sudo_lecture > /dev/null <<'EOF'
⚠️  SUDO ACCESS GRANTED

This machine is managed by Bobbis Systems.
All sudo actions are logged and monitored.

Unauthorized use is strictly prohibited.
Proceed with caution.
EOF

log_success "✅ Sudo lecture installed successfully."
