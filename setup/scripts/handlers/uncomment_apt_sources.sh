#!/bin/bash
# =============================================
# Handler: uncomment_apt_sources.sh
# Description: Ensures universe and multiverse APT repos are enabled
# =============================================

set -e

# === Load environment and logging ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../.env"
source "$SCRIPT_DIR/../lib/log_init.sh"

log_info "🔧 Checking and fixing APT sources..."

# Ensure we're on an APT-based system
if ! command -v apt &> /dev/null; then
  log_error "Not an APT-based system. Skipping APT source updates."
  exit 0
fi

SOURCE_FILE="/etc/apt/sources.list"
BACKUP_FILE="${SOURCE_FILE}.bak"

# === Backup the sources list ===
log_info "📦 Backing up sources.list to $BACKUP_FILE"
sudo cp "$SOURCE_FILE" "$BACKUP_FILE"

# === Uncomment universe and multiverse entries ===
sudo sed -i '/^# deb .* universe/ s/^# //' "$SOURCE_FILE"
sudo sed -i '/^# deb .* multiverse/ s/^# //' "$SOURCE_FILE"

# === Ensure universe is enabled explicitly ===
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y universe

# === Refresh package list ===
log_info "🔄 Running apt update..."
sudo apt-get update -y

log_success "✅ APT sources updated and universe/multiverse repos enabled."
