#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <old> <new>"
    exit 1
fi

old="$1"
new="$2"
script_name=$(basename "$0")

# Check for empty arguments
if [ -z "$old" ] || [ -z "$new" ]; then
    echo "Error: Arguments cannot be empty."
    exit 1
fi

# Escape special characters for sed
old_escaped=$(sed 's/[^^]/[&]/g; s/\^/\\^/g' <<< "$old")
new_escaped=$(sed 's/[&/\]/\\&/g' <<< "$new")

# Rename files and directories
find . -depth -name "*$old*" ! -name "$script_name" -execdir bash -c '
    old="$1"
    new="$2"
    for item; do
        if [ "$item" != "./$3" ]; then
            new_item=$(echo "$item" | sed "s/$old/$new/g")
            mv -v "$item" "$new_item"
        fi
    done
' bash "$old_escaped" "$new_escaped" "$script_name" {} +

# Replace content in files
grep -rl --exclude="$script_name" "$old" . | while read -r file; do
    sed -i "s/$old_escaped/$new_escaped/g" "$file"
done

echo "Renaming and content replacement completed."
