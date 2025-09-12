#!/bin/bash
# WehttamSnaps Application Sound Watcher

# Monitor window creation and play sounds for specific apps
hyprctl monitor window >> /tmp/window-monitor.log &

while read -r line; do
    if echo "$line" | grep -q "window>>"; then
        # Detect specific applications and play sounds
        if echo "$line" | grep -qi "steam"; then
            soundfx gaming &
        elif echo "$line" | grep -qi "obs"; then
            soundfx stream &
        elif echo "$line" | grep -qi "discord"; then
            soundfx notify &
        elif echo "$line" | grep -qi "krita\|gimp"; then
            soundfx success &
        fi
    fi
done < <(hyprctl events window)#!/bin/bash
# WehttamSnaps Application Sound Watcher

# Monitor window creation and play sounds for specific apps
hyprctl monitor window >> /tmp/window-monitor.log &

while read -r line; do
    if echo "$line" | grep -q "window>>"; then
        # Detect specific applications and play sounds
        if echo "$line" | grep -qi "steam"; then
            soundfx gaming &
        elif echo "$line" | grep -qi "obs"; then
            soundfx stream &
        elif echo "$line" | grep -qi "discord"; then
            soundfx notify &
        elif echo "$line" | grep -qi "krita\|gimp"; then
            soundfx success &
        fi
    fi
done < <(hyprctl events window)#!/bin/bash
# WehttamSnaps Application Sound Watcher

# Monitor window creation and play sounds for specific apps
hyprctl monitor window >> /tmp/window-monitor.log &

while read -r line; do
    if echo "$line" | grep -q "window>>"; then
        # Detect specific applications and play sounds
        if echo "$line" | grep -qi "steam"; then
            soundfx gaming &
        elif echo "$line" | grep -qi "obs"; then
            soundfx stream &
        elif echo "$line" | grep -qi "discord"; then
            soundfx notify &
        elif echo "$line" | grep -qi "krita\|gimp"; then
            soundfx success &
        fi
    fi
done < <(hyprctl events window)
