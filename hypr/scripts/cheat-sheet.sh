#!/bin/bash

# Dynamic ASCII Art Cheat Sheet for Hyprland Keybindings
# Parses binds.conf file to generate cheat sheet content
# Colors: Light Blue (#87ceeb), Green (#00ff00), matching waybar theme

BINDS_FILE="$HOME/.config/hypr/conf/binds.conf"
MONITOR_FILE="$HOME/.config/hypr/conf/monitor.conf"

# Function to parse keybindings from a section
parse_section() {
    local section_name="$1"
    local in_section=false
    local bindings=()

    while IFS= read -r line; do
        # Check if we're entering the target section
        if [[ "$line" =~ ^#[[:space:]]*SECTION:[[:space:]]*(.+)$ ]]; then
            current_section="${BASH_REMATCH[1]}"
            if [[ "$current_section" == "$section_name" ]]; then
                in_section=true
                continue
            else
                in_section=false
            fi
        fi

        # If we're in the target section and find a bind line
        if [[ "$in_section" == true && "$line" =~ ^(bind[m]?)[[:space:]]*=[[:space:]]*(.+)#[[:space:]]*(.+)$ ]]; then
            local bind_type="${BASH_REMATCH[1]}"
            local bind_def="${BASH_REMATCH[2]}"
            local comment="${BASH_REMATCH[3]}"

            # Parse the binding definition
            local parts=($bind_def)
            local modifier="${parts[0]}"
            local key="${parts[1]}"
            local action="${parts[2]}"

            # Format the key combination
            local key_combo=""
            if [[ "$modifier" == "\$mainMod" ]]; then
                key_combo="Super"
            elif [[ "$modifier" == "\$mainMod SHIFT" ]]; then
                key_combo="Super + Shift"
            elif [[ "$modifier" == "\$mainMod CTRL" ]]; then
                key_combo="Super + Ctrl"
            elif [[ "$modifier" == "\$mainMod ALT" ]]; then
                key_combo="Super + Alt"
            elif [[ "$modifier" == "" ]]; then
                key_combo=""
            else
                key_combo="$modifier"
            fi

            # Add the key
            if [[ -n "$key_combo" && -n "$key" ]]; then
                key_combo="$key_combo + $key"
            elif [[ -n "$key" ]]; then
                key_combo="$key"
            fi

            # Store the binding
            bindings+=("$key_combo|$comment")
        fi
    done < "$BINDS_FILE"

    # Print the bindings for this section
    for binding in "${bindings[@]}"; do
        IFS='|' read -r keys desc <<< "$binding"
        printf "  ├─ \${BLUE}%-25s\${RESET} │ %-40s \${BLUE}║\${RESET}\n" "$keys" "$desc"
    done
}

# Function to get section display name
get_section_display_name() {
    case "$1" in
        "BASIC ACTIONS") echo "WINDOW MANAGEMENT" ;;
        "WORKSPACE SWITCHING (1-9)") echo "WORKSPACE NAVIGATION" ;;
        "MOVE WINDOW TO WORKSPACE") echo "WINDOW MOVEMENT" ;;
        "MONITOR FOCUS SWITCHING") echo "MONITOR MANAGEMENT" ;;
        "SCREENSHOT BINDINGS") echo "SCREENSHOTS" ;;
        "MEDIA AND HARDWARE KEYS") echo "SYSTEM CONTROLS" ;;
        "SPECIAL WORKSPACE (SCRATCHPAD)") echo "SPECIAL FEATURES" ;;
        "WORKSPACE MANAGEMENT SCRIPTS") echo "WORKSPACE SCRIPTS" ;;
        "SYSTEM RELOAD BINDINGS") echo "SYSTEM RELOAD" ;;
        "HELP AND INFORMATION") echo "HELP" ;;
        "MOUSE BINDINGS") echo "MOUSE CONTROLS" ;;
        *) echo "$1" ;;
    esac
}

