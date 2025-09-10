#!/bin/bash

# Waybar Nightlight Toggle Script
# Follows the ASCII art style from waybar modules.jsonc
# Icons and formatting match the [ ... ] bracket style

# ========================================
# ASCII ART ELEMENTS (matching waybar)
# ========================================
BRACKET_OPEN="["
BRACKET_CLOSE="]"

# Night/Day Icons (Font Awesome Unicode)
ICON_DAY=""    # Sun icon
ICON_NIGHT=""  # Moon icon
ICON_TOGGLE="" # Adjust icon

# ========================================
# WLSUNSET CONFIGURATION
# ========================================
# Load settings from .env file if it exists
ENV_FILE="$HOME/.config/waybar/scripts/.env"
if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
fi

# Default values (fallback if .env doesn't exist)
WLSUNSET_TEMP_NIGHT="${WLSUNSET_TEMP_NIGHT:-4000}"
WLSUNSET_TEMP_DAY="${WLSUNSET_TEMP_DAY:-6500}"
WLSUNSET_START_TIME="${WLSUNSET_START_TIME:-00:00}"
WLSUNSET_END_TIME="${WLSUNSET_END_TIME:-23:59}"

# ========================================
# FUNCTIONS
# ========================================

# Check if wlsunset is currently running
is_night_mode() {
    pgrep -x wlsunset >/dev/null 2>&1
}

# Start night mode (wlsunset)
start_night_mode() {
    pkill wlsunset 2>/dev/null
    wlsunset -t "$WLSUNSET_TEMP_NIGHT" -T "$WLSUNSET_TEMP_DAY" -s "$WLSUNSET_START_TIME" -S "$WLSUNSET_END_TIME" &
}

# Stop night mode (kill wlsunset)
stop_night_mode() {
    pkill wlsunset 2>/dev/null
}

# Get current status for waybar display
get_status() {
    if is_night_mode; then
        echo "$BRACKET_OPEN $ICON_NIGHT NIGHT $BRACKET_CLOSE"
    else
        echo "$BRACKET_OPEN $ICON_DAY DAY $BRACKET_CLOSE"
    fi
}

# Toggle between night and day mode
toggle_mode() {
    if is_night_mode; then
        stop_night_mode
        # Send signal to waybar to update immediately
        pkill -RTMIN+9 waybar 2>/dev/null
        notify-send "Night Light" "$BRACKET_OPEN $ICON_DAY DAY MODE $BRACKET_CLOSE" -t 2000 2>/dev/null || true
    else
        start_night_mode
        # Send signal to waybar to update immediately
        pkill -RTMIN+9 waybar 2>/dev/null
        notify-send "Night Light" "$BRACKET_OPEN $ICON_NIGHT NIGHT MODE $BRACKET_CLOSE" -t 2000 2>/dev/null || true
    fi
}

# Show detailed info (for tooltip or manual checking)
get_info() {
    if is_night_mode; then
        echo "$BRACKET_OPEN $ICON_NIGHT NIGHT MODE $BRACKET_CLOSE"
        echo "Temperature: ${WLSUNSET_TEMP_NIGHT}K"
        echo "Active: ${WLSUNSET_START_TIME} - ${WLSUNSET_END_TIME}"
    else
        echo "$BRACKET_OPEN $ICON_DAY DAY MODE $BRACKET_CLOSE"
        echo "Temperature: ${WLSUNSET_TEMP_DAY}K"
        echo "Night light: OFF"
    fi
}

# ========================================
# MAIN SCRIPT LOGIC
# ========================================

case "${1:-status}" in
    "status")
        get_status
        ;;
    "toggle")
        toggle_mode
        ;;
    "on"|"night")
        start_night_mode
        pkill -RTMIN+9 waybar 2>/dev/null
        ;;
    "off"|"day")
        stop_night_mode
        pkill -RTMIN+9 waybar 2>/dev/null
        ;;
    "info")
        get_info
        ;;
    *)
        echo "Usage: $0 {status|toggle|on|off|info}"
        echo ""
        echo "Commands:"
        echo "  status  - Show current mode for waybar"
        echo "  toggle  - Switch between night/day mode"
        echo "  on      - Enable night mode"
        echo "  off     - Enable day mode"
        echo "  info    - Show detailed information"
        exit 1
        ;;
esac