from mcp.server.fastmcp import FastMCP

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
