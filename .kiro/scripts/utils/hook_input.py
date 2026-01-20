#!/usr/bin/env python3
"""
Hook Input Parser

Utilities for parsing JSON input from Kiro hooks via stdin.
"""

import json
import sys
from typing import Dict, Any, Optional


def read_hook_input() -> Dict[str, Any]:
    """
    Read and parse hook input JSON from stdin.
    
    Returns:
        dict: Parsed hook input with fields like tool_name, tool_input, etc.
        
    Raises:
        SystemExit: If JSON parsing fails (exits with code 1)
    """
    try:
        input_data = json.load(sys.stdin)
        return input_data
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Error reading hook input: {e}", file=sys.stderr)
        sys.exit(1)


def get_tool_name(hook_input: Dict[str, Any]) -> str:
    """Extract tool name from hook input."""
    return hook_input.get("tool_name", "")


def get_tool_input(hook_input: Dict[str, Any]) -> Dict[str, Any]:
    """Extract tool_input dict from hook input."""
    return hook_input.get("tool_input", {})


def get_file_path(hook_input: Dict[str, Any]) -> Optional[str]:
    """
    Extract file path from hook input.
    
    Works for Write and Edit tools which have file_path in tool_input.
    """
    tool_input = get_tool_input(hook_input)
    return tool_input.get("file_path")


def get_command(hook_input: Dict[str, Any]) -> Optional[str]:
    """
    Extract command from hook input.
    
    Works for Bash tool which has command in tool_input.
    """
    tool_input = get_tool_input(hook_input)
    return tool_input.get("command")


if __name__ == "__main__":
    # Test mode: read and display parsed input
    data = read_hook_input()
    print(f"Tool: {get_tool_name(data)}")
    print(f"File: {get_file_path(data)}")
    print(f"Command: {get_command(data)}")
