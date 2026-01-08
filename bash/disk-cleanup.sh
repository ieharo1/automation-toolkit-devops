#!/bin/bash

LOG_DIR="/var/log"
DAYS=15

find $LOG_DIR -type f -mtime +$DAYS -exec rm -f {} \;

echo "🧹 Logs older than $DAYS days deleted"
