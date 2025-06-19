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
⚠️  YOU ARE OPERATING WITH ROOT PRIVILEGES

All actions are being logged.
Unauthorized use may result in:
• Job termination
• Loss of data
• Severe mocking from your peers

This system is protected by advanced monitoring.
Proceed only if you are absolutely sure.

👁️ We are watching.
🔧 Managed by Bobbis Systems
EOF

echo "✅ Sudo lecture installed."
