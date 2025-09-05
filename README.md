
# WehttamSnaps Dotfiles 🎮📸

> **"Capturing Gaming Moments"**  
> A sleek, modular, and performant **Hyprland setup** for **gamers, streamers, and photographers** — built on Arch Linux with a **violet-to-cyan gradient theme**, inspired by TokyoNight and Sweet themes.

![WehttamSnaps Preview](preview.png)

---

## 🌟 Features

- **Hyprland + EWW Bar** – Fully modular, animated, and themed
- **Custom Welcome App** – System info, keybinds, updates, and settings
- **Game & Work Launchers** – One-click access to Steam, Lutris, Heroic, GIMP, Darktable, OBS
- **WebApps Integration** – Twitch, YouTube, Discord, Instagram
- **OBS Scene Control** – Switch scenes directly from EWW
- **Gaming Optimized** – Gamemode, ZRAM, Gamescope, FSR, AMDGPU
- **Streaming Ready** – OBS, Discord, PipeWire, Microphone control
- **Photography Workflow** – Darktable, GIMP, Krita, Thunar
- **Modular Dotfiles** – Easy to customize and extend
- **Fan Control & Thermal Management** – For small builds like yours

🎨 **Theme**: `Sweet-Amber-Blue-Dark-v40` + Custom EWW SCSS  
⌨️ **Keybinds**: Super + intuitive navigation  
🎮 **Gaming SSD**: `/run/media/wehttamsnaps/LINUXDRIVE-1`  
💾 **Storage**: Optimized for 120GB Linux SSD  
🖥️ **Hardware**: i5-4430 + RX 580 + 16GB RAM

---

## 🚀 Quick Install (Arch Linux)

```bash
# Clone repo
  git clone https://github.com/Crowdrocker/WehttamSnaps-dotfiles.git ~/Dotfiles
  cd ~/Dotfiles

# Run setup

  ./install.sh

# Reboot and enjoy!
```

> 💡 **Note**: This script assumes a fresh Arch install with `yay` or `paru` installed.

---

## 📂 Structure

| Folder       | Purpose |
|------------|--------|
| `config/hypr/`     | Modular Hyprland configs (keybinds, rules, monitors) |
| `config/eww/`      | EWW widgets, SCSS, scripts (bar, launchers, powermenu) |
| `scripts/`         | System, gaming, OBS, and utility scripts |
| `themes/`          | GTK, icons, and cursor themes |
| `setup/`           | Post-install automation |

---

## 🎮 Gaming Setup

- **Steam**: Native + Gamemode
- **Heroic (Epic)**: Flatpak or native
- **Lutris**: For GOG, Origin, etc.
- **SteamTinkerLaunch**: For modding (Vortex/MO2)
- **Gamescope**: For FSR upscaling
- **MangoHud**: In-game overlay

Example launch command:
```bash
gamescope -w 1920 -h 1080 -f -- gamemoderun heroic launch "Cyberpunk 2077"
```

---

## 📸 Creative Workflow

- **Darktable** – RAW photo editing
- **GIMP** – Image manipulation
- **Krita** – Digital painting
- **OBS Studio** – Streaming & recording
- **Thunar** – Fast file management

---

## 📺 Streaming Tools

- **OBS Studio** + **obs-cli** for scene switching
- **Discord** – Voice & community
- **Brave** – Private browsing
- **Spotify** – Background music

Switch OBS scenes from EWW:
```bash
~/.config/eww/scripts/obs-scene.sh "Gaming"
```

---

## 🛠️ Maintenance

| Script | Purpose |
|-------|--------|
| `scripts/system/update-system.sh` | Update system + Flatpaks |
| `scripts/system/themeswitcher.sh` | Toggle dark/light mode |
| `scripts/gaming/launch-cyberpunk.sh` | Launch with Gamescope |
| `scripts/utils/fancontrol-setup.sh` | Auto fan curve |

---

## 🤝 Contributing

Feel free to fork, customize, and share!  
Open issues for bugs or feature requests.

---

## 📸 Preview

![WehttamSnaps Screenshot](preview.png)

---

## 📜 License

MIT License – Do whatever you want, just give credit if you share.

---

## 🙌 Shoutout

Inspired by **JaKooLit**, improved for **gaming, streaming, and photography**.

---

## 📬 Contact

- **Twitch**: [twitch.tv/wehttamsnaps](https://twitch.tv/wehttamsnaps)
- **GitHub**: [@Crowdrocker](https://github.com/Crowdrocker)

---

🔥 **WehttamSnaps – Where photography meets gaming, beautifully.**
```

---

## ✅ Step 3: Add `post-install.sh`

Create: `~/.dotfiles/setup/post-install.sh`

```bash
#!/bin/bash
# WehttamSnaps Post-Install Script
# Run after Arch base install

echo "🚀 Installing WehttamSnaps..."

# Update system
sudo pacman -Syu --noconfirm

# Install helpers
sudo pacman -S --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si --noconfirm

# Install core
yay -S --noconfirm hyprland xdg-desktop-portal-hyprland eww-wayland ags-git \
  pipewire pipewire-pulse wireplumber mako grim slurp \
  waybar wlogout neovim zsh starship \
  noto-fonts noto-fonts-emoji ttf-jetbrains-mono-nerd \
  sweet-dark-theme-git papirus-icon-theme-git bibata-cursor-theme-bin \
  sddm sddm-sugar-candy-theme grub2-theme-vimix \
  networkmanager iwd dhcpcd \
  gamemode-git gamescope-git vkbasalt-git mangohud-git \
  steam-native com.heroicgameslauncher.hgl lutris \
  darktable gimp krita obs-studio discord brave-bin spotify-launcher \
  zram-generator

# Enable services
sudo systemctl enable sddm NetworkManager iwd pipewire pipewire-pulse wireplumber

# Copy configs
cp -r ~/.dotfiles/config/* ~/.config/
cp -r ~/.dotfiles/themes/* ~/.themes/

# Make scripts executable
chmod +x ~/.dotfiles/scripts/**.sh
chmod +x ~/.dotfiles/scripts/**/*.sh

# Set shell
chsh -s /bin/zsh wehttamsnaps

# Done
echo "✅ WehttamSnaps installed! Reboot to start."
```
Tag: `@hyprwm`, `@JaKooLit`, `@EliverLara`

---

---
