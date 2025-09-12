#!/bin/bash

# Toggle gamemode for WehttamSnaps

GAMEMODE_STATUS=$(gamemoded -s)

if [ "$GAMEMODE_STATUS" = "Game mode is inactive" ]; then
    gamemoded -r
    notify-send "Gamemode Activated" "Performance mode enabled for gaming"
    # Reduce background processes, adjust CPU governor, etc.
    sudo cpupower frequency-set -g performance
else
    gamemoded -x
    notify-send "Gamemode Deactivated" "Returning to normal mode"
    sudo cpupower frequency-set -g powersave
fi
