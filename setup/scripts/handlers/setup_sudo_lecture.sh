#!/bin/bash
# =============================================
# Handler: setup_sudo_lecture.sh
# Description: Installs a custom sudo lecture message
# =============================================

set -e

echo "🎭 Installing custom sudo lecture..."

# Enable lecture always
echo "Defaults        lecture=always" | sudo tee /etc/sudoers.d/lecture > /dev/null
sudo chmod 0440 /etc/sudoers.d/lecture

# Set custom message
sudo tee /etc/sudo_lecture > /dev/null <<'EOF'
⚠️  SUDO ACCESS GRANTED

This machine is managed by Bobbis Systems.
All sudo actions are logged and monitored.

Unauthorized use is strictly prohibited.
Proceed with caution.
EOF

echo "✅ Sudo lecture installed."
