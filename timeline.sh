#!/bin/bash
# timeline.sh


clean_log=${1:-clean_log.csv}

awk '/Failed password/ {
    
    # Regex: finds a space, exactly two digits, and a colon (e.g., " 09:")
    if (match($0, / [0-9]{2}:/)) {
        
        # Pluck out just the two hour digits (skip the leading space)
        hr = substr($0, RSTART+1, 2)
        
        time_map[hr]++
    }
}
END {
    for (h in time_map) {
        printf "Hour %s: %d failed attempts\n", h, time_map[h]
    }
}' "$clean_log" | sort