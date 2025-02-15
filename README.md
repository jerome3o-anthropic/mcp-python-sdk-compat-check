# MCP Compatibility Tester

This tool helps check if servers and clients from different MCP Python SDK versions are compatible with each other.

## Overview

The MCP Compatibility Tester allows you to:

1. Install multiple versions of the MCP SDK in isolated virtual environments
2. Test client-server compatibility between different SDK versions
3. Run compatibility tests across a matrix of versions
4. Generate reports with test results

## Scripts

### add_version.sh

Installs a specific MCP SDK version in its own virtual environment.

```bash
./add_version.sh <mcp-version>
```

Example:
```bash
./add_version.sh 1.2.1
```

This creates a virtual environment in `venvs/1.2.1/` with the specified MCP version installed.

### check_versions.sh

Tests compatibility between a specific client version and server version.

```bash
./check_versions.sh <client-version> <server-version>
```

Example:
```bash
./check_versions.sh 1.3.0.rc1 1.2.1
```

This tests if a client using MCP 1.3.0.rc1 can successfully communicate with a server using MCP 1.2.1.

### check_matrix.sh

Runs compatibility tests for all combinations of the provided versions.

```bash
./check_matrix.sh <version1> [version2] [version3] ...
```

Example:
```bash
./check_matrix.sh 1.2.1 1.3.0.rc1
```

This will test all four combinations:
- Client 1.2.1 with Server 1.2.1
- Client 1.2.1 with Server 1.3.0.rc1
- Client 1.3.0.rc1 with Server 1.2.1
- Client 1.3.0.rc1 with Server 1.3.0.rc1

Results are saved in the `results/` directory:
- Individual test logs are saved as `results/client_<version>_server_<version>.log`
- A summary report is generated as `results/summary_<timestamp>.txt`

## Test Implementation

The compatibility test:
1. Initializes a session between client and server
2. Lists available tools, resources, and prompts
3. Calls example methods for each
4. Reports success or failure

## Example Workflow

```bash
# Add the versions you want to test
./add_version.sh 1.2.1
./add_version.sh 1.3.0.rc1

# Run the compatibility matrix test
./check_matrix.sh 1.2.1 1.3.0.rc1

# Check the results
cat results/summary_*.txt
```

This will show you which version combinations are compatible and which ones fail.