#!/bin/bash

# Advanced Hyprland Installation Script by
# WehttamSnaps ( https://github.com/Crowdrocker/WehttamSnaps-dotfiles )
echo -e "${VIOLET}"
cat << "EOF"
██     ██ ███████ ██   ██ ████████ ████████  █████  ███    ███ ███████ ███    ██  █████  ██████  ███████ 
██     ██ ██      ██   ██    ██       ██    ██   ██ ████  ████ ██      ████   ██ ██   ██ ██   ██ ██      
██  █  ██ █████   ███████    ██       ██    ███████ ██ ████ ██ ███████ ██ ██  ██ ███████ ██████  ███████ 
██ ███ ██ ██      ██   ██    ██       ██    ██   ██ ██  ██  ██      ██ ██  ██ ██ ██   ██ ██           ██ 
 ███ ███  ███████ ██   ██    ██       ██    ██   ██ ██      ██ ███████ ██   ████ ██   ██ ██      ███████ 
EOF
# color defination
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;1;35m"
cyan="\e[1;36m"
orange="\x1b[38;5;214m"
end="\e[1;0m"

if command -v gum &> /dev/null; then

display_text() {
    gum style \
        --border rounded \
        --align center \
        --width 60 \
        --margin "1" \
        --padding "1" \
'
   __ __                            ___
  / // /_ _____  ___________  ___  / _/
 / _  / // / _ \/ __/ __/ _ \/ _ \/ _/ 
/_//_/\_, / .__/_/  \__/\___/_//_/_/   
     /___/_/                                
'
}

else
display_text() {
    cat << "EOF"
   __ __                            ___
  / // /_ _____  ___________  ___  / _/
 / _  / // / _ \/ __/ __/ _ \/ _ \/ _/ 
/_//_/\_, / .__/_/  \__/\___/_//_/_/   
     /___/_/                              

EOF
}
fi

clear && display_text
printf " \n \n"

###------ Startup ------###

# finding the presend directory and log file
dir="$(dirname "$(realpath "$0")")"
# log directory
log_dir="$dir/Logs"
log="$log_dir"/dotfiles.log
mkdir -p "$log_dir"
touch "$log"

# message prompts
msg() {
    local actn=$1
    local msg=$2

    case $actn in
        act)
            printf "${green}=>${end} $msg\n"
            ;;
        ask)
            printf "${orange}??${end} $msg\n"
            ;;
        dn)
            printf "${cyan}::${end} $msg\n\n"
            ;;
        att)
            printf "${yellow}!!${end} $msg\n"
            ;;
        nt)
            printf "${blue}\$\$${end} $msg\n"
            ;;
        skp)
            printf "${magenta}[ SKIP ]${end} $msg\n"
            ;;
        err)
            printf "${red}>< Ohh sheet! an error..${end}\n   $msg\n"
            sleep 1
            ;;
        *)
            printf "$msg\n"
            ;;
    esac
}

# ----------------------------------------------------------
# Ask if the user wants to update the mirrorlist
# ----------------------------------------------------------

info_message "Do you want to update the mirrorlist to use the 10 best servers of your country? (y/n, default:y): "
read mirror_choice
mirror_choice=${mirror_choice:-y}

if [[ "$mirror_choice" == "y" ]]; then
  sudo pacman -S --needed --noconfirm reflector rsync
  while true; do
    clear
    info_message "Specify your country (country name):"
    read country_choice
    
    if reflector --list-countries 2>/dev/null | grep -qi "^${country_choice}"; then
      info_message "Updating mirrorlist for $country_choice..."
      if sudo reflector --country "$country_choice" --latest 10 --sort rate --save /etc/pacman.d/mirrorlist; then
        success_message "Mirrorlist updated successfully!"
        break
      else
        error_message "Error updating mirrorlist. Please try again."
        sleep 1
      fi
    else
      error_message "'$country_choice' is not a valid country name."
      sleep 1
      info_message "Would you like to try again? (y/n, default:y): "
      read retry_choice
      retry_choice=${retry_choice:-y}
      if [[ "$retry_choice" != "y" ]]; then
        info_message "Skipping mirrorlist update."
        break
      fi
    fi
  done
fi

sleep 1
clear


# ----------------------------------------------------------
# Check if yay is installed. If not, installs it
# ----------------------------------------------------------

if command -v yay > /dev/null; then
  success_message "yay is installed. Skipping installation"
