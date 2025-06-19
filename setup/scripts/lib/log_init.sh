#!/bin/bash
# =============================================
# File: log_init.sh
# Location: setup/scripts/lib/log_init.sh
# Description: Shared logger for all Bobbis Systems scripts
# =============================================

# Ensure LOG_DIR is set via sourced .env
if [ -z "$LOG_DIR" ]; then
  echo "❌ LOG_DIR is not defined. Did you forget to source the .env file?"
  exit 1
fi

# Determine current script context
SCRIPT_NAME=$(basename "$0" .sh)
SCRIPT_DIR_NAME=$(basename "$(dirname "$0")")

# Determine project subfolder
PROJECT_NAME="${SETUP_ENV:-generic-tool}" # fallback to 'generic-tool' if not set
PROJECT_LOG_DIR="$LOG_DIR/$PROJECT_NAME"

# Determine log file path
if [ "$SCRIPT_DIR_NAME" = "handlers" ]; then
  mkdir -p "$PROJECT_LOG_DIR/handlers"
  LOG_FILE="$PROJECT_LOG_DIR/handlers/${SCRIPT_NAME}.log"
else
  mkdir -p "$PROJECT_LOG_DIR"
  LOG_FILE="$PROJECT_LOG_DIR/${SCRIPT_NAME}-$(date +%F).log"
fi

# Start logging
exec > >(tee -a "$LOG_FILE") 2>&1

# Header
echo "============================================="
echo "📘 Log started: $(date)"
echo "📂 Project: $PROJECT_NAME"
echo "🔧 Script: $SCRIPT_NAME"
echo "============================================="
