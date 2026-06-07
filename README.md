# AnonOS

> Anonymous Operating System — Arch Linux · Hyprland · Hacker Aesthetic

AnonOS is an Arch Linux-based distribution with a pre-configured Hyprland desktop, Omarchy-style package management menu, security toolkit, and a green-on-black hacker theme throughout.

---

## Screenshots

| Component | Preview |
|-----------|---------|
| Desktop | Hyprland with Waybar, green borders, blurred terminals |
| Menu | rofi-based categorized installer (Super+Space) |
| Terminal | Kitty with JetBrains Mono, matrix-green on black |

*(Add screenshots to `screenshots/` and link them here)*

---

## Features

- **Hyprland** — Dynamic tiling Wayland compositor with hacker-green borders, smooth animations, blur, and shadows
- **anonos-menu** (Super+Space) — Omarchy-style menu to install packages, browse AUR, manage configs, and control the system
- **AUR + Pacman** — Full Arch repos plus AUR via yay, categorized into Editor, Browser, Gaming, Security, Development, Terminal, Social
- **Hacker Theme** — Green (`#00ff00`) on black everywhere: Kitty terminal, Waybar status bar, Rofi menus, Dunst notifications, Hyprlock screen, Starship prompt
- **Security Toolkit** — nmap, Wireshark, Metasploit, John the Ripper, Hydra, sqlmap, aircrack-ng, nikto, gobuster pre-installed
- **Developer Ready** — Python, Node.js, Go, Rust, Docker, Neovim, Git, Starship, zoxide, fzf, bat, eza
- **Auto-setup on first boot** — systemd service enables services and configures the live environment

---

## Quick Start

### Download the ISO

