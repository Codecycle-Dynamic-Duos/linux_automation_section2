#!/bin/bash

# Setting sudo attempts threshold
THRESHOLD=3

# Log file to monitor sudo commands
LOG_FILE="/var/log/sudo-access.log"

# Mail adddress to notify
ADMIN_EMAIL="niranjank.desktop@gmail.com"

# Extract low privilege users from /etc/passwd
LOW_PRIV_USERS=$(awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd)

echo $LOW_PRIV_USERS

for USER in $LOW_PRIV_USERS; do

    # Count sudo command attempts
    SUDO_COUNT=$(grep -c "$USER : user NOT in sudoers" $LOG_FILE)

    # Check if attempts exceed threshold
    if [ $SUDO_COUNT -gt $THRESHOLD ]; then
        # Send notification to admin
        echo "Threshold reached.. Mailing about - $USER"
        echo "The user $USER has attempted to use sudo commands $SUDO_COUNT times." | mail -s "Excessive sudo attempts by $USER" "$ADMIN_EMAIL"
    fi
done
