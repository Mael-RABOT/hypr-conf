#!/bin/bash

# Script to fix workspace assignments to correct monitors
echo "Fixing workspace assignments..."

# Kill all windows and reset workspaces (optional - comment out if you want to keep windows)
# hyprctl dispatch killactive

# Move to each workspace and ensure it's on the correct monitor
echo "Setting up Left Monitor (DP-3) workspaces 1, 2, 3..."
hyprctl dispatch focusmonitor DP-3
hyprctl dispatch workspace 1
sleep 0.5
hyprctl dispatch workspace 2
sleep 0.5
hyprctl dispatch workspace 3
sleep 0.5

echo "Setting up Center Monitor (DP-2) workspaces 4, 5, 6..."
hyprctl dispatch focusmonitor DP-2
hyprctl dispatch workspace 4
sleep 0.5
hyprctl dispatch workspace 5
sleep 0.5
hyprctl dispatch workspace 6
sleep 0.5

echo "Setting up Right Monitor (eDP-1) workspaces 7, 8, 9..."
hyprctl dispatch focusmonitor eDP-1
hyprctl dispatch workspace 7
sleep 0.5
hyprctl dispatch workspace 8
sleep 0.5
hyprctl dispatch workspace 9
sleep 0.5

# Return to center monitor workspace 4
hyprctl dispatch focusmonitor DP-2
hyprctl dispatch workspace 4

echo "Workspace assignments fixed!"
echo "Restarting waybar..."
~/.config/waybar/launch-waybar.sh

echo "Done! Workspaces should now be properly assigned."