else
  error_message "yay is not installed. Installing..."
  sleep 1
  sudo pacman -S --needed --noconfirm base-devel less
  whereami=$(pwd)
  git clone https://aur.archlinux.org/yay.git ~/Downloads/yay
  cd ~/Downloads/yay
  makepkg -si
  cd $whereami
  rm -rf ~/Downloads/yay
  success_message "yay has been installed successfully"
fi

sleep 1
clear


# Enable Chaotic-AUR
echo -e "${VIOLET}Setting up Chaotic-AUR...${NC}"
if ! grep -q "chaotic-aur" /etc/pacman.conf; then
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.xz'
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.xz'
    
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
    sudo pacman -Syu
fi

# Core Hyprland packages
HYPRLAND_CORE=(
    "hyprland"
    "hyprpaper" 
    "hypridle"
    "hyprlock"
    "hyprpicker"
    "hyprcursor"
    "xdg-desktop-portal-hyprland"
    "qt5-wayland"
    "qt6-wayland"
    "polkit-kde-agent"
)

# Window Manager & Desktop Environment
WM_DE=(
    "waybar"
    "rofi-wayland" 
    "fuzzel"
    "dunst"
    "mako"
    "swww"
    "grim"
    "slurp"
    "wl-clipboard"
    "cliphist"
    "brightnessctl"
    "playerctl"
    "pavucontrol"
    "bluez"
    "bluez-utils"
    "blueman"
    "network-manager-applet"
)

# Audio & Video
AUDIO_VIDEO=(
    "pipewire"
    "pipewire-alsa" 
    "pipewire-pulse"
    "pipewire-jack"
    "wireplumber"
    "obs-studio"
    "ffmpeg"
    "mpv"
    "vlc"
)

# File Management & System Tools
FILE_SYSTEM=(
    "thunar"
    "thunar-volman"
    "thunar-archive-plugin"
    "thunar-media-tags-plugin"
    "file-roller"
    "ark"
    "nemo"
    "nemo-fileroller"
    "gvfs"
    "gvfs-mtp"
    "udiskie"
)

# Terminal & Shell
TERMINAL_SHELL=(
    "kitty"
    "alacritty"
    "foot"
    "zsh"
    "zsh-completions"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "starship"
    "eza"
    "bat"
    "fd"
    "ripgrep"
    "fzf"
    "tree"
    "neofetch"
    "fastfetch"
    "btop"
    "htop"
)

# Development Tools
DEVELOPMENT=(
    "git"
    "github-cli"
    "neovim"
    "vim"
    "code"
    "nodejs"
    "npm"
    "python"
    "python-pip"
    "rustup"
    "go"
    "docker"
    "docker-compose"
    "base-devel"
    "cmake"
    "ninja"
)

# Gaming & Multimedia
GAMING=(
    "steam"
    "lutris"
    "heroic-games-launcher-bin"
    "mangohud"
    "gamemode"
    "gamescope"
    "wine"
    "winetricks"
    "dxvk"
    "lib32-vulkan-radeon"
    "vulkan-radeon"
    "lib32-mesa"
    "mesa"
    "xorg-xrandr"
)

# Photography & Creative Tools
CREATIVE=(
    "gimp"
    "krita"
    "inkscape"
    "blender"
    "kdenlive"
    "audacity"
    "darktable"
    "rawtherapee"
    "hugin"
    "digikam"
)

# System & Hardware
SYSTEM_HARDWARE=(
    "lm_sensors"
    "pwm-fan-control"
    "ufw"
    "cups"
    "system-config-printer"
    "hplip"
    "sane"
    "simple-scan"
    "power-profiles-daemon"
    "tlp"
    "auto-cpufreq"
    "thermald"
)

# Fonts & Themes
FONTS_THEMES=(
    "noto-fonts"
    "noto-fonts-emoji"
    "ttf-jetbrains-mono"
    "ttf-fira-code"
    "ttf-font-awesome"
    "papirus-icon-theme"
    "arc-gtk-theme"
    "materia-gtk-theme"
)

# Browsers & Communication
BROWSERS_COMM=(
    "brave-bin"
    "firefox"
    "discord"
    "telegram-desktop"
    "thunderbird"
    "zoom"
)

