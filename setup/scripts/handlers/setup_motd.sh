#!/bin/bash
# =============================================
# Handler: setup_motd.sh
# Description: Installs dynamic MOTD for Oracle VM branding
# =============================================

set -e

echo "🎨 Installing dynamic MOTD for Bobbis Systems..."

# === Directories ===
MOTD_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../assets/update-motd" && pwd)"
MOTD_TARGET_DIR="/etc/update-motd.d"

# === Remove default static MOTD ===
if [ -f /etc/motd ]; then
  echo "🧹 Removing static /etc/motd..."
  sudo rm -f /etc/motd
fi

# === Disable any old MOTD mechanisms ===
sudo rm -f /etc/motd.dynamic 2>/dev/null || true

# === Ensure update-motd.d exists ===
if [ ! -d "$MOTD_TARGET_DIR" ]; then
  echo "📁 Creating MOTD target directory..."
  sudo mkdir -p "$MOTD_TARGET_DIR"
fi

# === Copy custom segments ===
echo "📥 Copying MOTD segments..."
sudo cp "$MOTD_SOURCE_DIR"/* "$MOTD_TARGET_DIR/"

# === Set permissions ===
echo "🔒 Setting permissions..."
sudo chmod +x "$MOTD_TARGET_DIR/"*

# === Confirm ===
echo "✅ MOTD installed. It will appear on SSH login."
