#!/bin/bash

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
RAM=$(free | awk '/Mem/{printf("%.2f"), $3/$2 * 100}')
DISK=$(df / | awk 'END{print $5}')

echo "🖥️ SERVER HEALTH"
echo "CPU Usage: $CPU%"
echo "RAM Usage: $RAM%"
echo "Disk Usage: $DISK"