# AUR Packages
AUR_PACKAGES=(
    "eww"
    "nwg-displays"
    "nwg-drawer"
    "nwg-dock"
    "plymouth"
    "plymouth-theme-arch-charge"
    "sddm-sugar-candy-git"
    "steamtinkerlaunch"
    "vortex-mod-manager"
    "mod-organizer-2"
    "hyprshot"
    "waybar-hyprland"
    "rofi-bluetooth-git"
    "wlogout"
    "swaylock-effects"
    "hyprland-autoname-workspaces"
)

# Install packages by category
echo -e "${BLUE}Starting package installation...${NC}"

install_packages "Hyprland Core" "${HYPRLAND_CORE[@]}"
install_packages "Window Manager & Desktop" "${WM_DE[@]}"
install_packages "Audio & Video" "${AUDIO_VIDEO[@]}"
install_packages "File Management & System" "${FILE_SYSTEM[@]}"
install_packages "Terminal & Shell" "${TERMINAL_SHELL[@]}"
install_packages "Development Tools" "${DEVELOPMENT[@]}"
install_packages "Gaming & Multimedia" "${GAMING[@]}"
install_packages "Photography & Creative" "${CREATIVE[@]}"
install_packages "System & Hardware" "${SYSTEM_HARDWARE[@]}"
install_packages "Fonts & Themes" "${FONTS_THEMES[@]}"
install_packages "Browsers & Communication" "${BROWSERS_COMM[@]}"

install_aur_packages "AUR Packages" "${AUR_PACKAGES[@]}"

# Enable services
echo -e "${VIOLET}Enabling services...${NC}"
sudo systemctl enable bluetooth
sudo systemctl enable NetworkManager
sudo systemctl enable cups
sudo systemctl enable sddm
sudo systemctl enable ufw

# Configure UFW firewall
echo -e "${VIOLET}Configuring UFW firewall...${NC}"
sudo ufw --force enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Setup AMD graphics optimizations
echo -e "${VIOLET}Setting up AMD graphics optimizations...${NC}"
echo 'RADV_PERFTEST=aco' | sudo tee -a /etc/environment
echo 'AMD_VULKAN_ICD=RADV' | sudo tee -a /etc/environment
echo 'RADV_DEBUG=zerovram' | sudo tee -a /etc/environment

# Gaming optimizations
echo -e "${VIOLET}Applying gaming optimizations...${NC}"
echo 'vm.max_map_count=2147483642' | sudo tee /etc/sysctl.d/80-gamecompatibility.conf

# Create ZRAM configuration
echo -e "${VIOLET}Setting up ZRAM...${NC}"
echo 'zram' | sudo tee /etc/modules-load.d/zram.conf
echo 'options zram num_devices=1' | sudo tee /etc/modprobe.d/zram.conf

# Configure shell
echo -e "${VIOLET}Setting up ZSH shell...${NC}"
chsh -s $(which zsh)

# Create directories
echo -e "${VIOLET}Creating directories...${NC}"
mkdir -p ~/.config/{hypr,waybar,eww,rofi,kitty,dunst,swww}
mkdir -p ~/.local/share/{applications,themes,icons}
mkdir -p ~/Pictures/Wallpapers
mkdir -p ~/Scripts
mkdir -p ~/Gaming
mkdir -p ~/Photography
mkdir -p ~/Streaming

# Mount gaming drive
echo -e "${VIOLET}Setting up gaming drive mount...${NC}"
sudo mkdir -p /run/media/wehttamsnaps/LINUXDRIVE-1
echo "UUID=$(lsblk -no UUID /dev/disk/by-label/LINUXDRIVE-1) /run/media/wehttamsnaps/LINUXDRIVE-1 auto defaults,user,uid=1000,gid=1000 0 0" | sudo tee -a /etc/fstab

# Install Flatpaks
echo -e "${VIOLET}Setting up Flatpaks...${NC}"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

FLATPAKS=(
    "com.spotify.Client"
    "com.github.tchx84.Flatseal" 
    "org.videolan.VLC"
    "com.obsproject.Studio"
    "org.gimp.GIMP"
    "org.kde.krita"
    "org.inkscape.Inkscape"
    "org.blender.Blender"
)

for app in "${FLATPAKS[@]}"; do
    flatpak install -y flathub "$app" || echo -e "${YELLOW}Failed to install $app${NC}"
done

sleep 1
clear
# ----------------------------------------------------------
# Apply oh-my-zsh and plugins
# ----------------------------------------------------------

info_message "Installing Oh My Zsh and plugins..."

sleep 1

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Applying plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

