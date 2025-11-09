#!/usr/bin/env bash
set -e  # Exit if any command fails

mkdir -p ~/.config ~/.local ~/.local/share

sudo dnf install -y xdg-user-dirs

#creates user directories
xdg-user-dirs-update
echo "Succesfully created user directories"

sudo dnf copr enable -y Yalter/niri
sudo dnf copr enable -y Codelovr/swayosd
sudo dnf copr enable -y Solopasha/hyprland
echo "Succesfully enabled copr repos"

#install required packages
sudo dnf install -y \
    greetd \
    tuigreet \
    kitty \
    rofi \
    fastfetch \
    ImageMagick \
    rust \
    cargo \
    flatpak \
    aria2 \
    pavucontrol \
    mate-polkit \
    nautilus \
    unzip \
    fish \
    nwg-look \
    swww \
    niri \
    swayosd \
    dbus-devel \
    cifs-utils
echo "Succesfully installed all packages"

#remove apps that niri installs by defulat that I won't use
sudo dnf remove alacritty fuzzel"

DOTFILES="$HOME/niri-setup"

echo "copying dotfiles..."
cp -r "$DOTFILES/bin" ~/.local/
cp -r "$DOTFILES/.config" ~/.config/
cp -r "$DOTFILES/fonts" ~/.local/share/
cp -r "$DOTFILES/.themes" ~/.themes
cp -r "$DOTFILES/wallpapers" ~/Pictures/

#cp greetd config to enable tuigreet
cp "$DOTFILES/config.toml" /etc/greetd/
echo "Succesfully copied dotfiles and folders"

chmod +x ~/.local/bin/appdrawer \
         ~/.local/bin/bgselector \
         ~/.local/bin/colorwaybar \
         ~/.local/bin/overviewlistener \
         ~/.local/bin/powermenu

#change shell to fish
chsh -s /usr/bin/fish
echo "Succesfully changed shell to fish"

# Make these services start automatically with Niri
systemctl --user add-wants niri.service mako.service
systemctl --user add-wants niri.service waybar.service
systemctl --user add-wants niri.service swww.service
systemctl --user add-wants niri.service overviewlistener.service

#enable other services
sudo systemctl enable --now swayosd-libinput-backend.service
sudo systemctl enable greetd.service
echo "Succesfully enabled all system and user services"

#enable flathub repo
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak update --appstream
echo "Succesfully enabled flathub"

#enable rpm fusion
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                     https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#enable open264 repo
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
echo "Succesfully enabled rpmfusion"

# Replace the neutered ffmpeg with the real one
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

# Install all the GStreamer plugins
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} \
  gstreamer1-plugin-openh264 gstreamer1-libav lame\* \
  --exclude=gstreamer1-plugins-bad-free-devel

# Install multimedia groups
sudo dnf group install -y multimedia
sudo dnf group install -y sound-and-video

# Install VA-API stuff
sudo dnf install -y ffmpeg-libs libva libva-utils
echo "Succesfully installed multimedia and codecs"

#install flatpaks
flatpak install -y flathub \
    com.github.tchx84.Flatseal \
    com.heroicgameslauncher.hgl \
    com.spotify.Client \
    com.valvesoftware.Steam \
    com.vysp3r.ProtonPlus \
    io.github.kolunmi.Bazaar \
    io.github.radiolamp.mangojuice \
    org.freedesktop.Platform.VulkanLayer.MangoHud//25.08 \
    org.freedesktop.Platform.VulkanLayer.gamescope//25.08 \
    org.localsend.localsend_app \
    org.mozilla.firefox \
    org.prismlauncher.PrismLauncher
echo "Succesfully installed flatpaks"

echo "✅ Setup complete! You may need to restart for some changes to take effect."
