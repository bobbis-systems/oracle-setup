#!/bin/bash
# =============================================
# Handler: setup_timezone.sh
# Description: Sets system timezone from .env
# =============================================

set -e

echo "🌍 Setting timezone to $TIMEZONE..."

# Check if timedatectl is available
if ! command -v timedatectl &> /dev/null; then
  echo "❌ timedatectl not found. Cannot set timezone."
  exit 1
fi

# Validate timezone
if [ -z "$TIMEZONE" ]; then
  echo "❌ TIMEZONE not set in .env"
  exit 1
fi

if [ ! -f "/usr/share/zoneinfo/$TIMEZONE" ]; then
  echo "❌ Invalid timezone: $TIMEZONE"
  exit 1
fi

# Apply timezone
sudo timedatectl set-timezone "$TIMEZONE"

echo "✅ Timezone set to: $(timedatectl | grep 'Time zone')"
