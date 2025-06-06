#!/bin/bash

# ========================================
# HYPRLAND SETUP INSTALLATION SCRIPT
# ========================================
# ASCII Art Style Installation Script
# Based on waybar modules.jsonc theme

BRACKET_OPEN="["
BRACKET_CLOSE="]"

echo "$BRACKET_OPEN HYPRLAND SETUP INSTALLER $BRACKET_CLOSE"
echo ""

# ========================================
# CORE HYPRLAND PACKAGES
# ========================================
HYPRLAND_CORE=(
    "hyprland"              # Wayland compositor
    "hyprpaper"             # Wallpaper daemon
    "hyprconf"              # Configuration tool
    "xdg-desktop-portal-hyprland"  # Desktop portal for Hyprland
)

# ========================================
# WAYBAR & UI COMPONENTS
# ========================================
WAYBAR_COMPONENTS=(
    "waybar"                # Status bar
    "rofi"                  # Application launcher
    "wlogout"               # Logout manager
    "dunst"                 # Notification daemon
    "wlsunset"              # Blue light filter
    "brightnessctl"         # Brightness control
)

# ========================================
# TERMINAL & FILE MANAGEMENT
# ========================================
TERMINAL_TOOLS=(
    "kitty"                 # Terminal emulator
    "alacritty"             # Terminal emulator (alternative)
    "superfile"             # TUI file manager
    "visidata"              # Data analysis tool
)

# ========================================
# SYSTEM MONITORING & AUDIO
# ========================================
SYSTEM_TOOLS=(
    "pavucontrol"           # Audio control GUI
    "playerctl"             # Media control
    "bottom"                # System monitor (btm command)
    "htop"                  # Process monitor
    "psutil"                # Python system utilities (for VisiData theme)
    "pulseaudio"            # Audio system (provides pactl)
    "wireplumber"           # Audio session manager (provides wpctl)
    "wl-clipboard"          # Wayland clipboard utilities (wl-copy)
    "numlockx"              # Numlock control
)

# ========================================
# NETWORK & UTILITIES
# ========================================
NETWORK_UTILS=(
    "networkmanager"        # Network management
    "network-manager-applet" # Network GUI
    "bluez"                 # Bluetooth
    "bluez-utils"           # Bluetooth utilities
)

# ========================================
# FONTS & THEMES
# ========================================
FONTS_THEMES=(
    "ttf-font-awesome"      # Icons for waybar
    "ttf-nerd-fonts-symbols" # Nerd font symbols
    "noto-fonts-emoji"      # Emoji support
)

# ========================================
# PYTHON PACKAGES (for VisiData theme)
# ========================================
PYTHON_PACKAGES=(
    "python-psutil"         # System monitoring for VisiData
)

# ========================================
# OPTIONAL APPLICATIONS (from your config)
# ========================================
OPTIONAL_APPS=(
    "discord"               # Communication
    "librewolf"             # Web browser
    "neovim"                # IDE
    "docker"                # Containerization
    "vlc"                   # Media player
    "thunar"                # File manager GUI
    "grim"                  # Screenshot tool
    "slurp"                 # Screenshot tool
    "gobang"                # Database explorer (Super+D binding)
    "youtube-music"         # Media player (Super+M binding)
)

# ========================================
# INSTALLATION FUNCTIONS
# ========================================

detect_package_manager() {
    if command -v pacman &> /dev/null; then
        echo "arch"
    elif command -v apt &> /dev/null; then
        echo "debian"
    elif command -v dnf &> /dev/null; then
        echo "fedora"
    elif command -v zypper &> /dev/null; then
        echo "opensuse"
    else
        echo "unknown"
    fi
}

install_arch_packages() {
    local packages=("$@")
    echo "$BRACKET_OPEN ARCH LINUX $BRACKET_CLOSE Installing packages..."

    # Update system
    sudo pacman -Syu --noconfirm

    # Install packages
    for package in "${packages[@]}"; do
        echo "Installing: $package"
        sudo pacman -S --noconfirm "$package" || echo "Failed to install: $package"
    done

    # Install AUR packages if yay is available
    if command -v yay &> /dev/null; then
        echo "$BRACKET_OPEN AUR $BRACKET_CLOSE Installing AUR packages..."
        yay -S --noconfirm superfile-bin hyprconf || echo "Some AUR packages failed"
    else
        echo "$BRACKET_OPEN WARNING $BRACKET_CLOSE yay not found. Install manually: superfile, hyprconf"
    fi
}

install_debian_packages() {
    local packages=("$@")
    echo "$BRACKET_OPEN DEBIAN/UBUNTU $BRACKET_CLOSE Installing packages..."

    # Update system
    sudo apt update && sudo apt upgrade -y

    # Install packages
    for package in "${packages[@]}"; do
        echo "Installing: $package"
        sudo apt install -y "$package" || echo "Failed to install: $package"
    done

    echo "$BRACKET_OPEN NOTE $BRACKET_CLOSE Some packages may need manual installation on Debian/Ubuntu"
}

install_fedora_packages() {
    local packages=("$@")
    echo "$BRACKET_OPEN FEDORA $BRACKET_CLOSE Installing packages..."

    # Update system
    sudo dnf update -y

    # Install packages
    for package in "${packages[@]}"; do
        echo "Installing: $package"
        sudo dnf install -y "$package" || echo "Failed to install: $package"
    done
}

# ========================================
# MAIN INSTALLATION LOGIC
# ========================================

