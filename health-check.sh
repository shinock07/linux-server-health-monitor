#!/bin/bash
REPORT_DIR="$HOME/linux-server-health-monitor/reports"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
REPORT_FILE="$REPORT_DIR/health-report-$TIMESTAMP.log"

mkdir -p "$REPORT_DIR" || {
    echo "ERROR: Cannot create report directory" >&2
    exit 3
}

if ! touch "$REPORT_FILE"; then
    echo "ERROR: Cannot create report file: $REPORT_FILE" >&2
    exit 3
fi

# Severity levels: OK=0, WARNING=1, CRITICAL=2, UNKNOWN=3
OVERALL_STATUS=0

set_status() {
    local new_status="$1"

    case "$new_status" in
        OK)       new_level=0 ;;
        WARNING)  new_level=1 ;;
        CRITICAL) new_level=2 ;;
        UNKNOWN)  new_level=3 ;;
        *)
            echo "ERROR: Invalid status: $new_status" >&2
            return 1
            ;;
    esac

    if [ "$new_level" -gt "$OVERALL_STATUS" ]; then
        OVERALL_STATUS="$new_level"
    fi
}
report() {
    local level="$1"
    shift

    printf '[%s] %-8s %s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$level" "$*" | tee -a "$REPORT_FILE"
}

# Linux Server Health Monitor - Day 58

CPU_COUNT=$(nproc)
LOAD_1MIN=$(awk '{print $1}' /proc/loadavg)

MEMORY_USED=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
DISK_USED=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')

echo "===== SERVER HEALTH REPORT ====="
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo "CPU count: $CPU_COUNT"
echo "1-minute load: $LOAD_1MIN"
echo "Memory used: ${MEMORY_USED}%"
echo "Root disk used: ${DISK_USED}%"

echo
echo "===== HEALTH STATUS ====="


if awk -v current_load="$LOAD_1MIN" -v cpu="$CPU_COUNT" \
    'BEGIN {exit !(current_load >= cpu)}'; then
    echo "WARNING: CPU load is at least the CPU count"
    set_status WARNING
    report WARNING "CPU load is at least the CPU count"
else
    echo "OK: CPU load is below the CPU count"
    set_status OK
    report OK "CPU load is below the CPU count"
fi

if [ "$MEMORY_USED" -ge 85 ]; then
    echo "WARNING: Memory usage is at least 85%"
    set_status WARNING
    report WARNING "Memory usage is at least 85%"
else
    echo "OK: Memory usage is below 85%"
    set_status OK
    report OK "Memory usage is below 85%"
fi

if [ "$DISK_USED" -ge 85 ]; then
    echo "CRITICAL: Root disk usage is at least 85%"
    set_status CRITICAL
    report CRITICAL "Root disk usage is at least 85%"
elif [ "$DISK_USED" -ge 70 ]; then
    echo "WARNING: Root disk usage is at least 70%"
    set_status WARNING
    report WARNING "Root disk usage is at least 70%"
else
    echo "OK: Root disk usage is below 70%"
    set_status OK
    report OK "Root disk usage is below 70%"
fi

echo
echo "===== SERVICE HEALTH ====="

SERVICE="nginx"

if systemctl is-active --quiet "$SERVICE"; then
    echo "OK: $SERVICE is active"
    set_status OK
    report OK "$SERVICE is active"
else
    echo "CRITICAL: $SERVICE is not active"
    set_status CRITICAL
    report CRITICAL "$SERVICE is not active"
fi

echo
if [ "$OVERALL_STATUS" -eq 0 ]; then
    echo "OVERALL STATUS: OK"
else
    echo "OVERALL STATUS: ATTENTION REQUIRED"
fi

exit "$OVERALL_STATUS"
