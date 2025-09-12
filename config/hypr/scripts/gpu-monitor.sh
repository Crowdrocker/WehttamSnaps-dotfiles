#!/bin/bash
# GPU Monitoring Script for WehttamSnaps

# Function to get GPU temperature
get_gpu_temp() {
    # Try AMD first, then NVIDIA
    temp=$(sensors | grep -i "edge" | awk '{print $2}' | sed 's/+//;s/°C//')
    if [ -z "$temp" ]; then
        temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
    fi
    echo "${temp:-N/A}"
}

# Function to get GPU usage
get_gpu_usage() {
    # Try AMD first, then NVIDIA
    usage=$(cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null)
    if [ -z "$usage" ]; then
        usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)
    fi
    echo "${usage:-N/A}"
}

# Function to get GPU frequency
get_gpu_freq() {
    # Try AMD first, then NVIDIA
    freq=$(cat /sys/class/drm/card0/device/pp_dpm_sclk 2>/dev/null | grep '*' | awk '{print $2}' | sed 's/Mhz//')
    if [ -z "$freq" ]; then
        freq=$(nvidia-smi --query-gpu=clocks.gr --format=csv,noheader,nounits 2>/dev/null)
    fi
    echo "${freq:-N/A}"
}

# Main monitoring loop
while true; do
    gpu_temp=$(get_gpu_temp)
    gpu_usage=$(get_gpu_usage)
    gpu_freq=$(get_gpu_freq)
    
    # Update Waybar or other status bar
    if [ -f /tmp/gpu-status ]; then
        echo "GPU: ${gpu_temp}°C | ${gpu_usage}% | ${gpu_freq}MHz" > /tmp/gpu-status
    fi
    
    sleep 5
done
