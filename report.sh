#!/bin/bash
# report.sh
# Aggregates targeted ports using regex extraction

clean_log=${1:-clean_log.csv} 

echo "Target Port Analysis"
echo "--------------------"

awk '/Failed password/ {
    
    # Regex: matches "port=" followed by 1 or more digits (+)
    if (match($0, /port=[0-9]+/)) {
        
        # Extract just the numbers (skip the 5 chars of "port=")
        p = substr($0, RSTART+5, RLENGTH-5)
        
        freq[p]++
    }
}
END {
    # Iterate and print state
    for (i in freq) {
        print "Port " i " : " freq[i] " attempts"
    }
}' "$clean_log"