#!/bin/bash
# =============================================
# Handler: uncomment_apt_sources.sh
# Description: Ensures community/universe/multiverse APT repos are enabled
# =============================================

set -e

echo "🔧 Checking and fixing APT sources..."

# Only apply to Debian/Ubuntu systems
if ! command -v apt &> /dev/null; then
  echo "❌ Not an APT-based system. Skipping source fixes."
  exit 0
fi

SOURCE_FILE="/etc/apt/sources.list"

# Backup first
sudo cp "$SOURCE_FILE" "${SOURCE_FILE}.bak"

# Uncomment universe and multiverse entries
sudo sed -i '/^# deb .* universe/ s/^# //' "$SOURCE_FILE"
sudo sed -i '/^# deb .* multiverse/ s/^# //' "$SOURCE_FILE"

# Add universe explicitly (idempotent)
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y universe

# Update APT
echo "🔄 Running apt update..."
sudo apt-get update -y

echo "✅ APT sources updated and universe/multiverse repos enabled."
