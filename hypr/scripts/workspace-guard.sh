#!/bin/bash

# Workspace Guard - Prevents creation of workspaces beyond 1-9
# This script monitors workspace creation and removes unauthorized workspaces

ALLOWED_WORKSPACES=(1 2 3 4 5 6 7 8 9)

cleanup_unauthorized_workspaces() {
    # Get all current workspaces
    current_workspaces=$(hyprctl workspaces -j | jq -r '.[].id')

    for workspace in $current_workspaces; do
        # Skip special workspaces (negative numbers)
        if [[ $workspace -lt 0 ]]; then
            continue
        fi

        # Check if workspace is in allowed list
        if [[ ! " ${ALLOWED_WORKSPACES[@]} " =~ " ${workspace} " ]]; then
            echo "Unauthorized workspace $workspace detected, removing..."

            # Move any windows from unauthorized workspace to appropriate workspace
            windows=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == $workspace) | .address")

            for window in $windows; do
                # Determine target workspace based on current monitor
                monitor=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$window\") | .monitor")

                case $monitor in
                    "DP-3")   target_workspace=1 ;;  # Left monitor
                    "DP-2")   target_workspace=4 ;;  # Center monitor
                    "eDP-1")  target_workspace=7 ;;  # Right monitor
                    *)        target_workspace=4 ;;  # Default to center
                esac

                echo "Moving window from workspace $workspace to $target_workspace"
                hyprctl dispatch movetoworkspacesilent $target_workspace,address:$window
            done

            # Send notification about the cleanup
            notify-send "Workspace Guard" "Unauthorized workspace $workspace was removed. Only workspaces 1-9 are allowed."
        fi
    done
}

# Run cleanup once
cleanup_unauthorized_workspaces

# If run with --monitor flag, keep monitoring
if [[ "$1" == "--monitor" ]]; then
    echo "Workspace Guard: Monitoring for unauthorized workspaces..."
    while true; do
        sleep 2
        cleanup_unauthorized_workspaces
    done
fi