#!/bin/bash
# WehttamSnaps Custom CPU Usage Script for Waybar - i5-4430 specific

get_cpu_usage() {
    # Read the first line of /proc/stat
    read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    
    # Calculate total CPU time
    total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    
    # Calculate idle time
    idle_total=$((idle + iowait))
    
    echo "$total $idle_total"
}

# Get CPU temperature from coretemp (Package id 0)
get_cpu_temp() {
    temp=$(sensors | grep "Package id 0:" | awk '{print $4}' | sed 's/+//;s/°C//')
    echo "${temp:-0}"
}

# Get CPU frequency
get_cpu_freq() {
    # Get average frequency of all cores
    freq=$(cat /proc/cpuinfo | grep "MHz" | awk '{total += $4; count++} END {printf "%.2f", total/count/1000}')
    echo "${freq:-0}"
}

# Initial read
read -r prev_total prev_idle < <(get_cpu_usage)
sleep 1

while true; do
    # Get current CPU stats
    read -r total idle < <(get_cpu_usage)
    
    # Calculate difference
    total_diff=$((total - prev_total))
    idle_diff=$((idle - prev_idle))
    
    # Calculate CPU usage percentage
    if [ "$total_diff" -eq 0 ]; then
        usage=0
    else
        usage=$((100 * (total_diff - idle_diff) / total_diff))
    fi
    
    # Get CPU temperature
    temp=$(get_cpu_temp)
    
    # Get CPU frequency
    freq=$(get_cpu_freq)
    
    # Determine color class based on temperature
    if [ "$temp" -ge 80 ]; then
        class="critical"
    elif [ "$temp" -ge 70 ]; then
        class="warning"
    else
        class="normal"
    fi
    
    # Output for Waybar
    echo "{\"text\": \"CPU: $usage%\", \"tooltip\": \"Usage: $usage%\\nFrequency: ${freq} GHz\\nTemperature: ${temp}°C\", \"class\": \"$class\"}"
    
    # Update previous values
    prev_total=$total
    prev_idle=$idle
    
    sleep 2
done
