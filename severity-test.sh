#!/bin/bash

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

set_status CRITICAL
set_status OK
echo "After CRITICAL then OK: $OVERALL_STATUS"

OVERALL_STATUS=0
set_status WARNING
set_status OK
echo "After WARNING then OK: $OVERALL_STATUS"

OVERALL_STATUS=0
set_status UNKNOWN
set_status CRITICAL
echo "After UNKNOWN then CRITICAL: $OVERALL_STATUS"
