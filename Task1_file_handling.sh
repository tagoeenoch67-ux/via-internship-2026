#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task1_file_handling.sh
# @author       Tagoe Enoch
# @index        4196824
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Demonstrates basic file and directory handling.
# @date         14 September 2026
# -----------------------------------------------------------------

usage() {
    echo "Usage: $0 <target-directory>"
    echo "  <target-directory>  Directory where the file will be created"
    exit 1
}

# Check that exactly one argument was provided
if [ "$#" -ne 1 ] || [ -z "$1" ]; then
    usage
fi

TARGET_DIR="$1"
FILE="$TARGET_DIR/sample.txt"
BACKUP="$TARGET_DIR/sample.txt.bak"

# Step 1: Create the directory if it does not exist
if [ -d "$TARGET_DIR" ]; then
    echo "Directory already exists: $TARGET_DIR"
else
    if mkdir -p "$TARGET_DIR"; then
        echo "Directory created: $TARGET_DIR"
    else
        echo "Error: Could not create directory." >&2
        exit 2
    fi
fi

# Step 2: Create a file and write content to it
if echo "This is the first line of the sample file." > "$FILE"; then
    echo "File created and initial content written."
else
    echo "Error: Could not create or write to the file." >&2
    exit 3
fi

# Step 3: Append additional content
if echo "This is additional content added to the file." >> "$FILE"; then
    echo "Additional content appended successfully."
else
    echo "Error: Could not append content." >&2
    exit 4
fi

# Step 4: Read and display the file contents
echo
echo "File contents:"

if cat "$FILE"; then
    echo "File read successfully."
else
    echo "Error: Could not read the file." >&2
    exit 5
fi

# Step 5: Copy the file to a backup
if cp "$FILE" "$BACKUP"; then
    echo "Backup created: $BACKUP"
else
    echo "Error: Could not create backup." >&2
    exit 6
fi

# Step 6: Check that the original file exists before deleting
if [ -f "$FILE" ]; then
    read -r -p "Delete the original file? (y/n): " answer

    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        if rm "$FILE"; then
            echo "Original file deleted successfully."
        else
            echo "Error: Could not delete the file." >&2
            exit 7
        fi
    else
        echo "Deletion cancelled."
    fi
else
    echo "Error: Original file does not exist." >&2
    exit 8
fi

exit 0