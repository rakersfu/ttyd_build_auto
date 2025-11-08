#!/bin/sh

# ttyd installer with offline support and auto-uninstall

set -e

INSTALL_DIR="/opt/ttyd"
BIN_NAME="ttyd"
LOCAL_BIN="/usr/local/bin/$BIN_NAME"
OFFLINE_PACKAGE="./jkyd.x86_64"
REMOTE_URL="https://gitee.com/rakerose/gist/raw/master/jkyd.x86_64"

echo "Removing previous ttyd installation..."
rm -f "$INSTALL_DIR/$BIN_NAME"
rm -f "$LOCAL_BIN"
echo "Previous version removed."

echo "Checking for offline package..."
if [ -f "$OFFLINE_PACKAGE" ]; then
    echo "Offline package found. Installing from local file."
    mkdir -p "$INSTALL_DIR"
    cp "$OFFLINE_PACKAGE" "$INSTALL_DIR/$BIN_NAME"
else
    echo "No offline package found. Downloading from remote URL..."
    mkdir -p "$INSTALL_DIR"
    curl -L -o "$INSTALL_DIR/$BIN_NAME" "$REMOTE_URL"
fi

echo "Setting executable permission..."
chmod +x "$INSTALL_DIR/$BIN_NAME"

echo "Creating symlink to /usr/local/bin..."
ln -sf "$INSTALL_DIR/$BIN_NAME" "$LOCAL_BIN"

echo "Verifying installation..."
if ttyd --version; then
    echo "ttyd installed successfully!"
else
    echo "Installation failed. Please check permissions or paths."
fi