success_message "Oh My Zsh and plugins installed successfully."

sleep 1
clear


# ----------------------------------------------------------
# Download and apply plymouth boot animation
# ----------------------------------------------------------

info_message "Downloading and applying Plymouth boot animation..."

sleep 1

git clone https://github.com/MrE8065/PSLinux.git ~/PSLinux
sudo cp -r ~/PSLinux/pslinux /usr/share/plymouth/themes
sudo plymouth-set-default-theme -R pslinux

success_message "Plymouth boot animation downloaded successfully."

sleep 2
clear

info_message "Do you want to add the plymouth entry to the mkinitcpio file? If you select no, REMEMBER TO ADD IT TO SHOW THE CUSTOM BOOT ANIMATION (y/n, default:y): "
read mkinit_choice
mkinit_choice=${mkinit_choice:-y}

if [[ "$mkinit_choice" == "y" ]]; then
  info_message "Creating a backup of mkinitcpio.conf."
  sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio_backup.conf
  info_message "REMEMBER TO DELETE IT IF THE INSTALLATION IS SUCCESSFUL"
  sleep 2

  # Script to autodetect if the user is using systemd or udev and add plymouth entry accordingly
  HOOKS_LINE=$(grep "^HOOKS=" /etc/mkinitcpio.conf)

  if [[ "$HOOKS_LINE" == *"udev"* ]]; then
    info_message "udev detected"
    NEW_LINE=$(echo "$HOOKS_LINE" | sed -E 's/(udev)/\1 plymouth/')
  elif [[ "$HOOKS_LINE" == *"systemd"* ]]; then
    info_message "systemd detected"
    NEW_LINE=$(echo "$HOOKS_LINE" | sed -E 's/(systemd)/\1 plymouth/')
  else
    info_message "No udev or systemd found in HOOKS. Aborting."
    exit 1
  fi

  # Replace HOOKS line with the modified one
  sudo sed -i "s|^HOOKS=.*|$NEW_LINE|" /etc/mkinitcpio.conf

  info_message "HOOKS line updated."
  grep "^HOOKS=" /etc/mkinitcpio.conf

  # Regenerate initramfs
  info_message "Regenerating initramfs images..."
  sudo mkinitcpio -P
  success_message "Plymouth entry successfully added to the mkinitcpio.conf file."
  info_message "Remember to add splash to your kernel parameters to see the boot animation."
  info_message "See the archwiki entry for Plymouth for more information."
  sleep 2
else
  info_message "Skipping mkinitcpio modification." 
  info_message "REMEMBER TO ADD PLYMOUTH ENTRY MANUALLY TO SHOW THE CUSTOM BOOT ANIMATION."
  info_message "ALSO ADD SPLASH TO THE KERNEL PARAMETERS TO SEE THE ANIMATION."
  info_message "See the archwiki entry for Plymouth for more information."
  sleep 2
fi

sleep 2
clear


# ----------------------------------------------------------
# Download and apply sddm theme
# ----------------------------------------------------------

info_message "Do you want to install and apply the sddm theme? (y/n, default:y): "
read sddm_choice
sddm_choice=${sddm_choice:-y} # Default to 'y' if empty

if [[ "$sddm_choice" == "y" ]]; then
  info_message "Downloading SDDM theme..."

  sleep 1

	installPackages "sddm-silent-theme"

  sleep 1

  success_message "SDDM theme downloaded successfully."

  sleep 1

  info_message "Applying SDDM theme..."

  sleep 1

  sudo tee /etc/sddm.conf > /dev/null << 'EOF'
[Theme]
Current=silent

