#!/bin/bash

WD_RIGHT="$HOME/Wizard/api-audiowizard/"
WD_LEFT="$HOME/Wizard/app-audiowizard/"

hyprctl dispatch workspace 7
hyprctl dispatch focusmonitor eDP-1
sleep 0.2

alacritty --working-directory "$WD_RIGHT" &
sleep 0.5
hyprctl dispatch movefocus right
hyprctl dispatch resizeactive 200 0

alacritty --working-directory "$WD_LEFT" &
sleep 0.5
hyprctl dispatch movefocus left

hyprctl dispatch workspace 7
