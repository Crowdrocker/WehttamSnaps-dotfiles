#!/bin/bash
# WehttamSnaps Sensor Debug Script

echo "=== CPU Info ==="
echo "CPU cores: $(nproc)"
echo "CPU model: $(grep "model name" /proc/cpuinfo | head -n 1 | cut -d: -f2 | sed 's/^ //')"

echo ""
echo "=== Temperature Sensors ==="
if command -v sensors &> /dev/null; then
    sensors
else
    echo "lm-sensors not installed or not working"
fi

echo ""
echo "=== Available HWMon Devices ==="
find /sys/class/hwmon -name "hwmon*" | while read hwmon; do
    echo "Device: $hwmon"
    if [ -f "$hwmon/name" ]; then
        echo "  Name: $(cat $hwmon/name)"
    fi
    find "$hwmon" -name "temp*_input" | while read temp; do
        temp_val=$(cat "$temp")
        if [ "$temp_val" -gt 0 ]; then
            echo "  Temperature: $((temp_val / 1000))°C ($(basename $temp))"
        fi
    done
done

echo ""
echo "=== CPU Frequency ==="
if [ -f "/proc/cpuinfo" ]; then
    grep "MHz" /proc/cpuinfo | head -n 5
else
    echo "/proc/cpuinfo not available"
fi

echo ""
echo "=== Memory Info ==="
free -h

echo ""
echo "=== Recommendations ==="
echo "1. Install lm-sensors: sudo pacman -S lm_sensors"
echo "2. Run sensors-detect: sudo sensors-detect"
echo "3. Install procps-ng: sudo pacman -S procps-ng"
