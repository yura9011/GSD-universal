# Kiro Hooks for GSD

This directory contains the Kiro IDE hooks implementation for the Get Shit Done (GSD) framework.

## Overview

Kiro hooks enable automatic validation and rule enforcement, transforming GSD from a command-based system into an intelligent framework with:

- **Auto-validation**: Syntax errors caught immediately
- **Rule enforcement**: Planning Lock prevents premature coding
- **Auto-correction loop**: Claude fixes errors automatically

## Architecture

```
.kiro/
├── settings/
│   └── hooks.json          # Hook configuration
├── scripts/
│   ├── check_planning_lock.py   # PreToolUse: Enforces Planning Lock
│   ├── validate_syntax.py       # PostToolUse: Validates syntax
│   └── utils/
│       ├── hook_input.py        # Parse JSON from stdin
│       └── state_reader.py      # Read STATE.md
└── README.md               # This file
```

## Hooks

### 1. Planning Lock Hook (PreToolUse)

**Purpose**: Enforces GSD's "no code during planning" rule.

**Trigger**: Before Write or Edit operations

**Behavior**:
- Reads `STATE.md` to check current phase
- If status contains "planning" or "DRAFT": blocks operation
- Returns error message to Claude explaining the lock

**Exit codes**:
- `0`: Allow operation (not in planning phase)
- `2`: Block operation (in planning phase)

**Example error**:
```
Planning Lock: Cannot write code during planning phase.
Current status: Planning complete - Ready for execution
Complete SPEC.md and run /plan first.
```

### 2. Syntax Validation Hook (PostToolUse)

**Purpose**: Creates auto-correction loop for zero syntax errors.

**Trigger**: After Write or Edit operations

**Behavior**:
- Detects file type from extension
- Runs appropriate validator:
  - `.py` → `python -m py_compile`
  - `.json` → JSON parser
  - `.md` → Basic structure check
- If validation fails: blocks and reports error to Claude
- Claude automatically fixes the error

**Exit codes**:
- `0`: Validation passed or no validator available
- `2`: Validation failed (syntax error found)

**Example error**:
```
Syntax Error in config.json:
Line 5: Expecting ',' delimiter

Fix the syntax error and try again.
```

**Graceful degradation**: If validator not installed, skips validation with warning.

## How It Works

### Auto-Correction Loop

1. Claude attempts to write/edit a file
2. **PreToolUse hook** checks Planning Lock → allows if not planning
3. File is written
4. **PostToolUse hook** validates syntax
5. If error found: Claude sees error message
6. Claude automatically fixes the error
7. Loop repeats until validation passes

This guarantees zero syntax errors in generated code.

### Planning Lock Enforcement

1. Claude attempts to write code
2. **PreToolUse hook** reads `STATE.md`
3. If in planning phase: operation blocked
4. Claude sees error explaining the lock
5. User must complete planning before coding

This enforces GSD's core rule: "No code until SPEC finalized".

## Configuration

Hooks are configured in `.kiro/settings/hooks.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "python .kiro/scripts/check_planning_lock.py",
            "timeout": 5
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "python .kiro/scripts/validate_syntax.py",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

## Adding New Hooks

### 1. Create Hook Script

```python
#!/usr/bin/env python3
import sys
import os

# Add utils to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'utils'))

from hook_input import read_hook_input
from state_reader import read_state

def main():
    # Read hook input
    hook_data = read_hook_input()
    
    # Your validation logic here
    
    # Exit codes:
    # 0 = allow operation
    # 2 = block operation (error to Claude)
    sys.exit(0)

if __name__ == "__main__":
    main()
```

### 2. Register in hooks.json

```json
{
  "matcher": "ToolName",
  "hooks": [
    {
      "type": "command",
      "command": "python .kiro/scripts/your_hook.py",
      "timeout": 10
    }
  ]
}
```

### 3. Test

Create test input JSON and run:
```bash
echo '{"tool_name":"Write","tool_input":{"file_path":"test.py"}}' | python .kiro/scripts/your_hook.py
```

## Utilities

### hook_input.py

Parse JSON from stdin (Kiro hook input):

```python
from hook_input import read_hook_input, get_file_path, get_tool_name

hook_data = read_hook_input()
file_path = get_file_path(hook_data)
tool_name = get_tool_name(hook_data)
```

### state_reader.py

Read and parse STATE.md:

```python
from state_reader import read_state, is_planning_phase

state = read_state()
print(state['status'])  # Current status
print(state['phase'])   # Current phase

if is_planning_phase():
    print("In planning phase")
```

## Troubleshooting

### Hook not triggering

1. Check hooks.json syntax is valid JSON
2. Verify matcher pattern matches tool name
3. Check script has correct path
4. Test script manually with sample input

### Validation failing incorrectly

1. Check validator is installed (`python -m py_compile --help`)
2. Test validator directly on file
3. Check file path is correct
4. Review error message for details

### Planning Lock not working

1. Verify STATE.md exists
2. Check status field format
3. Test state_reader.py directly: `python .kiro/scripts/utils/state_reader.py`
4. Ensure STATE.md is updated after planning

## Cross-Platform Notes

### Windows

- Uses PowerShell or cmd
- Python scripts work identically
- File paths use backslashes (handled automatically)

### Unix (Mac/Linux)

- Uses bash
- Python scripts work identically
- File paths use forward slashes

### Python Compatibility

- Requires Python 3.6+
- Uses only standard library (no external dependencies)
- Cross-platform by design

## References

- [Kiro Hooks Documentation](https://code.claude.com/docs/hooks)
- [GSD System Documentation](../.gsd/SYSTEM.md)
- [Hook Input Schema](https://code.claude.com/docs/hooks#hook-input)

## Testing

Run the test suite:

```bash
python -m unittest discover .kiro/scripts/tests
```

Individual tests:

```bash
python -m unittest .kiro/scripts/tests/test_planning_lock.py
python -m unittest .kiro/scripts/tests/test_syntax_validation.py
python -m unittest .kiro/scripts/tests/test_utils.py
```

## Version

Current version: 1.0.0 (Phase 1 - Hooks Foundation)
