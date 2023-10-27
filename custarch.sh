cd ~/archiso_build_folder

# Add packages to packages.x86_64 file
cat <<EOF >> ./packages.x86_64
python
python-systemd
python-psutil
git
wayland
chromium
which
gdb
ninja
gcc
cmake
meson
libxcb
xcb-proto
xcb-util
xcb-util-keysyms
libxfixes
libx11
libxcomposite
xorg-xinput
libxrender
pixman
wayland-protocols
cairo
pango
seatd
libxkbcommon
xcb-util-wm
xorg-xwayland
libinput
libliftoff
libdisplay-info
cpio
dunst
mako
pipewire
wireplumber
xdg-desktop-portal-wlr
xdg-desktop-portal-hyprland
xdg-desktop-portal-hyprland
xdg-desktop-portal-gtk
cliphist
clipman
rofi
wofi
fuzzel
firefox
qt5-wayland
qt6-wayland
polkit-kde-agent
EOF

# Customize airootfs
cat <<EOF >> ./airootfs/root/customize_airootfs.sh
cd /root
git clone --recursive https://github.com/Torxed/archinstall_gui.git
cp archinstall_gui/INSTALL/archinstall_gui.service /etc/systemd/system/
cp -r archinstall_gui /srv/
chmod +x /srv/archinstall_gui/webgui.py
systemctl daemon-reload
systemctl enable archinstall_gui.service
EOF

mkdir -p ./airootfs/etc/skel

# Add Wayland launch command to .zprofile
echo '[[ -z $WAYLAND_DISPLAY && $XDG_VTNR -eq 1 ]] && sh -c "startx"' >> ./airootfs/etc/skel/.zprofile