Grab the latest release from the [Releases page](https://github.com/karlthecoder105/AnonOS/releases) or build it yourself (see below).

### Flash to USB

```bash
# Find your USB device
lsblk

# Flash the ISO (replace /dev/sdX with your device)
sudo dd if=anonos-*.iso of=/dev/sdX bs=4M status=progress && sync
```

### Boot

1. Boot from the USB (disable Secure Boot in BIOS)
2. Login as `anonos` with password `anonos`
3. Press **Super+Space** to open the menu
4. Press **Super+Return** to open a terminal

---

## Keybindings

| Key | Action |
|-----|--------|
| `Super+Space` | Open AnonOS Menu |
| `Super+Return` | Open terminal (kitty) |
| `Super+Q` | Close focused window |
| `Super+D` | Application launcher (wofi) |
| `Super+E` | File manager (Thunar) |
| `Super+F` | Toggle fullscreen |
| `Super+V` | Toggle floating window |
| `Super+L` | Lock screen |
| `Super+T` | System monitor (btop) |
| `Super+W` | Matrix rain (cmatrix) |
| `Super+Shift+N` | Neovim |
| `Super+Shift+T` | Tmux |
| `Super+Shift+W` | Btop |
| `Super+Shift+Q` | Network manager (nmtui) |
| `Super+Shift+E` | Ranger file manager |
| `Super+1-0` | Switch workspace |
| `Super+Shift+1-0` | Move window to workspace |

---

## Terminal Commands

| Command | Description |
|---------|-------------|
| `hi` or `neo` | Show system info (fastfetch) |
| `cm` or `matrix` | Matrix rain effect |
| `hack` | Hollywood hacker mode |
| `update` | Full system update (pacman + yay) |
| `install <pkg>` | Install a package |
| `search <term>` | Search packages |
| `aur <pkg>` | Install from AUR |
| `aurs <term>` | Search AUR |
| `ports` | Show open ports |
| `myip` | Show public IP |
| `weather` | Terminal weather report |
| `cheat <topic>` | Cheat sheet for any topic |
| `clr` | Clear terminal |
| `sysinfo` | System information |

---

## Building the ISO

### Prerequisites

- Docker (with `--privileged` support)
- Or an Arch Linux host with `archiso` installed

### Build with Docker

```bash
git clone https://github.com/karlthecoder105/AnonOS.git
cd AnonOS

# Build the Docker image
docker build -t anonos-builder .

# Build the ISO
docker run --privileged --rm \
  -v $(pwd)/build:/build/build \
  anonos-builder ./build.sh

# The ISO will be in build/
ls -lh build/anonos-*.iso
```

### Build on Arch Linux natively

```bash
sudo pacman -S archiso
sudo ./build.sh
```

---

## Manual Installation on Arch

If you already have Arch Linux installed and just want the AnonOS configs:

```bash
# Install required packages
sudo pacman -S --noconfirm hyprland waybar rofi-wayland kitty dunst \
  starship fastfetch ttf-jetbrains-mono-nerd wofi

# Clone the repo
git clone https://github.com/karlthecoder105/AnonOS.git /tmp/anonos

# Copy configs
cp -r /tmp/anonos/profiledir/airootfs/etc/skel/. ~/

# Install anonos-menu
sudo cp /tmp/anonos/profiledir/airootfs/usr/local/bin/anonos-menu /usr/local/bin/

# Install yay (AUR helper)
git clone https://aur.archlinux.org/yay-bin.git /tmp/yay
cd /tmp/yay && makepkg -si --noconfirm
```

---

## Project Structure

```
AnonOS/
├── build.sh                         # ISO build script
├── Dockerfile                       # Docker build environment
├── Makefile                         # Convenience build targets
├── profiledir/                      # ArchISO profile
│   ├── profiledef.sh               # Profile definition
│   ├── packages.x86_64             # Package list
│   ├── pacman.conf                 # Pacman config
│   ├── syslinux/                   # BIOS bootloader config
│   ├── grub/                       # UEFI bootloader config
│   └── airootfs/                   # Root filesystem overlay
│       ├── etc/skel/               # Default user dotfiles
│       │   ├── .bashrc
│       │   ├── .config/hypr/       # Hyprland WM
│       │   ├── .config/kitty/       # Terminal
│       │   ├── .config/waybar/      # Status bar
│       │   ├── .config/rofi/        # Menu system
│       │   ├── .config/wofi/        # App launcher
│       │   ├── .config/dunst/       # Notifications
│       │   ├── .config/starship.toml
│       │   └── .config/gtk-3.0/
│       ├── root/customize_airootfs.sh
│       └── usr/local/bin/
│           ├── anonos-menu          # Main menu script
│           └── anonos-firstboot     # First boot setup
└── index.html                       # GitHub Pages website (root)
```

---

## The Menu System

Press **Super+Space** to open the AnonOS Menu. The menu is organized into categories:

### Install
- **Package** — Fuzzy-search and install any pacman package
- **AUR** — Auto-installs yay, then browse/search AUR packages
- **Editor** — VSCode, Cursor, Zed, Helix, Neovim, Emacs, Sublime Text
- **Browser** — Firefox, Chromium, Brave, Tor Browser, Vivaldi
- **Gaming** — Steam, RetroArch, Minecraft, Lutris, Heroic Launcher
- **Security** — nmap, Wireshark, Metasploit, John the Ripper, Hydra, sqlmap, Nikto, Gobuster, Aircrack-ng
- **Development** — Docker, Podman, VS Code, Node.js, Python, Go, Git tools
- **Terminal** — Alacritty, WezTerm, Tmux, Zellij, Zsh, Fish
- **Social** — Discord, Telegram, Signal, GitHub CLI

### Config
- Set wallpaper, GTK theme, font size
- Edit Hyprland, Waybar, Menu, or Bash configs

### System
- Full system update, clean cache, system info
- Reboot or shutdown

### About
- Keybindings reference, terminal commands cheat sheet

---

## Customization

### Wallpaper
```bash
# Via menu: Config > Set Wallpaper
# Or directly:
hyprctl hyprpaper wallpaper ", /path/to/image.jpg"
```

### Theme Colors
Edit the color variables at the top of each config file:
- `~/.config/hypr/hyprland.conf` — `$green = rgba(00ff00ff)`
- `~/.config/kitty/kitty.conf` — `foreground #00ff00`
- `~/.config/waybar/style.css` — `color: #00ff00`
- `~/.config/rofi/themes/hacker.rasi` — `border-col: #00ff00`

---

## Acknowledgments

- [Arch Linux](https://archlinux.org) — The foundation
- [Hyprland](https://hyprland.org) — The Wayland compositor
- [Omarchy](https://omarchy.org) — Inspiration for the menu system
- All the open-source projects that make this possible

---

*"The quieter you become, the more you can hear."*
