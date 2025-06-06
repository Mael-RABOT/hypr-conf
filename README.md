# 🚀 Config Setup Guide

This guide will walk you through setting up and using this configuration.

## 📋 Prerequisites

Before using this config, you need to install the basic ML4W Hyprland setup.

### 🔧 Step 1: Install ML4W Hyprland Starter

First, clone the hyprland-starter repository created by [@mylinuxforwork](https://github.com/mylinuxforwork):

```bash
git clone git@github.com:mylinuxforwork/hyprland-starter.git
```

Navigate to the cloned directory and run the setup script:

```bash
cd hyprland-starter
./setup.sh
```

This will install the basic ML4W Hyprland environment on your system.

## ⚙️ Installing This Configuration

### 📖 Step 2: Get Help and Information

After the basic installation, navigate to the `hypr` directory in this repository and run the install script with the help flag to see available options:

```bash
cd hypr
./install.sh help
```

This will show you what configuration options are available and how to use the installation script.

### 📁 Step 3: Copy Configuration Files

Once you've reviewed the available options, copy the desired config folder directly into your `.config` directory:

```bash
# Replace 'desired-config-folder' with the actual folder name you want to use
cp -r desired-config-folder ~/.config/
```

## 🎯 Usage

After completing these steps, your configuration should be active. You may need to:

1. 🔄 Log out and log back in
2. 🔃 Restart your Hyprland session
3. ✅ Check that all dependencies are properly installed

## 🔧 My Custom Configuration Details

<details>
<summary><strong>🛠️ Click to explore the included tools and configurations</strong></summary>

This configuration includes custom setups for various tools that work together to create a cohesive Hyprland desktop environment:

### 🖥️ **Core Hyprland Configuration**
- **`hypr/`** - Main Hyprland window manager configuration
  - Custom keybindings, window rules, and animations
  - Scripts for automation and window management
  - Hyprlock (screen locker) and Hyprpaper (wallpaper) configs

### 🎨 **Status Bar & UI**
- **`waybar/`** - Highly customized status bar
  - System monitoring modules (CPU, RAM, disk usage)
  - Custom scripts for dynamic information display
  - Responsive design for different monitor setups

### 🚀 **Application Launchers & Menus**
- **`rofi/`** - Stylized application launcher and menu system
  - Custom themes and color schemes
  - Enhanced search functionality
- **`wlogout/`** - Elegant logout/shutdown menu for Wayland

### 💻 **Terminal Emulators**
- **`alacritty/`** - GPU-accelerated terminal emulator
  - Optimized performance settings
  - Custom color schemes and fonts
- **`kitty/`** - Feature-rich terminal with advanced capabilities
  - Tab management and layout configurations
  - Custom key mappings

### ⌨️ **Text Editor**
- **`nvim/`** - Highly customized Neovim setup (stolen from [@m-brl](https://github.com/m-brl) 😄)
  - Extensive plugin configuration
  - Custom keybindings and workflow optimizations
  - Language server configurations

### 🔔 **Notifications & System Integration**
- **`dunst/`** - Lightweight notification daemon
  - Custom notification styling and behavior
  - Integration with system events

### 📁 **File Management**
- **`superfile/`** - Modern terminal file manager
  - Enhanced file navigation and management
  - Custom themes and shortcuts

### 🛠️ **Additional Tools**
- **`fum/`** - Fast file finder and management tool
- **`ml4w*/`** - ML4W specific configurations and themes
  - Integration with the ML4W ecosystem
  - Custom themes and styling

### 🎨 **Visual Enhancements**
All configurations are designed to work harmoniously together, featuring:
- 🌈 Consistent color schemes across all applications
- 🎯 Optimized keybindings that don't conflict
- 📱 Responsive layouts for different screen sizes
- ⚡ Performance-oriented configurations
- 🔧 Easy customization and extensibility

</details>

## 🎨 ASCII Art Direction

This configuration embraces a clean, minimalist ASCII art aesthetic throughout all config files. The design philosophy includes:

### ✨ **Design Elements**
- **Header Banners** - Each major config file features elegant ASCII art headers (like the "Hyprland" banner in `hypr/hyprland.conf`)
- **Consistent Commenting Style** - Structured comment blocks with ASCII separators for better organization
- **Visual Hierarchy** - ASCII art helps create clear sections and improves code readability
- **Brand Identity** - Custom ASCII logos and headers give the configuration a professional, cohesive look

### 🎯 **Philosophy**
The ASCII art serves both functional and aesthetic purposes:
- 📋 **Organization** - Makes config files easier to navigate and understand
- 🎨 **Personality** - Adds character and personal touch to otherwise dry configuration files
- 🔍 **Quick Identification** - Instantly recognizable headers help identify different config sections
- 💫 **Professional Touch** - Clean, well-structured ASCII art demonstrates attention to detail

*The ASCII art direction reflects a balance between functionality and visual appeal, making the configuration both beautiful and practical.*

## 🛠️ Troubleshooting

If you encounter any issues:

1. ✔️ Make sure the ML4W Hyprland starter was installed successfully
2. 🔍 Verify that all required dependencies are installed
3. 📂 Check that the config files were copied to the correct location in `~/.config/`
4. 📚 Refer to the help output from `./install.sh help` for additional guidance

## 🙏 Credits

- **[@mylinuxforwork](https://github.com/mylinuxforwork)** (Stephan Raabe) - Creator of the amazing ML4W Hyprland starter
- **[@m-brl](https://github.com/m-brl)** (Mathieu) - Friend whose nvim config I shamelessly stole 😄
- **[@charlesmadjeri](https://github.com/charlesmadjeri)** (Charles) - A "Friend" who "helped" me create the prompt for this readme

## 💬 Support

For additional help or questions about this configuration, please refer to the documentation or create an issue in this repository.

---

*Made with ❤️ using the awesome work from the Hyprland and ML4W communities*
