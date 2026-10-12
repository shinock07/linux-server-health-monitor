#!/bin/bash

REPORT_DIR="$HOME/day59-lab/reports"
mkdir -p "$REPORT_DIR" || exit 3

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
REPORT_FILE="$REPORT_DIR/report-test-$TIMESTAMP.log"

if ! touch "$REPORT_FILE"; then
    echo "ERROR: Cannot create report file" >&2
    exit 3
fi

report() {
    local level="$1"
    shift

    local message
    message=$(printf '[%s] %-8s %s' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$level" "$*")

    printf '%s\n' "$message" | tee -a "$REPORT_FILE"
}

report INFO "Health monitor started"
report WARNING "Memory usage is high"
report CRITICAL "Disk usage is critical"

echo "Report saved to: $REPORT_FILE"
