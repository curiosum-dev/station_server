#!/bin/bash

# Station Server - Nerves Firmware Build & Burn Script

set -e

# Default target
TARGET=${1:-rpi3a}

if [[ "$TARGET" != "rpi4" && "$TARGET" != "rpi3a" ]]; then
    echo "❌ Error: Unsupported target '$TARGET'"
    echo "Usage: $0 [rpi4|rpi3a]"
    echo "  rpi4  - Raspberry Pi 4 (default)"
    echo "  rpi3a - Raspberry Pi 3A"
    exit 1
fi

echo "🔨 Building Station Server firmware for Raspberry Pi $(echo $TARGET | tr '[:lower:]' '[:upper:]')..."

# Set required environment variables
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PAGER=cat
export MIX_TARGET=$TARGET

# Build firmware
echo "📦 Building firmware..."
mix deps.get
mix firmware

echo "✅ Firmware built successfully!"
echo "📍 Firmware location: _build/${TARGET}_dev/nerves/images/station_server.fw"
echo "📏 Firmware size: $(du -h _build/${TARGET}_dev/nerves/images/station_server.fw | cut -f1)"

echo ""
echo "💾 To burn to SD card:"
echo "1. Insert SD card"
echo "2. Run: diskutil list"
echo "3. Run: export MIX_TARGET=$TARGET && mix burn"
echo "   or: fwup _build/${TARGET}_dev/nerves/images/station_server.fw"

echo ""
echo "🌐 After booting, access the device at:"
echo "   http://station_server.local:4000"
echo ""
echo "🔍 SSH access available at:"
echo "   ssh station_server.local"
echo ""
echo "🎉 Ready for deployment!"
