#!/bin/bash

echo "--------------------------------------"
echo "   Open-Source EDA Tools Path Finder  "
echo "--------------------------------------"

TOOLS=(
    "yosys"
    "openroad"
    "OpenLane"
    "magic"
    "netgen"
    "sta"
    "klayout"
    "verilator"
    "cvc"
    "tclsh"
    "python3"
    "make"
    "docker"
)

SEARCH_DIRS="/usr/bin /usr/local/bin /usr/lib /opt $HOME"

for tool in "${TOOLS[@]}"; do
    
    # Default system path check
    tool_path=$(command -v "$tool")
    
    # if not found, deep search for Executable File
    if [ -z "$tool_path" ]; then
        tool_path=$(find $SEARCH_DIRS -type f -executable -name "$tool" 2>/dev/null | head -n 1)
    fi
    
    # if not, deep search for Directory
    if [ -z "$tool_path" ]; then
        tool_path=$(find $SEARCH_DIRS -type d -name "$tool" 2>/dev/null | head -n 1)
    fi
    
    # Final Output Print
    if [ -n "$tool_path" ]; then
        printf "[FOUND] %-15s -> %s\n" "$tool" "$tool_path"
    else
        printf "[MISSING] %-13s -> Not found in system!\n" "$tool"
    fi
done

echo "_______________________________________________________________"