# Function to parse workspace layout from monitor.conf
parse_workspace_layout() {
    local monitor_workspaces=()
    local monitor_names=()

    # Parse monitor definitions and workspace assignments
    while IFS= read -r line; do
        # Parse monitor definitions
        if [[ "$line" =~ ^monitor=([^,]+), ]]; then
            monitor_name="${BASH_REMATCH[1]}"
        fi

        # Parse workspace assignments with comments
        if [[ "$line" =~ ^#[[:space:]]*([^:]+):[[:space:]]*Workspaces[[:space:]]*([0-9,[:space:]]+) ]]; then
            monitor_desc="${BASH_REMATCH[1]}"
            workspaces="${BASH_REMATCH[2]}"
            # Clean up workspaces string and format with consistent spacing
            workspaces=$(echo "$workspaces" | sed "s/,/ ] [ /g" | sed "s/^/[ /" | sed "s/$/ ]/")
            monitor_workspaces+=("$monitor_desc|$workspaces")
        fi
    done < "$MONITOR_FILE"

    # If no commented workspace assignments found, try to parse from workspace lines
    if [[ ${#monitor_workspaces[@]} -eq 0 ]]; then
        declare -A monitor_ws_map

        # Parse workspace assignments
        while IFS= read -r line; do
            if [[ "$line" =~ ^workspace[[:space:]]*=[[:space:]]*([0-9]+),[[:space:]]*monitor:([^,]+) ]]; then
                workspace_num="${BASH_REMATCH[1]}"
                monitor_name="${BASH_REMATCH[2]}"

                if [[ -z "${monitor_ws_map[$monitor_name]}" ]]; then
                    monitor_ws_map[$monitor_name]="$workspace_num"
                else
                    monitor_ws_map[$monitor_name]="${monitor_ws_map[$monitor_name]} $workspace_num"
                fi
            fi
        done < "$MONITOR_FILE"

        # Convert to display format
        for monitor in "${!monitor_ws_map[@]}"; do
            workspaces="${monitor_ws_map[$monitor]}"
            workspaces=$(echo "$workspaces" | sed "s/ / ] [ /g" | sed "s/^/[ /" | sed "s/$/ ]/")
            monitor_workspaces+=("$monitor ($monitor)|$workspaces")
        done
    fi

    # Output the workspace layout with proper alignment
    count=0
    total=${#monitor_workspaces[@]}

    for entry in "${monitor_workspaces[@]}"; do
        IFS="|" read -r monitor_desc workspaces <<< "$entry"
        count=$((count + 1))

        if [[ $count -eq $total ]]; then
            prefix="  └─"
        else
            prefix="  ├─"
        fi

        # Ensure consistent spacing - pad monitor description to 25 characters
        monitor_desc_padded=$(printf "%-25s" "$monitor_desc")
        layout_line="$prefix $monitor_desc_padded │ ${GREEN}$workspaces${RESET}"

        # Calculate visible length (without color codes)
        visible_layout=$(echo "$layout_line" | sed "s/\033\[[0-9;]*m//g")
        visible_length=${#visible_layout}
        padding=$((CONTENT_WIDTH - visible_length))
        echo -e "${BLUE}║${RESET}$layout_line$(printf "%*s" $padding "")${BLUE}║${RESET}"
    done
}

show_cheat_sheet() {
    alacritty --class="cheat-sheet" --title="[ HYPRLAND CHEAT SHEET ]" -e bash -c '
    clear

    # Color definitions matching waybar theme
    BLUE="\033[38;2;135;206;235m"    # Light blue #87ceeb
    GREEN="\033[38;2;0;255;0m"       # Green #00ff00
    GRAY="\033[38;2;224;224;224m"    # Light gray #e0e0e0
    RESET="\033[0m"
    BOLD="\033[1m"

    # Define the total box width (including borders)
    BOX_WIDTH=85
    CONTENT_WIDTH=$((BOX_WIDTH - 2))  # 83 characters for content

    echo -e "
${BLUE}╔═══════════════════════════════════════════════════════════════════════════════════╗${RESET}
${BLUE}║${RESET}                          ${GREEN}[ HYPRLAND CHEAT SHEET ]${RESET}                                 ${BLUE}║${RESET}
${BLUE}╠═══════════════════════════════════════════════════════════════════════════════════╣${RESET}
${BLUE}║${RESET}$(printf "%*s" $CONTENT_WIDTH "")${BLUE}║${RESET}"

    # Parse sections from binds.conf and generate content
    sections=(
        "BASIC ACTIONS"
        "WORKSPACE SWITCHING"
        "MOVE WINDOW TO WORKSPACE"
        "MOVE WINDOW TO WORKSPACE SILENTLY"
        "MONITOR FOCUS SWITCHING"
        "WORKSPACE SCROLLING"
        "ADVANCED WORKSPACE MANAGEMENT"
        "SCREENSHOT BINDINGS"
        "SYSTEM RELOAD BINDINGS"
        "WAYBAR DEFAULT MODE"
        "MEDIA AND HARDWARE KEYS"
        "SPECIAL WORKSPACE"
        "WORKSPACE MANAGEMENT SCRIPTS"
        "WINDOW FOCUS MOVEMENT"
    )

    for section in "${sections[@]}"; do
        display_name=$(case "$section" in
            "BASIC ACTIONS") echo "WINDOW MANAGEMENT" ;;
            "WORKSPACE SWITCHING") echo "WORKSPACE NAVIGATION (AZERTY)" ;;
            "MOVE WINDOW TO WORKSPACE") echo "WINDOW MOVEMENT (AZERTY)" ;;
            "MOVE WINDOW TO WORKSPACE SILENTLY") echo "SILENT WINDOW MOVEMENT" ;;
            "MONITOR FOCUS SWITCHING") echo "MONITOR MANAGEMENT" ;;
            "WORKSPACE SCROLLING") echo "WORKSPACE SCROLLING" ;;
            "ADVANCED WORKSPACE MANAGEMENT") echo "WORKSPACE NAVIGATION" ;;
            "SCREENSHOT BINDINGS") echo "SCREENSHOTS" ;;
            "SYSTEM RELOAD BINDINGS") echo "SYSTEM RELOAD" ;;
            "WAYBAR DEFAULT MODE") echo "WAYBAR CONTROLS" ;;
            "MEDIA AND HARDWARE KEYS") echo "SYSTEM CONTROLS" ;;
            "SPECIAL WORKSPACE") echo "SPECIAL FEATURES" ;;
            "WORKSPACE MANAGEMENT SCRIPTS") echo "WORKSPACE SCRIPTS" ;;
            "WINDOW FOCUS MOVEMENT") echo "WINDOW FOCUS" ;;
            *) echo "$section" ;;
        esac)

        # Calculate padding for section header
        section_text="  ${GREEN}[ $display_name ]${RESET}"
        display_name_length=${#display_name}
        section_length=$((4 + display_name_length + 3))  # 4 for "  [ " and 3 for " ]"
        section_padding=$((CONTENT_WIDTH - section_length))

        echo -e "${BLUE}║${RESET}$section_text$(printf "%*s" $section_padding "") ${BLUE}║${RESET}"

        # Parse bindings for this section
        in_section=false
        while IFS= read -r line; do
            # Check if we'\''re entering the target section
            if [[ "$line" =~ ^#[[:space:]]*SECTION:[[:space:]]*(.+)$ ]]; then
                current_section="${BASH_REMATCH[1]}"
                if [[ "$current_section" == *"$section"* ]]; then
                    in_section=true
                    continue
                else
                    in_section=false
                fi
            fi

            # If we'\''re in the target section and find a bind line
            if [[ "$in_section" == true && "$line" =~ ^(bind[m]?)[[:space:]]*=[[:space:]]*([^#]+)#[[:space:]]*(.+)$ ]]; then
                bind_def="${BASH_REMATCH[2]}"
                comment="${BASH_REMATCH[3]}"

                # Clean up the bind definition by removing extra spaces and commas
                bind_def=$(echo "$bind_def" | sed "s/,/ /g" | sed "s/[[:space:]]\+/ /g" | sed "s/^[[:space:]]*//;s/[[:space:]]*$//")

                # Parse the binding definition - split by spaces but handle modifiers properly
                read -ra parts <<< "$bind_def"

                # Find where the key starts (after modifiers and before action)
                key=""
                action_start_idx=0

                # Look for the key (non-modifier, non-action part)
                for ((i=0; i<${#parts[@]}; i++)); do
                    part="${parts[i]}"
                    # Skip known modifiers and mainMod
                    if [[ "$part" != "\$mainMod" && "$part" != "SHIFT" && "$part" != "CTRL" && "$part" != "ALT" && "$part" != "," ]]; then
                        # Check if this looks like an action (contains common action words)
                        if [[ "$part" =~ ^(exec|workspace|movetoworkspace|killactive|exit|togglefloating|fullscreen|pseudo|togglesplit|movefocus|focusmonitor|togglespecialworkspace|movetoworkspacesilent)$ ]]; then
                            action_start_idx=$i
                            break
                        else
                            # This should be the key
                            key="$part"
                            action_start_idx=$((i+1))
                            break
                        fi
                    fi
                done

                # Extract modifiers (everything before the key)
                modifiers=""
                for ((i=0; i<${#parts[@]} && i<action_start_idx-1; i++)); do
                    part="${parts[i]}"
                    if [[ "$part" != "," ]]; then
                        if [[ -n "$modifiers" ]]; then
                            modifiers="$modifiers $part"
                        else
                            modifiers="$part"
                        fi
                    fi
                done

                # Format the key combination
                key_combo=""
                if [[ -n "$modifiers" ]]; then
                    # Handle mainMod replacement and formatting
                    formatted_modifiers=$(echo "$modifiers" | sed "s/\$mainMod/Super/g")

                    # Clean up spacing and format
                    formatted_modifiers=$(echo "$formatted_modifiers" | sed "s/[[:space:]]\+/ + /g")

                    if [[ -n "$key" ]]; then
                        key_combo="$formatted_modifiers + $key"
                    else
                        key_combo="$formatted_modifiers"
                    fi
                else
                    key_combo="$key"
                fi

                # Format the line content
                line_content="  ├─ ${BLUE}$key_combo${RESET} │ $comment"
                # Calculate visible length (without color codes)
                visible_content="  ├─ $key_combo │ $comment"
                visible_length=${#visible_content}

                # Calculate padding needed
                padding=$((CONTENT_WIDTH - visible_length))
                if [[ $padding -lt 0 ]]; then
                    # Truncate comment if line is too long
                    visible_base="  ├─ $key_combo │ "
                    visible_base_length=${#visible_base}
                    max_comment_length=$((CONTENT_WIDTH - visible_base_length - 3))
                    if [[ $max_comment_length -gt 0 ]]; then
                        comment="${comment:0:$max_comment_length}..."
                        line_content="  ├─ ${BLUE}$key_combo${RESET} │ $comment"
                        visible_content="  ├─ $key_combo │ $comment"
                        visible_length=${#visible_content}
                        padding=$((CONTENT_WIDTH - visible_length))
                    else
                        padding=0
                    fi
                fi

                echo -e "${BLUE}║${RESET}$line_content$(printf "%*s" $padding "")${BLUE}║${RESET}"
            fi
        done < "'"$BINDS_FILE"'"

        echo -e "${BLUE}║${RESET}$(printf "%*s" $CONTENT_WIDTH "")${BLUE}║${RESET}"
    done

    # Add workspace layout section - dynamically generated
    section_text="  ${GREEN}[ WORKSPACE LAYOUT ]${RESET}"
    section_length=$((4 + 16 + 3))  # 4 for "  [ " and 3 for " ]" and 16 for "WORKSPACE LAYOUT"
    section_padding=$((CONTENT_WIDTH - section_length))
    echo -e "${BLUE}║${RESET}$section_text$(printf "%*s" $section_padding "") ${BLUE}║${RESET}"

    # Parse workspace layout from monitor.conf
    monitor_workspaces=()

    # Parse workspace assignments with comments
    while IFS= read -r line; do
        if [[ "$line" =~ ^#[[:space:]]*([^:]+):[[:space:]]*Workspaces[[:space:]]*([0-9,[:space:]]+) ]]; then
            monitor_desc="${BASH_REMATCH[1]}"
            workspaces="${BASH_REMATCH[2]}"
            # Clean up workspaces string and format with consistent spacing
            workspaces=$(echo "$workspaces" | sed "s/,/ ] [ /g" | sed "s/^/[ /" | sed "s/$/ ]/")
            monitor_workspaces+=("$monitor_desc|$workspaces")
        fi
    done < "'"$MONITOR_FILE"'"

    # If no commented workspace assignments found, try to parse from workspace lines
    if [[ ${#monitor_workspaces[@]} -eq 0 ]]; then
        declare -A monitor_ws_map

        # Parse workspace assignments
        while IFS= read -r line; do
            if [[ "$line" =~ ^workspace[[:space:]]*=[[:space:]]*([0-9]+),[[:space:]]*monitor:([^,]+) ]]; then
                workspace_num="${BASH_REMATCH[1]}"
                monitor_name="${BASH_REMATCH[2]}"

                if [[ -z "${monitor_ws_map[$monitor_name]}" ]]; then
                    monitor_ws_map[$monitor_name]="$workspace_num"
                else
                    monitor_ws_map[$monitor_name]="${monitor_ws_map[$monitor_name]} $workspace_num"
                fi
            fi
        done < "'"$MONITOR_FILE"'"

        # Convert to display format
        for monitor in "${!monitor_ws_map[@]}"; do
            workspaces="${monitor_ws_map[$monitor]}"
            workspaces=$(echo "$workspaces" | sed "s/ / ] [ /g" | sed "s/^/[ /" | sed "s/$/ ]/")
            monitor_workspaces+=("$monitor ($monitor)|$workspaces")
        done
    fi

    # Output the workspace layout with proper alignment
    count=0
    total=${#monitor_workspaces[@]}

    for entry in "${monitor_workspaces[@]}"; do
        IFS="|" read -r monitor_desc workspaces <<< "$entry"
        count=$((count + 1))

        if [[ $count -eq $total ]]; then
            prefix="  └─"
        else
            prefix="  ├─"
        fi

        # Ensure consistent spacing - pad monitor description to 25 characters
        monitor_desc_padded=$(printf "%-25s" "$monitor_desc")
        layout_line="$prefix $monitor_desc_padded │ ${GREEN}$workspaces${RESET}"

        # Calculate visible length (without color codes)
        visible_layout=$(echo "$layout_line" | sed "s/\033\[[0-9;]*m//g")
        visible_length=${#visible_layout}
        padding=$((CONTENT_WIDTH - visible_length + 2))
        echo -e "${BLUE}║${RESET}$layout_line$(printf "%*s" $padding "")${BLUE}║${RESET}"
    done

    echo -e "${BLUE}║${RESET}$(printf "%*s" $CONTENT_WIDTH "")${BLUE}║${RESET}"

    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════════════════╝${RESET}

${GREEN}[ Press any key to close this cheat sheet ]${RESET}"
    read -n 1 -s
    '
}

# Run the cheat sheet
show_cheat_sheet