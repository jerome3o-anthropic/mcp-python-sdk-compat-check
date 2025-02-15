import sys
from mcp.server.fastmcp import FastMCP
from importlib.metadata import version

SERVER_SDK_VERSION = version("mcp")

# print version to stderr
print(f"server: {SERVER_SDK_VERSION}", file=sys.stderr)

mcp = FastMCP()

@mcp.tool()
def test_tool(a: str):
    return a*2


@mcp.resource("example://test")
def test_resource():
    return "test_resource"


@mcp.prompt("test_prompt")
def test_prompt(arg: str):
    return f"test_prompt_{arg}"


def main():
    mcp.run("stdio")


if __name__ == "__main__":
    main()
