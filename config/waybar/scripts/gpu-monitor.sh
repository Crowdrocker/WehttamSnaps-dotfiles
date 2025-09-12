#!/bin/bash
# WehttamSnaps GPU Monitoring Script - RX 580 specific

while true; do
    # Get GPU temperature from amdgpu (edge sensor)
    gpu_temp=$(sensors | grep "edge:" | awk '{print $2}' | sed 's/+//;s/°C//')
    
    # Get GPU usage (from amdgpu)
    gpu_usage=$(cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null || echo "0")
    
    # Get GPU frequency
    gpu_freq=$(cat /sys/class/drm/card0/device/pp_dpm_sclk 2>/dev/null | grep "*" | awk '{print $2}' | sed 's/MHz//' | head -n 1)
    if [ -z "$gpu_freq" ]; then
        gpu_freq=$(sensors | grep "sclk:" | awk '{print $2}' | sed 's/MHz//')
    fi
    
    # Get GPU memory frequency
    mem_freq=$(cat /sys/class/drm/card0/device/pp_dpm_mclk 2>/dev/null | grep "*" | awk '{print $2}' | sed 's/MHz//' | head -n 1)
    if [ -z "$mem_freq" ]; then
        mem_freq=$(sensors | grep "mclk:" | awk '{print $2}' | sed 's/MHz//')
    fi
    
    # Get GPU fan speed
    fan_speed=$(sensors | grep "fan1:" | awk '{print $2}')
    
    # If we don't have GPU data, show minimal info
    if [ -z "$gpu_temp" ]; then
        echo "GPU: N/A"
    else
        # Determine icon based on temperature
        if [ "$gpu_temp" -ge 85 ]; then
            icon=""
        elif [ "$gpu_temp" -ge 75 ]; then
            icon=""
        else
            icon=""
        fi
        
        # Show simplified info in bar, detailed in tooltip would need JSON
        echo "GPU: ${gpu_temp}°C $icon"
    fi
    
    sleep 3
done
