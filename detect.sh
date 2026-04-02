#!/bin/bash
# detect.sh
# Extracts brute-force IPs using global line regex matching.

[ "$#" -ne 3 ] && { echo "Usage: $0 <clean_log.csv> <whitelist.txt> <output_file>"; exit 1; }

log="$1"; wl="$2"; out="$3"

# Flush output file
> "$out" 

# awk parses the entire line as a single string ($0)
# match() finds the exact regex pattern and auto-sets RSTART (index) and RLENGTH
suspects=$(awk '/Failed password/ {
    
    # Regex: matches "ip=" followed by standard IPv4 structure
    if (match($0, /ip=[0-9]{1,3}(\.[0-9]{1,3}){3}/)) {
        
        # Extract exactly the IP string. 
        # We add +3 to RSTART to skip over the "ip=" prefix.
        ip_str = substr($0, RSTART+3, RLENGTH-3)
        
        # frequency array / unordered_map equivalent
        mp[ip_str]++
    }
}
END {
    for (i in mp) {
        # Strict threshold boundary
        if (mp[i] > 10) print i, mp[i]
    }
}' "$log")

# Whitelist cross-checking via manual nested loop
echo "$suspects" | while read -r attacker count; do
    [ -z "$attacker" ] && continue 

    # 0 means unvisited / not safe
    safe_flag=0 

    while IFS= read -r safe_node || [ -n "$safe_node" ]; do
        clean_node=$(echo "$safe_node" | tr -d '\r\n ')
        
        if [ "$attacker" == "$clean_node" ]; then
            safe_flag=1 
            break # Early exit / prune search space
        fi
    done < "$wl"
    
    # If the state is still 0, the node wasn't in the whitelist graph
    if [ "$safe_flag" -eq 0 ]; then
        echo "iptables -A INPUT -s $attacker -j DROP # Blocked after $count failed attempts" >> "$out"
    fi
done