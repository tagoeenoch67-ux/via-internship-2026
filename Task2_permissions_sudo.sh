#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task2_permissions_sudo.sh
# @author       Tagoe Enoch
# @index        4196824
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Reports and changes file permissions and demonstrates sudo/root handling.
# @date         14 September 2026
# -----------------------------------------------------------------

usage() {
    echo "Usage: $0 <file-path>"
    echo "  <file-path>  path to the file whose permissions will be checked and changed"
    exit 1
}
# Check that exactly one file path was provided.
# Show help when -h or --help is provided.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

# Check that exactly one file path was provided.
if [[ $# -ne 1 ]]; then
    usage
fi
# Check that the specified file exists before trying to change it.
if [[ ! -f "$1" ]]; then
    echo "Error: File '$1' does not exist." >&2
    exit 2
fi


FILE="$1"
# Get the current permissions in symbolic and numeric form.
PERMISSIONS=$(stat -c "%A" "$FILE")
NUMERIC=$(stat -c "%a" "$FILE")

if [[ $? -ne 0 ]]; then
    echo "Error: Could not read the file permissions." >&2
    exit 3
fi

echo "Current file: $FILE"
echo "Symbolic permissions: $PERMISSIONS"
echo "Numeric permissions: $NUMERIC"


if chmod 644 "$FILE"; then
    echo "Success: Permissions changed to 644."
else
    echo "Error: Failed to change permissions to 644." >&2
    exit 4
fi
# Demonstrate symbolic chmod syntax by adding execute permission for the owner.
if chmod u+x "$FILE"; then
    echo "Success: Execute permission added for the owner."
else
    echo "Error: Failed to add execute permission." >&2
    exit 5
fi
# Check whether the script is running with root privileges.
if [[ "$(id -u)" -eq 0 ]]; then
    echo "Running with root privileges."

    # Attempt to change the file owner to the current user.
    if chown "$(whoami)" "$FILE"; then
        echo "Success: File ownership changed."
    else
        echo "Error: Failed to change file ownership." >&2
        exit 6
    fi
else
    echo "Root privileges not available."
    echo "Skipping ownership change because root privileges are required."
fi
# Report the final permissions so the before-and-after changes are visible.
FINAL_PERMISSIONS=$(stat -c "%A" "$FILE")
FINAL_NUMERIC=$(stat -c "%a" "$FILE")

if [[ $? -ne 0 ]]; then
    echo "Error: Could not read the final file permissions." >&2
    exit 7
fi

echo "Final file permissions:"
echo "Symbolic permissions: $FINAL_PERMISSIONS"
echo "Numeric permissions: $FINAL_NUMERIC"

exit 0

