#!/bin/bash

# Function to show help message
show_help() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    echo "Options:"
    echo "  -n   Show line numbers"
    echo "  -v   Invert match (show non-matching lines)"
    echo "  --help Show this help message"
}

# Check if no arguments given
if [[ $# -lt 1 ]]; then
    echo "Error: No arguments provided."
    show_help
    exit 1
fi

# Variables
show_line_numbers=false
invert_match=false

# Handle --help
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Parse options
while getopts ":nv" opt; do
  case $opt in
    n)
      show_line_numbers=true
      ;;
    v)
      invert_match=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      show_help
      exit 1
      ;;
  esac
done

# Shift parsed options
shift $((OPTIND-1))

# Now the first non-option argument is the search string
search_string="$1"
file="$2"

# Check if search string and file are provided
if [[ -z "$search_string" || -z "$file" ]]; then
    echo "Error: Missing search string or filename."
    show_help
    exit 1
fi

# Check if file exists
if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Build the grep command
cmd="grep -i"

if $invert_match; then
    cmd="$cmd -v"
fi

if $show_line_numbers; then
    cmd="$cmd -n"
fi

# Run the command
$cmd "$search_string" "$file"
