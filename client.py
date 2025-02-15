from pathlib import Path
from pydantic import AnyUrl
from mcp.client.stdio import StdioServerParameters, stdio_client
from mcp.client.session import ClientSession
from importlib.metadata import version
import sys

CLIENT_SDK_VERSION = version("mcp")

# Require server version from command line argument
if len(sys.argv) > 1:
    SERVER_SDK_VERSION = sys.argv[1]
else:
    print("Error: Server version must be provided as a command line argument")
    print("Usage: python client.py <server-version>")
    sys.exit(1)

print(f"client: {CLIENT_SDK_VERSION}")
print(f"server: {SERVER_SDK_VERSION}")

parent_folder = Path(__file__).parent
server_file = str(parent_folder / "server.py")
venvs_folder = parent_folder / "venvs"
command = str(venvs_folder / SERVER_SDK_VERSION / "bin" / "python")

server_params = StdioServerParameters(
    command=command,
    args=[server_file],
)

async def run():
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            # Initialize the connection
            await session.initialize()

            # List available prompts
            list_tools_result = await session.list_tools()

            print(list_tools_result.tools)

            # Call a tool
            tool_call_result = await session.call_tool("test_tool", {"a": "test"})

            print(tool_call_result.content)

            # List available resources
            list_resources_result = await session.list_resources()

            print(list_resources_result.resources)

            # Read a resource
            resource_result = await session.read_resource(AnyUrl("example://test"))

            print(resource_result.contents)

            # List available prompts
            list_prompts_result = await session.list_prompts()

            print(list_prompts_result.prompts)

            # Call a prompt
            prompt_call_result = await session.get_prompt("test_prompt", {"arg": "test"})

            print(prompt_call_result.messages)


if __name__ == "__main__":
    import asyncio
    asyncio.run(run())