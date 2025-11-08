#!/bin/bash

set -e

INSTALL_DIR="/opt/ttyd"
BIN_NAME="ttyd"
LOCAL_BIN="/usr/local/bin/$BIN_NAME"
OFFLINE_PACKAGE="./jkyd.x86_64"
REMOTE_URL="https://gitee.com/rakerose/gist/raw/master/jkyd.x86_64"
SERVICE_FILE="/etc/systemd/system/ttyd.service"
LOGFILE="/var/log/ttyd-install.log"

log() {
  echo "[$(date '+%F %T')] $1" | tee -a "$LOGFILE"
}

log "Removing previous ttyd installation..."
rm -f "$INSTALL_DIR/$BIN_NAME" "$LOCAL_BIN"
systemctl stop ttyd.service 2>/dev/null || true
systemctl disable ttyd.service 2>/dev/null || true
rm -f "$SERVICE_FILE"
log "Previous ttyd removed."

log "Checking for offline package..."
mkdir -p "$INSTALL_DIR"
if [ -f "$OFFLINE_PACKAGE" ]; then
  log "Offline package found. Installing from local file."
  cp "$OFFLINE_PACKAGE" "$INSTALL_DIR/$BIN_NAME"
else
  log "No offline package found. Downloading from remote..."
  curl -L -o "$INSTALL_DIR/$BIN_NAME" "$REMOTE_URL"
fi

chmod +x "$INSTALL_DIR/$BIN_NAME"
ln -sf "$INSTALL_DIR/$BIN_NAME" "$LOCAL_BIN"

log "Creating systemd service..."
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=ttyd Web Terminal
After=network.target

[Service]
ExecStart=$LOCAL_BIN --writable -p 7681 -c raker:845512 bash
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

log "Reloading systemd and enabling ttyd service..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable ttyd.service
systemctl start ttyd.service

log "[OK] ttyd service installed and started successfully."
