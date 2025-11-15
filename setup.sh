#!/usr/bin/env bash
set -e  # Exit if any command fails

mkdir -p ~/.local ~/.local/share

sudo dnf install -y xdg-user-dirs

#creates user directories
xdg-user-dirs-update
echo "Created user directories"

sudo dnf copr enable -y yalter/niri
sudo dnf copr enable -y codelovr/swayosd
sudo dnf copr enable -y solopasha/hyprland
echo "Enabled copr repos"


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
    mako \
    mate-polkit \
    nautilus \
    unzip \
    fish \
    nwg-look \
    swww \
    niri \
    swayosd \
    dbus-devel \
    cifs-utils \
    ethtool

#remove apps that niri installs by defulat that I won't use
sudo dnf remove -y alacritty fuzzel
echo "Installed all packages"

DOTFILES="$HOME/niri-setup"

echo "Copying dotfiles..."
cp -r "$DOTFILES/bin" ~/.local/
cp -r "$DOTFILES/.config" ~/
cp -r "$DOTFILES/fonts" ~/.local/share/
cp -r "$DOTFILES/.themes" ~/
cp -r "$DOTFILES/wallpapers" ~/Pictures/

#cp greetd config to enable tuigreet
sudo cp "$DOTFILES/config.toml" /etc/greetd/
echo "Copied dotfiles and folders"

chmod +x ~/.local/bin/bgselector \
         ~/.local/bin/colorwaybar \
         ~/.local/bin/overviewlistener \
         ~/.local/bin/powermenu

#change shell to fish
chsh -s /usr/bin/fish
echo "Changed shell to fish"

# Make these services start automatically with Niri
systemctl --user add-wants niri.service mako.service
systemctl --user add-wants niri.service waybar.service
systemctl --user add-wants niri.service swww.service
systemctl --user add-wants niri.service overviewlistener.service

#enable other services
sudo systemctl enable --now swayosd-libinput-backend.service
sudo systemctl enable greetd.service
sudo systemctl set-default graphical.target
echo "Enabled all system and user services"

#enable flathub repo
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak update --appstream
echo "Enabled flathub"

#enable rpm fusion
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                     https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#enable open264 repo
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
echo "Enabled rpmfusion"

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
echo "Installed multimedia and codecs"

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
    org.prismlauncher.PrismLauncher \
    org.gnome.Loupe /
    tv.plex.PlexDesktop
echo "Installed flatpaks"

cd ~
echo "Cloning bzmenu repository..."
git clone https://github.com/e-tho/bzmenu ~/bzmenu
cd ~/bzmenu

echo "Building bzmenu with cargo..."
cargo build --release
cp target/release/bzmenu ~/.local/bin/
echo "bzmenu built successfully."


echo "Setup complete. You may need to restart for some changes to take effect."
