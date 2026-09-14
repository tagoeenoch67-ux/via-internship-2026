#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task4_return_codes_error_handling.sh
# @author       Tagoe Enoch
# @index        4196824
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Demonstrates return codes, error handling, and cleanup of temporary files.
# @date         14 September 2026
# -----------------------------------------------------------------
usage() {
    echo "Usage: $0"
    echo "  This script demonstrates return codes, error handling, and cleanup."
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

# Exit code scheme:
# 0 = success
# 1 = invalid arguments
# 2 = required command is missing
# 3 = file operation failed
# 4 = general check failed

# Check the exit status of the previous command.
check_status() {
    local status=$1
    local message=$2

    if [[ $status -eq 0 ]]; then
        echo "SUCCESS: $message"
    else
        echo "ERROR: $message (exit code: $status)" >&2
        return "$status"
    fi
}

# Create a temporary file for testing.
TEMP_FILE=$(mktemp)

if [[ $? -ne 0 ]]; then
    echo "ERROR: Could not create temporary file." >&2
    exit 3
fi

# Remove the temporary file automatically when the script exits.
cleanup() {
    rm -f "$TEMP_FILE"
}

trap cleanup EXIT

# Check 1: Verify that Bash is available.
command -v bash > /dev/null 2>&1
status=$?
check_status "$status" "Bash command is available" || exit 2

# Check 2: Write test data to the temporary file.
echo "Task 4 test data" > "$TEMP_FILE"
status=$?
check_status "$status" "Writing to temporary file" || exit 3

# Check 3: Verify that the temporary file exists.
[[ -f "$TEMP_FILE" ]]
status=$?
check_status "$status" "Temporary file exists" || exit 4


# Check 4: Read the temporary file successfully.
cat "$TEMP_FILE" > /dev/null
status=$?
check_status "$status" "Reading temporary file" || exit 4

# All checks passed successfully.
echo "All checks completed successfully."
exit 0

