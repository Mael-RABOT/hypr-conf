#!/bin/bash

# fum-media.sh - Waybar module script for fum-based media control
# This script provides commands to control media players through fum

FUM_PATH="/usr/bin/fum"
FUM_CONFIG="$HOME/.config/fum/config.jsonc"

# Function to check if fum is available
check_fum() {
    if [[ ! -x "$FUM_PATH" ]]; then
        echo "fum not found at $FUM_PATH" >&2
        return 1
    fi
    return 0
}

# Function to execute fum commands in the background
execute_fum_command() {
    local command="$1"
    if check_fum; then
        # Send command to fum running in the background
        echo "$command" | "$FUM_PATH" --config "$FUM_CONFIG" >/dev/null 2>&1 &
    fi
}

# Function to get current media status
get_media_status() {
    if command -v playerctl >/dev/null 2>&1; then
        if playerctl status >/dev/null 2>&1; then
            local status=$(playerctl status 2>/dev/null)
            case "$status" in
                Playing) echo "playing" ;;
                Paused) echo "paused" ;;
                Stopped) echo "stopped" ;;
                *) echo "unknown" ;;
            esac
        else
            echo "no_player"
        fi
    else
        echo "no_playerctl"
    fi
}

# Function to get current media title
get_media_title() {
    if command -v playerctl >/dev/null 2>&1; then
        local title=$(playerctl metadata --format '{{title}}' 2>/dev/null)
        local artist=$(playerctl metadata --format '{{artist}}' 2>/dev/null)

        if [[ -n "$title" && -n "$artist" ]]; then
            echo "$artist - $title"
        elif [[ -n "$title" ]]; then
            echo "$title"
        else
            echo "No Media"
        fi
    else
        echo "No Media"
    fi
}

# Function to open fum in a terminal for full control
open_fum_interface() {
    if command -v kitty >/dev/null 2>&1; then
        kitty -e "$FUM_PATH" --config "$FUM_CONFIG" &
    elif command -v alacritty >/dev/null 2>&1; then
        alacritty -e "$FUM_PATH" --config "$FUM_CONFIG" &
    else
        # Fallback to xterm
        xterm -e "$FUM_PATH" --config "$FUM_CONFIG" &
    fi
}

# Main command handler
case "$1" in
    "prev"|"previous")
        execute_fum_command "h"  # Based on fum config: "h": "prev()"
        ;;
    "next")
        execute_fum_command "l"  # Based on fum config: "l": "next()"
        ;;
    "play-pause"|"toggle")
        execute_fum_command " "  # Based on fum config: " ": "play_pause()"
        ;;
    "status")
        get_media_status
        ;;
    "title")
        get_media_title
        ;;
    "interface"|"open")
        open_fum_interface
        ;;
    "help"|"--help")
        echo "Usage: $0 {prev|next|play-pause|status|title|icon|interface|help}"
        echo ""
        echo "Commands:"
        echo "  prev        - Previous track"
        echo "  next        - Next track"
        echo "  play-pause  - Toggle play/pause"
        echo "  status      - Get current status"
        echo "  title       - Get current track title"
        echo "  interface   - Open fum interface"
        echo "  help        - Show this help"
        ;;
    *)
        echo "Usage: $0 {prev|next|play-pause|status|title|icon|interface|help}"
        exit 1
        ;;
esac