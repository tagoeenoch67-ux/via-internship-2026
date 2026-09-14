#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task5_crud_app.sh
# @author       Tagoe Enoch
# @index        4196824
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Provides a menu-driven todo list with create, read, update, and delete operations.
# @date         14 September 2026
# -----------------------------------------------------------------

DATA_FILE="todo.txt"

usage() {
    echo "Usage: $0"
    echo "  A simple menu-driven Todo List application."
    echo "  Options: Create, Read, Update, Delete, and Exit."
    exit 1
}

# Show help when -h or --help is provided.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

# This application does not accept other command-line arguments.
if [[ $# -ne 0 ]]; then
    echo "Error: This script does not accept arguments." >&2
    usage
fi

# Create the data file if it does not exist.
if [[ ! -f "$DATA_FILE" ]]; then
    touch "$DATA_FILE" || {
        echo "Error: Could not create $DATA_FILE." >&2
        exit 3
    }
fi

# Create a new task.
create_task() {
    echo
    echo "=== Create Task ==="
    read -r -p "Enter task: " task

    # Make sure the task is not empty.
    if [[ -z "$task" ]]; then
        echo "Error: Task cannot be empty." >&2
        return 1
    fi

    echo "$task" >> "$DATA_FILE"

    if [[ $? -ne 0 ]]; then
        echo "Error: Could not save the task." >&2
        return 2
    fi

    echo "Task created successfully."
    return 0
}

# Display all tasks.
read_tasks() {
    echo
    echo "=== Todo List ==="

    if [[ ! -s "$DATA_FILE" ]]; then
        echo "No tasks found."
        return 0
    fi

    nl -w2 -s". " "$DATA_FILE"

    if [[ $? -ne 0 ]]; then
        echo "Error: Could not read the task list." >&2
        return 1
    fi

    return 0
}

# Update an existing task.
update_task() {
    echo
    echo "=== Update Task ==="

    if [[ ! -s "$DATA_FILE" ]]; then
        echo "No tasks found."
        return 0
    fi

    read_tasks

    read -r -p "Enter the task number to update: " number

    if [[ ! "$number" =~ ^[0-9]+$ ]]; then
        echo "Error: Please enter a valid task number." >&2
        return 1
    fi

    total=$(wc -l < "$DATA_FILE")

    if (( number < 1 || number > total )); then
        echo "Error: Task number not found." >&2
        return 1
    fi

    read -r -p "Enter the new task: " new_task

    if [[ -z "$new_task" ]]; then
        echo "Error: Task cannot be empty." >&2
        return 1
    fi

    # Create a backup before modifying the task list.
    cp "$DATA_FILE" "$DATA_FILE.bak"

    if [[ $? -ne 0 ]]; then
        echo "Error: Could not create backup." >&2
        return 2
    fi

    sed -i "${number}c\\${new_task}" "$DATA_FILE"

    if [[ $? -ne 0 ]]; then
        echo "Error: Could not update the task." >&2
        return 2
    fi

    echo "Task updated successfully."
    return 0
}

# Delete an existing task.
delete_task() {
    echo
    echo "=== Delete Task ==="

    if [[ ! -s "$DATA_FILE" ]]; then
        echo "No tasks found."
        return 0
    fi

    read_tasks

    read -r -p "Enter the task number to delete: " number

    if [[ ! "$number" =~ ^[0-9]+$ ]]; then
        echo "Error: Please enter a valid task number." >&2
        return 1
    fi

    total=$(wc -l < "$DATA_FILE")

    if (( number < 1 || number > total )); then
        echo "Error: Task number not found." >&2
        return 1
    fi

    # Create a backup before deleting the task.
    cp "$DATA_FILE" "$DATA_FILE.bak"

    if [[ $? -ne 0 ]]; then
        echo "Error: Could not create backup." >&2
        return 2
    fi

    sed -i "${number}d" "$DATA_FILE"

    if [[ $? -ne 0 ]]; then
        echo "Error: Could not delete the task." >&2
        return 2
    fi

    echo "Task deleted successfully."
    return 0
}

# Main menu.
while true; do
    echo
    echo "=========================="
    echo "       TODO LIST"
    echo "=========================="
    echo "1. Create task"
    echo "2. View tasks"
    echo "3. Update task"
    echo "4. Delete task"
    echo "5. Exit"
    echo "=========================="

    read -r -p "Choose an option: " choice

    case "$choice" in
        1)
            create_task
            ;;
        2)
            read_tasks
            ;;
        3)
            update_task
            ;;
        4)
            delete_task
            ;;
        5)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Error: Invalid option. Please choose 1-5." >&2
            ;;
    esac
done