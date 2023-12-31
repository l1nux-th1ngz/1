#!/bin/bash

# Download the auto.sh script
curl -o auto.sh -sSL https://raw.githubusercontent.com/l1nux-th1ngz/1/main/auto.sh

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script requires root privileges to run." >&2
  exit 1
fi

# Update system
sudo pacman -Syu --noconfirm

# Update Arch Linux keyring
sudo pacman -Sy archlinux-keyring --noconfirm

# Update and optimize the mirrorlist
sudo pacman -Sy reflector --noconfirm
sudo reflector --country 'United States' --latest 10 --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --number 10

# Install Git
if command -v git &>/dev/null; then
  echo "Git v$(git -v | awk '{print $3}') is already installed in your system"
else
  sudo pacman -Sy git --noconfirm
fi

# Install Rustup as part of the Essential Programs
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup install nightly
rustup default nightly

# Check if yay is installed and install if not
if ! command -v yay &>/dev/null; then
  echo "Yay is not installed in your system. Installing Yay..."
  git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd ..
fi

# Making .config and Moving config files and background to Pictures
mkdir -p ~/.config
cp -R config/* ~/.config/

# Installing Essential Programs
yay -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender \
pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio dunst mako pipewire wireplumber polkit-kde-agent qt5-wayland qt6-wayland \
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr waybar rofi wofi fuzzel cliphist clipman hyprland ffmpeg neovim viewnior \
pavucontrol r starship wl-clipboard wf-recorder swaybg \
grimblast-git ffmpegthumbnailer tumbler playerctl \
waybar-hyprland wlogout swaylock-effects sddm-git pamixer \
nwg-look-bin nordic-theme papirus-icon-theme dunst otf-sora \
ttf-nerd-fonts-symbols-common otf-firamono-nerd inter-font \
ttf-fantasque-nerd noto-fonts noto-fonts-emoji ttf-comfortaa \
ttf-jetbrains-mono-nerd ttf-icomoon-feather ttf-iosevka-nerd \
adobe-source-code-pro-fonts brightnessctl hyprpicker-git \
xdg-user-dirs xdg-user-dirs-gtk --noconfirm

xdg-user-dirs-update
echo
echo "All necessary packages installed successfully."

# Customize pacman.conf
echo -e "Customizing pacman.conf"
sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 15/' /etc/pacman.conf
sudo sed -i '/^#multilib/s/^#//' /etc/pacman.conf

# Customize grub
echo -e "Customizing Grub"
sudo sed -i 's/^GRUB_TIMEOUT_STYLE=menu/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub
sudo sed -i 's/^GRUB_DEFAULT=0/GRUB_DEFAULT=0/' /etc/default/grub
sudo sed -i 's/^GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="rootflags=data=writeback"/' /etc/default/grub
sudo sed -i 's/^GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="rootflags=data=writeback"/' /etc/default/grub

# Update grub configuration
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Copy Config Files
read -n1 -rep "Would you like to copy config files? (y,n)" CFG
if [[ $CFG =~ ^[Yy]$ ]]; then
  printf "Copying config files...\n"
  cp -r dotconfig/dunst ~/.config/ 2>&1
  cp -r dotconfig/hypr ~/.config/ 2>&1
  cp -r dotconfig/kitty ~/.config/ 2>&1
  cp -r dotconfig/pipewire ~/.config/ 2>&1
  cp -r dotconfig/rofi ~/.config/ 2>&1
  cp -r dotconfig/swaylock ~/.config/ 2>&1
  cp -r dotconfig/waybar ~/.config/ 2>&1
  cp -r dotconfig/wlogout ~/.config/ 2>&1
  printf "All config files copied successfully.\n"
fi

# Reloading Font
fc-cache -vf

# Enable graphical login and change target from CLI to GUI
sudo systemctl enable sddm

echo "Installation and configuration completed. Reboot your system to apply the changes."
