#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task3_pipes_redirection.sh
# @author       Tagoe Enoch
# @index        4196824
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Generates fake log data and analyzes it using pipes and redirection.
# @date         14 September 2026
# -----------------------------------------------------------------

usage() {
    echo "Usage: $0"
    echo "  This script generates fake log data and analyzes it."
    exit 1
}

# Show help when -h or --help is provided.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

# This script does not require any arguments.
if [[ $# -ne 0 ]]; then
    echo "Error: This script does not accept arguments." >&2
    usage
fi


# Create a temporary log file and remove it automatically when the script ends.
LOG_FILE=$(mktemp)

if [[ $? -ne 0 ]]; then
    echo "Error: Could not create temporary log file." >&2
    exit 2
fi

# Remove the temporary log file when the script finishes.
trap 'rm -f "$LOG_FILE"' EXIT

# Generate 50 fake log lines using a heredoc.
cat > "$LOG_FILE" <<'EOF'
2026-09-14 10:00:01 INFO  192.168.1.10 User logged in
2026-09-14 10:00:05 INFO  192.168.1.11 Dashboard opened
2026-09-14 10:00:10 WARN  192.168.1.12 High memory usage
2026-09-14 10:00:15 ERROR 192.168.1.10 Database connection failed
2026-09-14 10:00:20 INFO  192.168.1.13 File uploaded
2026-09-14 10:00:25 INFO  192.168.1.10 User logged out
2026-09-14 10:00:30 WARN  192.168.1.11 Slow response detected
2026-09-14 10:00:35 ERROR 192.168.1.12 Authentication failed
2026-09-14 10:00:40 INFO  192.168.1.14 Report generated
2026-09-14 10:00:45 INFO  192.168.1.10 Settings changed
2026-09-14 10:01:01 INFO  192.168.1.11 User logged in
2026-09-14 10:01:05 WARN  192.168.1.12 Disk space getting low
2026-09-14 10:01:10 ERROR 192.168.1.13 Service unavailable
2026-09-14 10:01:15 INFO  192.168.1.14 Page viewed
2026-09-14 10:01:20 INFO  192.168.1.10 File downloaded
2026-09-14 10:01:25 WARN  192.168.1.11 Too many requests
2026-09-14 10:01:30 ERROR 192.168.1.12 Permission denied
2026-09-14 10:01:35 INFO  192.168.1.13 User logged in
2026-09-14 10:01:40 INFO  192.168.1.14 Profile updated
2026-09-14 10:01:45 INFO  192.168.1.10 User logged out
2026-09-14 10:02:01 WARN  192.168.1.11 Network delay detected
2026-09-14 10:02:05 INFO  192.168.1.12 Search completed
2026-09-14 10:02:10 ERROR 192.168.1.13 Database timeout
2026-09-14 10:02:15 INFO  192.168.1.14 Message sent
2026-09-14 10:02:20 INFO  192.168.1.10 User logged in
2026-09-14 10:02:25 WARN  192.168.1.12 CPU usage high
2026-09-14 10:02:30 ERROR 192.168.1.11 File not found
2026-09-14 10:02:35 INFO  192.168.1.13 Data processed
2026-09-14 10:02:40 INFO  192.168.1.14 User logged out
2026-09-14 10:02:45 INFO  192.168.1.10 Report downloaded
2026-09-14 10:03:01 WARN  192.168.1.11 Memory usage high
2026-09-14 10:03:05 INFO  192.168.1.12 User logged in
2026-09-14 10:03:10 ERROR 192.168.1.13 Network failure
2026-09-14 10:03:15 INFO  192.168.1.14 Dashboard opened
2026-09-14 10:03:20 INFO  192.168.1.10 File uploaded
2026-09-14 10:03:25 WARN  192.168.1.12 Slow query detected
2026-09-14 10:03:30 ERROR 192.168.1.11 Server error
2026-09-14 10:03:35 INFO  192.168.1.13 Settings changed
2026-09-14 10:03:40 INFO  192.168.1.14 User logged in
2026-09-14 10:03:45 INFO  192.168.1.10 User logged out
2026-09-14 10:04:01 WARN  192.168.1.11 High CPU usage
2026-09-14 10:04:05 INFO  192.168.1.12 Report generated
2026-09-14 10:04:10 ERROR 192.168.1.13 Access denied
2026-09-14 10:04:15 INFO  192.168.1.14 File downloaded
2026-09-14 10:04:20 INFO  192.168.1.10 User logged in
2026-09-14 10:04:25 WARN  192.168.1.12 Low disk space
2026-09-14 10:04:30 ERROR 192.168.1.11 Connection refused
2026-09-14 10:04:35 INFO  192.168.1.13 Search completed
2026-09-14 10:04:40 INFO  192.168.1.14 User logged out
2026-09-14 10:04:45 INFO  192.168.1.10 Backup completed
EOF
# Count the total number of log lines using wc.
TOTAL_LINES=$(wc -l < "$LOG_FILE")

if [[ $? -ne 0 ]]; then
    echo "Error: Could not count log lines." >&2
    exit 3
fi

# Count each log level using grep and pipes.
INFO_COUNT=$(grep -c "INFO" "$LOG_FILE")
WARN_COUNT=$(grep -c "WARN" "$LOG_FILE")
ERROR_COUNT=$(grep -c "ERROR" "$LOG_FILE")

if [[ $? -ne 0 ]]; then
    echo "Error: Could not count log levels." >&2
    exit 4
fi

# Extract IP addresses, count them, and display the top three.
TOP_IPS=$(awk '{print $4}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -3)

if [[ $? -ne 0 ]]; then
    echo "Error: Could not calculate top IP addresses." >&2
    exit 5
fi

# Store all ERROR log lines.
ERROR_LINES=$(grep "ERROR" "$LOG_FILE")

if [[ $? -ne 0 ]]; then
    echo "Error: Could not extract ERROR lines." >&2
    exit 6
fi
# Write the analysis summary to results.txt.
{
    echo "===== LOG ANALYSIS SUMMARY ====="
    echo "Total log lines: $TOTAL_LINES"
    echo "INFO entries: $INFO_COUNT"
    echo "WARN entries: $WARN_COUNT"
    echo "ERROR entries: $ERROR_COUNT"
    echo
    echo "Top 3 IP addresses:"
    echo "$TOP_IPS"
    echo
    echo "===== ALL ERROR LINES ====="
    echo "$ERROR_LINES"
} > results.txt

if [[ $? -ne 0 ]]; then
    echo "Error: Could not write results.txt." >&2
    exit 7
fi

# Create errors.log for recording pipeline or processing errors.
: > errors.log

if [[ $? -ne 0 ]]; then
    echo "Error: Could not create errors.log." >&2
    exit 8
fi

echo "Analysis completed successfully."
echo "Results saved to results.txt"
echo "Errors log saved to errors.log"

exit 0