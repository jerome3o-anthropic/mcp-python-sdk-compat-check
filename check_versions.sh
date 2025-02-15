#!/bin/bash

# Check if client and server version arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <client-version> <server-version>"
    echo "Example: $0 1.3.0.rc1 1.2.1"
    exit 1
fi

CLIENT_VERSION=$1
SERVER_VERSION=$2

./add_version.sh "$CLIENT_VERSION"
./add_version.sh "$SERVER_VERSION"

# Run the client with the specified server version
CLIENT_VENV_DIR="venvs/$CLIENT_VERSION"
./"$CLIENT_VENV_DIR"/bin/python ./client.py "$SERVER_VERSION"