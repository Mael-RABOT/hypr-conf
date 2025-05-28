#!/bin/bash

# Kill any existing waybar instances
killall waybar 2>/dev/null

# Wait a moment for processes to terminate
sleep 1

# Check which monitors are connected
monitors=$(hyprctl monitors -j | jq -r '.[].name')
monitor_count=$(echo "$monitors" | wc -l)

echo "Detected $monitor_count monitor(s): $monitors"

# If only one monitor, use normal waybar config
if [ "$monitor_count" -eq 1 ]; then
    echo "Single monitor detected, launching normal waybar..."
    waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
    echo "Launched single waybar instance"
else
    echo "Multiple monitors detected, launching monitor-specific waybar instances..."

    # Check each monitor and launch appropriate config
    if echo "$monitors" | grep -q "DP-3"; then
        echo "Launching waybar for left monitor (DP-3)..."
        waybar -c ~/.config/waybar/monitors/config-left.jsonc -s ~/.config/waybar/style.css &
    fi

    if echo "$monitors" | grep -q "DP-2"; then
        echo "Launching waybar for center monitor (DP-2)..."
        waybar -c ~/.config/waybar/monitors/config-center.jsonc -s ~/.config/waybar/style.css &
    fi

    if echo "$monitors" | grep -q "eDP-1"; then
        echo "Launching waybar for right monitor (eDP-1)..."
        waybar -c ~/.config/waybar/monitors/config-right.jsonc -s ~/.config/waybar/style.css &
    fi

    echo "Launched waybar instances for all connected monitors"
fi
