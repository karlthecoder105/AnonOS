#!/usr/bin/env bash
# AnonOS ISO Builder
set -e -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROFILE_DIR="$SCRIPT_DIR/profiledir"
OUT_DIR="$SCRIPT_DIR/build"

echo "  █████╗ ███╗   ██╗ ██████╗ ███╗   ██╗ ██████╗ ███████╗"
echo " ██╔══██╗████╗  ██║██╔═══██╗████╗  ██║██╔═══██╗██╔════╝"
echo " ███████║██╔██╗ ██║██║   ██║██╔██╗ ██║██║   ██║███████╗"
echo " ██╔══██║██║╚██╗██║██║   ██║██║╚██╗██║██║   ██║╚════██║"
echo " ██║  ██║██║ ╚████║╚██████╔╝██║ ╚████║╚██████╔╝███████║"
echo " ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝"
echo "                        ISO Builder"
echo ""

# Check prerequisites
command -v mkarchiso >/dev/null 2>&1 || { echo "Error: mkarchiso not found. Run the Docker container."; exit 1; }

# Clean old work dir (use local path, not the mounted output)
rm -rf /tmp/anonos-work 2>/dev/null || true
mkdir -p /tmp/anonos-work "$OUT_DIR"

echo "[*] Generating boot splash images..."

# Generate syslinux splash
if command -v convert &>/dev/null; then
    convert -size 640x400 xc:black \
        -font JetBrains-Mono-Nerd-Font -fill '#00ff00' -pointsize 36 \
        -gravity center -annotate +0-40 'AnonOS' \
        -pointsize 16 -annotate +0+20 '"Access Granted"' \
        "$PROFILE_DIR/syslinux/splash.png" 2>/dev/null || true
    convert -size 1024x768 xc:black \
        -font JetBrains-Mono-Nerd-Font -fill '#00ff00' -pointsize 48 \
        -gravity center -annotate +0-60 'AnonOS' \
        -pointsize 20 -annotate +0+30 '"Access Granted"' \
        "$PROFILE_DIR/grub/themes/anonos/background.png" 2>/dev/null || true
fi

# Remove splash references if no ImageMagick
if [ ! -f "$PROFILE_DIR/syslinux/splash.png" ]; then
    sed -i '/splash/d' "$PROFILE_DIR/syslinux/syslinux.cfg" 2>/dev/null || true
    sed -i '/splash/d' "$PROFILE_DIR/syslinux/archiso_sys.cfg" 2>/dev/null || true
fi
if [ ! -f "$PROFILE_DIR/grub/themes/anonos/background.png" ]; then
    sed -i '/desktop-image/d' "$PROFILE_DIR/grub/themes/anonos/theme.txt" 2>/dev/null || true
fi

echo "[*] Building AnonOS ISO..."
echo "[*] Profile: $PROFILE_DIR"
echo "[*] Output:  $OUT_DIR"
echo ""

# Build the ISO
mkarchiso -v -w /tmp/anonos-work -o "$OUT_DIR" "$PROFILE_DIR"

echo ""
echo "[✓] Build complete!"
echo "[*] ISO located in: $OUT_DIR"
ls -lh "$OUT_DIR"/*.iso 2>/dev/null || echo "    (check output directory)"
