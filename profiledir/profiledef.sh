#!/usr/bin/env bash
# shellcheck disable=SC2034

set -e -u

iso_name="anonos"
iso_label="ANONOS_$(date +%Y%m)"
iso_publisher="AnonOS <https://github.com/anonos>"
iso_application="AnonOS Live/Installer"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.grub')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="erofs"
airootfs_image_tool_options=('-zlz4hc,11')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script_setup"]="0:0:755"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/usr/local/bin/anonos-menu"]="0:0:755"
  ["/usr/local/bin/anonos-firstboot"]="0:0:755"
)
