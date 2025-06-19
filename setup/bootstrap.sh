#!/bin/bash
# =============================================
# File: setup/bootstrap.sh
# Description: Bootstrap script for Oracle VMs
# Usage: sudo bash -c "$(curl -fsSL https://.../bootstrap.sh)"
# =============================================

set -e

# === Require root (via sudo) ===
if [ "$EUID" -ne 0 ]; then
  echo "❌ This script must be run with sudo:"
  echo "   sudo bash bootstrap.sh"
  exit 1
fi

echo "🧰 Starting oracle-setup bootstrap..."

# === Ensure Git is installed ===
if ! command -v git &>/dev/null; then
  echo "🔧 Git not found — installing..."

  if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
      ubuntu|debian)
        apt update && apt install -y git
        ;;
      alpine)
        apk update && apk add git
        ;;
      centos|rhel|fedora)
        yum install -y git
        ;;
      *)
        echo "❌ Unsupported distro: $ID — install Git manually."
        exit 1
        ;;
    esac
  else
    echo "❌ Unknown OS — please install Git manually."
    exit 1
  fi
fi

echo "✅ Git is available."

# === Create /opt/scripts if missing ===
if [ ! -d /opt/scripts ]; then
  echo "📁 Creating /opt/scripts..."
  mkdir -p /opt/scripts
fi

# === Clone repo ===
if [ -d /opt/scripts/oracle-setup ]; then
  echo "📦 Repo already exists at /opt/scripts/oracle-setup — skipping clone."
else
  echo "📥 Cloning oracle-setup..."
  git clone https://github.com/bobbis-systems/oracle-setup.git /opt/scripts/oracle-setup
fi

cd /opt/scripts/oracle-setup/setup/

# === Copy .env.example if .env doesn't exist ===
if [ ! -f .env ]; then
  cp .env.example .env
  echo ""
  echo "⚙️  A default .env file was created:"
  echo "   /opt/scripts/oracle-setup/setup/.env"
  echo ""
  echo "📝 Please edit it before continuing:"
  echo "   nano /opt/scripts/oracle-setup/setup/.env"
  echo ""
fi

echo "🔧 Making scripts executable..."
chmod +x /opt/scripts/oracle-setup/setup/scripts/*.sh
chmod +x /opt/scripts/oracle-setup/setup/scripts/handlers/*.sh



# === Final instructions ===
echo ""
echo "✅ Bootstrap complete!"
echo "👉 To start installation, run:"
echo "   sudo bash /opt/scripts/oracle-setup/setup/scripts/install.sh"


