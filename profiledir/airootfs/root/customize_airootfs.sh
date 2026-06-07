#!/usr/bin/env bash
# AnonOS AI Root Filesystem Customization
# Runs inside the ISO build chroot

set -e -u

# Enable systemd services
systemctl enable NetworkManager.service
systemctl enable bluetooth.service
systemctl enable anonos-firstboot.service
systemctl enable systemd-resolved.service

# Enable auto-login on tty1
systemctl enable getty@tty1.service

# Create default live user
useradd -m -G wheel,audio,video,storage -s /bin/bash anonos
echo "anonos:anonos" | chpasswd

# Copy skel files to home
cp -r /etc/skel/. /home/anonos/
chown -R anonos:anonos /home/anonos/

# Give passwordless sudo for live session
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/anonos-live

# Add anonos user to the autologin
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/override.conf << 'EOF'
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin anonos --noclear %I $TERM
EOF

# Create AnonOS wallpaper
mkdir -p /usr/share/backgrounds/anonos
cat > /usr/share/backgrounds/anonos/default.png << 'WALLPAPER'
# A solid black image for the hacker look
# Users can replace with their own wallpaper
WALLPAPER

# Create a simple PNG placeholder with ImageMagick if available
if command -v convert &>/dev/null; then
    convert -size 1920x1080 xc:black \
        -font JetBrains-Mono-Nerd-Font -fill '#00ff00' -pointsize 48 \
        -gravity center -annotate 0 'AnonOS\n\n"Access Granted"' \
        /usr/share/backgrounds/anonos/default.png 2>/dev/null || \
    convert -size 1920x1080 xc:black /usr/share/backgrounds/anonos/default.png 2>/dev/null || true
fi

# Set default shell for new users
sed -i 's|/bin/bash|/usr/bin/bash|' /etc/default/useradd

# Configure pacman
sed -i 's/^#Color/Color/' /etc/pacman.conf
sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i '/^\[options\]/a ILoveCandy' /etc/pacman.conf

# Add AnonOS MOTD
cat > /etc/motd << 'EOF'
[32m
  █████╗ ███╗   ██╗ ██████╗ ███╗   ██╗ ██████╗ ███████╗
 ██╔══██╗████╗  ██║██╔═══██╗████╗  ██║██╔═══██╗██╔════╝
 ███████║██╔██╗ ██║██║   ██║██╔██╗ ██║██║   ██║███████╗
 ██╔══██║██║╚██╗██║██║   ██║██║╚██╗██║██║   ██║╚════██║
 ██║  ██║██║ ╚████║╚██████╔╝██║ ╚████║╚██████╔╝███████║
 ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
[0m
 Welcome to [32mAnonOS[0m - Anonymous Operating System
 Type 'anonos-menu' or press [32mSuper+Space[0m to open the menu
 Type 'hi' for system information
EOF

# Create the user's default shell profile
cat > /etc/profile.d/anonos.sh << 'EOF'
# AnonOS system-wide profile
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
EOF
chmod +x /etc/profile.d/anonos.sh

# Ensure pacman mirrorlist is populated
if [ ! -s /etc/pacman.d/mirrorlist ]; then
    echo "Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
    echo "Server = https://mirror.rackspace.com/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
fi
