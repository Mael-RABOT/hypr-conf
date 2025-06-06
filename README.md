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

## 🛠️ Troubleshooting

If you encounter any issues:

1. ✔️ Make sure the ML4W Hyprland starter was installed successfully
2. 🔍 Verify that all required dependencies are installed
3. 📂 Check that the config files were copied to the correct location in `~/.config/`
4. 📚 Refer to the help output from `./install.sh help` for additional guidance

## 🙏 Credits

- **[@mylinuxforwork](https://github.com/mylinuxforwork)** (Stephan Raabe) - Creator of the amazing ML4W Hyprland starter
- **[@m-brl](https://github.com/m-brl)** (Mathieu) - Friend whose nvim config I shamelessly stole 😄

## 💬 Support

For additional help or questions about this configuration, please refer to the documentation or create an issue in this repository.

---

*Made with ❤️ using the awesome work from the Hyprland and ML4W communities*
