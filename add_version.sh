#!/bin/bash

# Check if version argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <mcp-version>"
    echo "Example: $0 1.2.1"
    exit 1
fi

MCP_VERSION=$1
VENV_DIR="venvs/$MCP_VERSION"

# Check if virtual environment already exists
if [ -d "$VENV_DIR" ]; then
    echo "Virtual environment for MCP version $MCP_VERSION already exists at $VENV_DIR"
    exit 0
fi

# Create virtual environment
uv venv --seed "$VENV_DIR" > /dev/null 2>&1

# Add MCP version
if ! ./"$VENV_DIR"/bin/python -m pip install --index=https://pypi.org/simple mcp==$MCP_VERSION > /dev/null 2>&1; then
    echo "Failed to install MCP version $MCP_VERSION. Removing venv..."
    rm -rf "$VENV_DIR"
    exit 1
fi

echo "Added MCP version $MCP_VERSION in directory $VENV_DIR"