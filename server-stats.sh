#!/bin/bash

# server-stats.sh - Analyzes basic server performance stats on Linux

echo "=== Server Performance Statistics (Generated on $(date)) ==="

## OS Version
echo -e "\n## OS Version:"
cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2 || lsb_release -ds 2>/dev/null || uname -a[web:30]

## Uptime & Load Average
echo -e "\n## Uptime & Load Average:"
uptime[web:31]

## Logged-in Users
echo -e "\n## Logged-in Users:"
echo "$(who | wc -l) users logged in"
echo "Users: $(who | awk '{print $1}' | sort | uniq -c | sort -nr | head -3 | awk '{printf "%s(%s) ", $2, $1}')"[web:30]

## Failed Login Attempts (last 24h)
echo -e "\n## Failed Login Attempts (last 24h):"
grep "Failed password" /var/log/auth.log* 2>/dev/null | grep "$(date -d '24 hours ago' '+%b %d')" | wc -l || echo "0 (check logs manually)"[web:30]

## CPU Usage (%)
echo -e "\n## Total CPU Usage:"
cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo "${cpu}% used"[web:31][web:32]

## Memory Usage
echo -e "\n## Total Memory Usage:"
free -m | awk 'NR==2{printf "Used: %sMB / %sMB (%.1f%%)\nFree: %sMB (%.1f%%)\n", $3, $2, $3/$2*100, $4, $4/$2*100}'[web:31]

## Disk Usage (Root FS)
echo -e "\n## Total Disk Usage (Root):"
df -h / | awk 'NR==2{printf "Used: %s / %s (%.0f%%)\nFree: %s (%.0f%%)\n", $3, $2, $5+0, $4, 100-$5}'[web:31]

## Top 5 Processes by CPU
echo -e "\n## Top 5 Processes by CPU Usage:"
ps aux --sort=-%cpu | head -6 | awk 'NR>1{printf "%-8s %-8s %4s%% CPU %s\n", $1, $2, $3, $11}'[web:31][web:35]

## Top 5 Processes by Memory
echo -e "\n## Top 5 Processes by Memory Usage:"
ps aux --sort=-%mem | head -6 | awk 'NR>1{printf "%-8s %-8s %4s%% MEM %s\n", $1, $2, $4, $11}'[web:31][web:35]

echo -e "\n=== End of Report ==="

