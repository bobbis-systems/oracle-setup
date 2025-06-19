#!/bin/bash
# =============================================
# Handler: verify_install.sh
# Description: Performs post-installation checks and summary
# =============================================

set -e

# === Load env and logging ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../.env"
source "$SCRIPT_DIR/../lib/log_init.sh"

log_info "🔎 Starting post-install verification..."

# Docker check
if command -v docker &> /dev/null; then
  DOCKER_VER=$(docker --version)
  log_success "🐳 Docker installed: $DOCKER_VER"
else
  log_error "❌ Docker not found"
fi

# Docker Compose check
if docker compose version &> /dev/null; then
  DOCKER_COMPOSE_VER=$(docker compose version)
  log_success "🧩 Docker Compose: $DOCKER_COMPOSE_VER"
else
  log_error "❌ Docker Compose not available"
fi

# User check
if [ -n "$CREATE_USER" ] && id "$CREATE_USER" &> /dev/null; then
  log_success "👤 User '$CREATE_USER' exists"
  USER_GROUPS=$(groups "$CREATE_USER" | cut -d: -f2)
  log_info "📦 Groups: $USER_GROUPS"
else
  log_error "❌ User '$CREATE_USER' not found"
fi

# Firewall (UFW) check
if command -v ufw &> /dev/null; then
  UFW_STATUS=$(sudo ufw status verbose)
  log_info "🛡️ UFW status:\n$UFW_STATUS"
else
  log_warn "⚠️ UFW not installed or not found"
fi

# SSH check
if systemctl is-active --quiet ssh; then
  log_success "🔐 SSH is running"
else
  log_warn "⚠️ SSH is not running"
fi

log_success "✅ Verification complete."
