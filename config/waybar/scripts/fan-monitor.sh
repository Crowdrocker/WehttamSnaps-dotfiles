#!/bin/bash
# WehttamSnaps Fan Monitoring Script - i5-4430 + RX 580 specific

while true; do
    # Get CPU fan speed (fan2 from nct6791)
    cpu_fan=$(sensors | grep "fan2:" | awk '{print $2}')
    
    # Get GPU fan speed (fan1 from amdgpu)
    gpu_fan=$(sensors | grep "fan1:" | awk '{print $2}' | head -n 1)
    
    # If we have both fans, show combined info
    if [ -n "$cpu_fan" ] && [ -n "$gpu_fan" ]; then
        echo "FANS: CPU:${cpu_fan} GPU:${gpu_fan}"
    elif [ -n "$cpu_fan" ]; then
        echo "FAN: ${cpu_fan}RPM"
    elif [ -n "$gpu_fan" ]; then
        echo "FAN: ${gpu_fan}RPM"
    else
        echo "FAN: N/A"
    fi
    
    sleep 5
done
