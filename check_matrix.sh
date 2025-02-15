#!/bin/bash

# Check if at least one version argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <version1> [version2] [version3] ..."
    echo "Example: $0 1.2.1 1.3.0.rc1"
    exit 1
fi

VERSIONS=("$@")
TOTAL_TESTS=$((${#VERSIONS[@]} * ${#VERSIONS[@]}))
CURRENT=0

echo "Running compatibility matrix tests for versions: ${VERSIONS[*]}"
echo "Total test combinations: $TOTAL_TESTS"
echo

# Use the results directory
RESULTS_DIR="results"
mkdir -p "$RESULTS_DIR"

# Write header to summary file with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SUMMARY_FILE="$RESULTS_DIR/summary_$TIMESTAMP.txt"
echo "MCP Compatibility Matrix Test Results" > "$SUMMARY_FILE"
echo "Date: $(date)" >> "$SUMMARY_FILE"
echo "Versions tested: ${VERSIONS[*]}" >> "$SUMMARY_FILE"
echo >> "$SUMMARY_FILE"
echo "| Client Version | Server Version | Status |" >> "$SUMMARY_FILE"
echo "| -------------- | -------------- | ------ |" >> "$SUMMARY_FILE"

# Function to run a single test and capture the result
run_test() {
    local client_version=$1
    local server_version=$2
    local output_file="$RESULTS_DIR/client_${client_version}_server_${server_version}.log"
    
    CURRENT=$((CURRENT + 1))
    echo "[$CURRENT/$TOTAL_TESTS] Testing client $client_version with server $server_version..."
    
    # Run the test and capture output
    if ./check_versions.sh "$client_version" "$server_version" > "$output_file" 2>&1; then
        echo "  ✅ Success"
        echo "| $client_version | $server_version | ✅ Success |" >> "$SUMMARY_FILE"
        return 0
    else
        echo "  ❌ Failed"
        echo "| $client_version | $server_version | ❌ Failed |" >> "$SUMMARY_FILE"
        return 1
    fi
}

# Run tests for all combinations
for client_version in "${VERSIONS[@]}"; do
    for server_version in "${VERSIONS[@]}"; do
        run_test "$client_version" "$server_version"
    done
done

echo
echo "All tests completed. Results saved in $RESULTS_DIR/"
echo "Summary available in $SUMMARY_FILE"