#!/bin/bash
# WehttamSnaps System Event Sounds

# Monitor battery status
monitor_battery() {
    while true; do
        battery_level=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)
        battery_status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1)
        
        if [ "$battery_status" = "Discharging" ] && [ "$battery_level" -le 20 ]; then
            soundfx error &
            sleep 300  # Wait 5 minutes before checking again
        elif [ "$battery_status" = "Charging" ] && [ "$battery_level" -ge 90 ]; then
            soundfx success &
            sleep 300
        fi
        sleep 60
    done
}

# Monitor CPU temperature
monitor_temperature() {
    while true; do
        temp=$(sensors | grep "Package id 0:" | awk '{print $4}' | sed 's/+//;s/°C//')
        if [ "$temp" -ge 80 ]; then
            soundfx error &
            sleep 300
        fi
        sleep 30
    done
}

# Start monitors
monitor_battery &
monitor_temperature &
