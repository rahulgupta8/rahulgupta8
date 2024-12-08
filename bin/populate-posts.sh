#!/bin/bash

# This script is written to copy the presentations markdown and populate the posts markdown for the talks section.
# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_file> <dest_file>"
    exit 1
fi

# Assign arguments to variables
source_file="$1"
dest_file="$2"
marker="<!--MARKER-->"

# Check if source file exists
if [ ! -f "$source_file" ]; then
    echo "Error: Source file '$source_file' does not exist."
    exit 1
fi

# Find the line number of the marker in the source file
marker_line=$(grep -n "$marker" "$source_file" | cut -d: -f1)

# Check if marker was found
if [ -z "$marker_line" ]; then
    echo "Error: Marker '$marker' not found in source file."
    exit 1
fi

# Extract content from after the marker line to the end of the file
extracted_content=$(tail -n +$((marker_line + 1)) "$source_file")

# Find the line number of the marker in the destination file
dest_marker_line=$(grep -n "$marker" "$dest_file" | cut -d: -f1)

# Check if marker was found in destination file
if [ -z "$dest_marker_line" ]; then
    echo "Error: Marker '$marker' not found in destination file."
    exit 1
fi

# Create a temporary file to handle the insertion
temp_file=$(mktemp)

# Copy the content up to the marker line
head -n "$dest_marker_line" "$dest_file" > "$temp_file"

# Add the extracted content
echo "$extracted_content" >> "$temp_file"

# Replace the destination file with the modified content
mv "$temp_file" "$dest_file"

echo "Content successfully extracted and inserted."