main() {
    echo "$BRACKET_OPEN DETECTING SYSTEM $BRACKET_CLOSE"
    local pkg_manager=$(detect_package_manager)
    echo "Detected package manager: $pkg_manager"
    echo ""

    # Combine all package arrays
    local all_packages=(
        "${HYPRLAND_CORE[@]}"
        "${WAYBAR_COMPONENTS[@]}"
        "${TERMINAL_TOOLS[@]}"
        "${SYSTEM_TOOLS[@]}"
        "${NETWORK_UTILS[@]}"
        "${FONTS_THEMES[@]}"
        "${PYTHON_PACKAGES[@]}"
    )

    echo "$BRACKET_OPEN PACKAGE LIST $BRACKET_CLOSE"
    echo "Core Hyprland packages:"
    printf '  - %s\n' "${HYPRLAND_CORE[@]}"
    echo ""
    echo "Waybar & UI components:"
    printf '  - %s\n' "${WAYBAR_COMPONENTS[@]}"
    echo ""
    echo "Terminal & file tools:"
    printf '  - %s\n' "${TERMINAL_TOOLS[@]}"
    echo ""
    echo "System monitoring:"
    printf '  - %s\n' "${SYSTEM_TOOLS[@]}"
    echo ""
    echo "Network utilities:"
    printf '  - %s\n' "${NETWORK_UTILS[@]}"
    echo ""
    echo "Fonts & themes:"
    printf '  - %s\n' "${FONTS_THEMES[@]}"
    echo ""
    echo "Optional applications:"
    printf '  - %s\n' "${OPTIONAL_APPS[@]}"
    echo ""

    read -p "$BRACKET_OPEN CONFIRM $BRACKET_CLOSE Install core packages? (y/N): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        case $pkg_manager in
            "arch")
                install_arch_packages "${all_packages[@]}"
                ;;
            "debian")
                install_debian_packages "${all_packages[@]}"
                ;;
            "fedora")
                install_fedora_packages "${all_packages[@]}"
                ;;
            *)
                echo "$BRACKET_OPEN ERROR $BRACKET_CLOSE Unsupported package manager: $pkg_manager"
                echo "Please install packages manually or add support for your distribution."
                exit 1
                ;;
        esac
    fi

    read -p "$BRACKET_OPEN OPTIONAL $BRACKET_CLOSE Install optional applications? (y/N): " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        case $pkg_manager in
            "arch")
                install_arch_packages "${OPTIONAL_APPS[@]}"
                ;;
            "debian")
                install_debian_packages "${OPTIONAL_APPS[@]}"
                ;;
            "fedora")
                install_fedora_packages "${OPTIONAL_APPS[@]}"
                ;;
        esac
    fi

    echo ""
    echo "$BRACKET_OPEN INSTALLATION COMPLETE $BRACKET_CLOSE"
    echo ""
    echo "Next steps:"
    echo "1. Copy your Hyprland config files to ~/.config/"
    echo "2. Copy waybar configs to ~/.config/waybar/"
    echo "3. Set up your VisiData theme: ~/.visidatarc"
    echo "4. Configure rofi, dunst, and other applications"
    echo "5. Set Hyprland as your session in your display manager"
    echo ""
    echo "$BRACKET_OPEN ENJOY YOUR SETUP $BRACKET_CLOSE"
}

# ========================================
# MANUAL INSTALLATION COMMANDS
# ========================================

show_manual_commands() {
    echo "$BRACKET_OPEN MANUAL INSTALLATION COMMANDS $BRACKET_CLOSE"
    echo ""

    # Combine all core package arrays
    local core_packages=(
        "${HYPRLAND_CORE[@]}"
        "${WAYBAR_COMPONENTS[@]}"
        "${TERMINAL_TOOLS[@]}"
        "${SYSTEM_TOOLS[@]}"
        "${NETWORK_UTILS[@]}"
        "${FONTS_THEMES[@]}"
        "${PYTHON_PACKAGES[@]}"
    )

    # AUR packages (Arch-specific)
    local aur_packages=("superfile-bin" "hyprconf")

    # Add optional AUR packages
    local optional_aur=()
    for pkg in "${OPTIONAL_APPS[@]}"; do
        case "$pkg" in
            "gobang"|"youtube-music")
                optional_aur+=("$pkg")
                ;;
        esac
    done

    echo "# Arch Linux:"
    echo "sudo pacman -S ${core_packages[*]}"
    if [ ${#aur_packages[@]} -gt 0 ] || [ ${#optional_aur[@]} -gt 0 ]; then
        echo "yay -S ${aur_packages[*]} ${optional_aur[*]}"
    fi
    echo ""

    echo "# Debian/Ubuntu:"
    echo "sudo apt install ${core_packages[*]}"
    echo "# Note: Some packages may need manual installation or have different names"
    echo ""

    echo "# Fedora:"
    echo "sudo dnf install ${core_packages[*]}"
    echo "# Note: Some packages may need manual installation or have different names"
    echo ""

    echo "# Optional applications:"
    echo "# ${OPTIONAL_APPS[*]}"
    echo ""
}

# ========================================
# SCRIPT EXECUTION
# ========================================

case "${1:-install}" in
    "install")
        main
        ;;
    "list")
        show_manual_commands
        ;;
    "help")
        echo "Usage: $0 {install|list|help}"
        echo ""
        echo "Commands:"
        echo "  install  - Interactive installation (default)"
        echo "  list     - Show manual installation commands"
        echo "  help     - Show this help message"
        ;;
    *)
        echo "$BRACKET_OPEN ERROR $BRACKET_CLOSE Unknown command: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac