#!/bin/bash
# WehttamSnaps Temperature Monitoring Script - i5-4430 specific

while true; do
    # Get CPU temperature from coretemp (Package id 0)
    temp=$(sensors | grep "Package id 0:" | awk '{print $4}' | sed 's/+//;s/°C//')
    
    # If that doesn't work, try alternative sensors
    if [ -z "$temp" ]; then
        temp=$(sensors | grep "CPUTIN" | awk '{print $2}' | sed 's/+//;s/°C//')
    fi
    
    # If we still don't have a temperature, show N/A
    if [ -z "$temp" ]; then
        echo "TEMP: N/A"
    else
        # Determine icon based on temperature
        if [ "$temp" -ge 80 ]; then
            icon=""
        elif [ "$temp" -ge 70 ]; then
            icon=""
        else
            icon=""
        fi
        echo "TEMP: ${temp}°C $icon"
    fi
    
    sleep 5
done
