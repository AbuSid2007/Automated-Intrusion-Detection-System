#!/bin/bash
# sanitize.sh
# O(N) single-pass text filtering and replacing using Extended Regex (-E)

# Short-circuit evaluation for the argument check
[ "$#" -ne 1 ] && { echo "Usage: $0 <raw_auth.log>"; exit 1; }

# Using semicolons to chain commands in a single execution block.
# (root|admin) is a regex capture group acting as a logical OR.
sed -E '/\[CORRUPT-DATA\]/d; s/user=(root|admin)/user=SYS_ADMIN/g; s/\|/,/g' "$1" > clean_log.csv