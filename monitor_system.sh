#!/usr/bin/env bash

set -u
set -o pipefail

CPU_CORES=$(grep -h . /sys/devices/system/cpu/cpu*/topology/core_id \
  | cut -d: -f2 \
  | sort -u \
  | wc -l)

LOAD_WARN=$(awk "BEGIN {printf \"%.2f\", $CPU_CORES * 0.7}")
LOAD_CRIT=$(awk "BEGIN {printf \"%.2f\", $CPU_CORES * 1.0}")

LOAD_15=$(awk '{print $3}' /proc/loadavg)

LOAD_STATUS="OK"
if awk "BEGIN {exit !($LOAD_15 >= $LOAD_CRIT)}"; then
  LOAD_STATUS="CRIT"
elif awk "BEGIN {exit !($LOAD_15 >= $LOAD_WARN)}"; then
  LOAD_STATUS="WARN"
fi

DISK_USAGE_RAW=$(df -P / | awk 'NR==2 {print $5}')
DISK_USAGE=${DISK_USAGE_RAW%\%}

DISK_STATUS="OK"
if [ "$DISK_USAGE" -ge 90 ]; then
  DISK_STATUS="CRIT"
elif [ "$DISK_USAGE" -ge 80 ]; then
  DISK_STATUS="WARN"
fi

echo "System Health Check"
echo "==================="
echo "CPU Cores        : $CPU_CORES"
echo "Load (15 min)    : $LOAD_15 (WARN >= $LOAD_WARN | CRIT >= $LOAD_CRIT) => $LOAD_STATUS"
echo "Disk Usage (/)   : $DISK_USAGE% => $DISK_STATUS"
