#!/bin/bash
# =============================================
# Handler: verify_install.sh
# Description: Performs post-installation checks and summary
# =============================================

set -e

echo "🔎 Verifying installation..."

# Check Docker
if command -v docker &> /dev/null; then
  echo "🐳 Docker installed: $(docker --version)"
else
  echo "❌ Docker not found"
fi

# Check Docker Compose
if docker compose version &> /dev/null; then
  echo "🧩 Docker Compose: $(docker compose version)"
else
  echo "❌ Docker Compose not available"
fi

# Check user
if [ ! -z "$CREATE_USER" ] && id "$CREATE_USER" &> /dev/null; then
  echo "👤 User $CREATE_USER exists"
  groups "$CREATE_USER"
else
  echo "❌ User $CREATE_USER not found"
fi

# Check firewall
if command -v ufw &> /dev/null; then
  echo "🛡️ UFW status:"
  sudo ufw status verbose
else
  echo "⚠️ UFW not installed or not found"
fi

# Check SSH
if systemctl is-active --quiet ssh; then
  echo "🔐 SSH is running"
else
  echo "⚠️ SSH not running"
fi

echo "✅ Verification complete."
