#!/bin/bash

# ─────────────────────────────────────────
# Linux Log Analysis Automation Script
# Author: Jayesh Thombare
# Description: Parses system logs, extracts
# error patterns and generates a report
# ─────────────────────────────────────────

LOGFILE="/var/log/messages"
REPORT="$HOME/linux-projects/log-analysis/log_report.txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "====================================" > "$REPORT"
echo "Log Analysis Report" >> "$REPORT"
echo "Generated: $DATE" >> "$REPORT"
echo "====================================" >> "$REPORT"

# ── Check if log file exists ──
if [ ! -f "$LOGFILE" ]; then
    echo "Log file $LOGFILE not found. Using journalctl instead." >> "$REPORT"
    journalctl --no-pager > /tmp/system_logs.txt
    LOGFILE="/tmp/system_logs.txt"
fi

# ── Extract ERROR entries ──
echo "" >> "$REPORT"
echo "── ERRORS FOUND ──" >> "$REPORT"
grep -i "error" "$LOGFILE" | tail -20 >> "$REPORT"

# ── Extract WARNING entries ──
echo "" >> "$REPORT"
echo "── WARNINGS FOUND ──" >> "$REPORT"
grep -i "warning" "$LOGFILE" | tail -20 >> "$REPORT"

# ── Extract FAILED entries ──
echo "" >> "$REPORT"
echo "── FAILED SERVICES ──" >> "$REPORT"
grep -i "failed" "$LOGFILE" | tail -20 >> "$REPORT"

# ── Count occurrences ──
echo "" >> "$REPORT"
echo "── SUMMARY ──" >> "$REPORT"
ERROR_COUNT=$(grep -ic "error" "$LOGFILE")
WARNING_COUNT=$(grep -ic "warning" "$LOGFILE")
FAILED_COUNT=$(grep -ic "failed" "$LOGFILE")

echo "Total Errors   : $ERROR_COUNT" >> "$REPORT"
echo "Total Warnings : $WARNING_COUNT" >> "$REPORT"
echo "Total Failed   : $FAILED_COUNT" >> "$REPORT"
echo "" >> "$REPORT"
echo "Report saved to: $REPORT"
echo "Analysis complete."