[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard
EOF

  success_message "SDDM theme applied successfully."
fi

sleep 1
clear

# Directories ----------------------------
hypr_dir="$HOME/.hyprconf/hypr"
scripts_dir="$hypr_dir/scripts"
fonts_dir="$HOME/.local/share/fonts"

msg act "Now setting up the pre installed Hyprland configuration..." && sleep 1

mkdir -p ~/.config
dirs=(
    btop
    dunst
    fastfetch
    fish
    gtk-3.0
    gtk-4.0
    hypr
    kitty
    Kvantum
    menus
    nvim
    nwg-look
    qt5ct
    qt6ct
    rofi
    swaync
    waybar
    wlogout
    xfce4
    xsettingsd
    yazi
    dolphinrc
    kwalletmanagerrc
    kwalletrc
)

# Paths
backup_dir="$HOME/.temp-back"
wallpapers_backup="$backup_dir/Wallpaper"
hypr_cache_backup="$backup_dir/.cache"
hypr_config_backup="$backup_dir/configs.conf"
wallpapers="$HOME/.hyprconf/hypr/Wallpaper"
hypr_cache="$HOME/.hyprconf/hypr/.cache"
hypr_config="$HOME/.hyprconf/hypr/configs/configs.conf"

# Ensure backup directory exists
mkdir -p "$backup_dir"

# Function to handle backup/restore
backup_or_restore() {
    local file_path="$1"
    local file_type="$2"

    if [[ -e "$file_path" ]]; then
        echo
        msg att "A $file_type has been found."
        if command -v gum &> /dev/null; then
            gum confirm "Would you Restore it or put it into the Backup?" \
                --affirmative "Restore it.." \
                --negative "Backup it..."
            echo

            if [[ $? -eq 0 ]]; then
                action="r"
            else
                action="b"
            fi

        else
            msg ask "Would you like to Restore it or put it into the Backup? [ r/b ]"
            read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" action
        fi

        if [[ "$action" =~ ^[Rr]$ ]]; then
            cp -r "$file_path" "$backup_dir/"
        else
            msg att "$file_type will be backed up..."
        fi
    fi
}

# Backing wallpapers
backup_or_restore "$wallpapers" "wallpaper directory"
backup_or_restore "$hypr_config" "hyprland config file"

[[ -e "$hypr_cache" ]] && cp -r "$hypr_cache" "$backup_dir/"

# if some main directories exists, backing them up.
if [[ -d "$HOME/.backup_hyprconf-${USER}" ]]; then
    msg att "a .backup_hyprconf-${USER} directory was there. Archiving it..."
    cd
    mkdir -p ".archive_hyprconf-${USER}"
    tar -czf ".archive_hyprconf-${USER}/backup_hyprconf-$(date +%d-%m-%Y_%I-%M-%p)-${USER}.tar.gz" ".backup_hyprconf-${USER}" &> /dev/null
    # mv "HyprBackup-${USER}.zip" "HyprArchive-${USER}/"
    rm -rf ".backup_hyprconf-${USER}"
    msg dn "~/.backup_hyprconf-${USER} was archived inside ~/.archive_hyprconf-${USER} directory..." && sleep 1
fi


mkdir -p "$HOME/.backup_hyprconf-${USER}"
if [[ -d "$HOME/.hyprconf" ]]; then

    mv "$HOME/.hyprconf" "$HOME/.backup_hyprconf-${USER}/"

else

    for confs in "${dirs[@]}"; do
        conf_path="$HOME/.config/$confs"

        # If the config exists and is NOT a symlink → backup it
        if [[ -e "$conf_path" && ! -L "$conf_path" ]]; then
            mv "$conf_path" "$HOME/.backup_hyprconf-${USER}/" 2>&1 | tee -a "$log"
        fi
    done
    
    msg dn "Backed up $confs config to ~/.backup_hyprconf-${USER}/"
fi

[[ -d "$HOME/.backup_hyprconf-${USER}/hypr" ]] && msg dn "Everything has been backuped in $HOME/.backup_hyprconf-${USER}..."

sleep 1

####################################################################

#_____ if OpenBangla Keyboard is installed
keyboard_path="/usr/share/openbangla-keyboard"

if [[ -d "$keyboard_path" ]]; then
    msg act "Setting up things for OpenBangla-Keyboard..."

    # Add fcitx5 environment variables to /etc/environment if not already present
    if ! grep -q "GTK_IM_MODULE=fcitx" /etc/environment; then
        printf "\nGTK_IM_MODULE=fcitx\n" | sudo tee -a /etc/environment 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") &> /dev/null
    fi

    if ! grep -q "QT_IM_MODULE=fcitx" /etc/environment; then
        printf "QT_IM_MODULE=fcitx\n" | sudo tee -a /etc/environment 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") &> /dev/null
    fi

    if ! grep -q "XMODIFIERS=@im=fcitx" /etc/environment; then
        printf "XMODIFIERS=@im=fcitx\n" | sudo tee -a /etc/environment 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") &> /dev/null
    fi

fi

####################################################################

#_____ for virtual machine
# Check if the configuration is in a virtual box
if hostnamectl | grep -q 'Chassis: vm'; then
    msg att "You are using this script in a Virtual Machine..."
    msg act "Setting up things for you..." 
    sed -i '/env = WLR_NO_HARDWARE_CURSORS,1/s/^#//' "$dir/config/hypr/configs/environment.conf"
    sed -i '/env = WLR_RENDERER_ALLOW_SOFTWARE,1/s/^#//' "$dir/config/hypr/configs/environment.conf"
    echo -e '#Monitor\nmonitor=Virtual-1, 1920x1080@60,auto,1' > "$dir/config/hypr/configs/monitor.conf"
fi


#_____ for nvidia gpu. I don't know if it's gonna work or not. Because I don't have any gpu.
# uncommenting WLR_NO_HARDWARE_CURSORS if nvidia is detected
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
  msg act "Nvidia GPU detected. Setting up proper env's" 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") || true
  sed -i '/env = WLR_NO_HARDWARE_CURSORS,1/s/^#//' config/hypr/configs/environment.conf
  sed -i '/env = LIBVA_DRIVER_NAME,nvidia/s/^#//' config/hypr/configs/environment.conf
  sed -i '/env = __GLX_VENDOR_LIBRARY_NAME,nvidia/s/^# //' config/hypr/configs/environment.conf
fi

sleep 1


# creating symlinks
cp -a "$dir/config" "$HOME/.hyprconf"
mv "$HOME/.hyprconf/fastfetch" "$HOME/.local/share/"

for dotfilesDir in "$HOME/.hyprconf"/*; do
    configDirName=$(basename "$dotfilesDir")
    configDirPath="$HOME/.config/$configDirName"

    ln -sfn "$dotfilesDir" "$configDirPath"
done

sleep 1

if [[ -d "$scripts_dir" ]]; then
    # make all the scripts executable...
    chmod +x "$scripts_dir"/* 2>&1 | tee -a "$log"
    chmod +x "$HOME/.hyprconf/fish/functions"/* 2>&1 | tee -a "$log"
    msg dn "All the necessary scripts have been executable..."
    sleep 1
else
    msg err "Could not find necessary scripts.."
fi

# Install Fonts
msg act "Installing some fonts..."
if [[ ! -d "$fonts_dir" ]]; then
	mkdir -p "$fonts_dir"
fi

cp -r "$dir/extras/fonts" "$fonts_dir"
msg act "Updating font cache..."
sudo fc-cache -fv 2>&1 | tee -a "$log" &> /dev/null

### Setup extra files and dirs

# dolphinstaterc
if [[ -f "$HOME/.local/state/dolphinstaterc" ]]; then
    mv "$HOME/.local/state/dolphinstaterc" "$HOME/.local/state/dolphinstaterc.back"
fi

# konsole
if [[ -d "$HOME/.local/share/konsole" ]]; then
    mv "$HOME/.local/share/konsole" "$HOME/.local/share/konsole.back"
fi

cp -r "$dir/local/state/dolphinstaterc" "$HOME/.local/state/"
cp -r "$dir/local/share/konsole" "$HOME/.local/share/"


# wayland session dir
wayland_session_dir=/usr/share/wayland-sessions
if [ -d "$wayland_session_dir" ]; then
    msg att "$wayland_session_dir found..."
else
    msg att "$wayland_session_dir NOT found, creating..."
    sudo mkdir $wayland_session_dir 2>&1 | tee -a "$log"
fi
    sudo cp "$dir/extras/hyprland.desktop" /usr/share/wayland-sessions/ 2>&1 | tee -a "$log"


# restore the backuped items into the original location
restore_backup() {
    local backup_path="$1"      # Path to the backup file/directory
    local original_path="$2"    # Original file/directory path
    local file_type="$3"        # Description of the file/directory

    if [[ -e "$backup_path" ]]; then
        # Create a backup of the current file/directory if it exists
        if [[ -e "$original_path" ]]; then
            mv "$original_path" "${original_path}.backup"
        fi

        # Restore the file/directory from the backup
        if cp -r "$backup_path" "$original_path"; then
            msg dn "$file_type restored to its original location: $original_path."
        else
            msg err "Could not restore defaults."
        fi

        if [[ -e "${original_path}.backup" ]]; then
            rm -rf "${original_path}.backup"
        fi
    fi
}

# Restore files
restore_backup "$wallpapers_backup" "$wallpapers" "wallpaper directory"
restore_backup "$hypr_config_backup" "$hypr_config" "hyprland config file"

# restoring hyprland cache
[[ -e "$HOME/.hyprconf/hypr/.cache" ]] && rm -rf "$HOME/.hyprconf/hypr/.cache"
[[ -e "$hypr_cache_backup" ]] && cp -r "$hypr_cache_backup" "$hypr_cache"
rm -rf "$backup_dir"

clear && sleep 1

# Asking if the user wants to download more wallpapers
msg ask "Would you like to add more ${green}Wallpapers${end}? ${blue}[ y/n ]${end}..."
read -r -p "$(echo -e '\e[1;32mSelect: \e[0m')" wallpaper

printf " \n"

# =========  wallpaper section  ========= #

if [[ "$wallpaper" =~ ^[Y|y]$ ]]; then
    url="https://github.com/shell-ninja/Wallpapers/archive/refs/heads/main.zip"

    target_dir="$HOME/.cache/wallpaper-cache"
    zip_path="$target_dir.zip"
    msg act "Downloading some wallpapers..."
    
    # Download the ZIP silently with a progress bar
    curl -L "$url" -o "$zip_path"

    if [[ -f "$zip_path" ]]; then
        mkdir -p "$target_dir"
        unzip "$zip_path" "wallpaper-cache-main/*" -d "$target_dir" > /dev/null
        mv "$target_dir/wallpaper-cache-main/"* "$target_dir" && rmdir "$target_dir/wallpaper-cache-main"
        rm "$zip_path"
    fi

    # copying the wallpaper to the main directory
    if [[ -d "$HOME/.cache/wallpaper-cache" ]]; then
        cp -r "$HOME/.cache/wallpaper-cache"/* ~/.hyprconf/hypr/Wallpaper/ &> /dev/null
        rm -rf "$HOME/.cache/wallpaper-cache" &> /dev/null
        msg dn "Wallpapers were downloaded successfully..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") & sleep 0.5
    else
        msg err "Sorry, could not download more wallpapers. Going forward with the limited wallpapers..." 2>&1 | tee -a >(sed 's/\x1B\[[0-9;]*[JKmsu]//g' >> "$log") && sleep 0.5
    fi
fi

# =========  wallpaper section  ========= #

if [[ -d "$HOME/.hyprconf/hypr/Wallpaper" ]]; then

    if [[ -d "$HOME/.hyprconf/hypr/.cache" ]]; then
        wallName=$(cat "$HOME/.hyprconf/hypr/.cache/.wallpaper")
        wallpaper=$(find "$HOME/.hyprconf/hypr/Wallpaper" -type f -name "$wallName.*" | head -n 1)
    else
        mkdir -p "$HOME/.hyprconf/hypr/.cache"
        wallCache="$HOME/.hyprconf/hypr/.cache/.wallpaper"

        touch "$wallCache"      

        if [ -f "$HOME/.hyprconf/hypr/Wallpaper/linux.jpg" ]; then
            echo "linux" > "$wallCache"
            wallpaper="$HOME/.hyprconf/hypr/Wallpaper/linux.jpg"
        fi
    fi

    # setting the default wallpaper
    ln -sf "$wallpaper" "$HOME/.hyprconf/hypr/.cache/current_wallpaper.png"
fi

# setting up the waybar
ln -sf "$HOME/.hyprconf/waybar/configs/full-top" "$HOME/.hyprconf/waybar/config"
ln -sf "$HOME/.hyprconf/waybar/style/full-top.css" "$HOME/.hyprconf/waybar/style.css"

# setting up hyprlock theme
ln -sf "$HOME/.hyprconf/hypr/lockscreens/hyprlock-1.conf" "$HOME/.hyprconf/hypr/hyprlock.conf"

msg act "Generating colors and other necessary things..."
"$HOME/.hyprconf/hypr/scripts/wallcache.sh" &> /dev/null
"$HOME/.hyprconf/hypr/scripts/pywal.sh" &> /dev/null


# setting default themes, icon and cursor
gsettings set org.gnome.desktop.interface gtk-theme 'TokyoNight'
gsettings set org.gnome.desktop.interface icon-theme 'TokyoNight'
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'

crudini --set ~/.config/Kvantum/kvantum.kvconfig General theme "Dracula"
crudini --set ~/.config/kdeglobals Icons Theme "TokyoNight"


msg dn "Script execution was successful! Now logout and log back in and enjoy your customization..." && sleep 1

# === ___ Script Ends Here ___ === #
