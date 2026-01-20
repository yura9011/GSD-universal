# GSD Slash Commands

Kiro-specific slash commands for GSD framework.

## Overview

These commands provide Kiro-native access to GSD workflows with:
- Argument hints for autocomplete
- Bash pre-execution for context
- File references with @ syntax
- Tool restrictions for safety

## Command Categories

### Core Workflow (6)
- `/new-project` - Initialize new GSD project
- `/map` - Analyze codebase
- `/plan [N]` - Create execution plans
- `/execute [N]` - Implement phase
- `/verify [N]` - Validate implementation
- `/progress` - Show current status

### Phase Management (6)
Commands in `phase/` subdirectory:
- `/discuss-phase [N]` - Clarify scope
- `/research-phase [N]` - Technical research
- `/add-phase` - Add new phase
- `/insert-phase [N]` - Insert at position
- `/remove-phase [N]` - Remove phase
- `/list-phase-assumptions` - List assumptions

### Milestone Management (4)
Commands in `milestone/` subdirectory:
- `/new-milestone [name]` - Create milestone
- `/complete-milestone` - Archive milestone
- `/audit-milestone` - Review quality
- `/plan-milestone-gaps` - Plan gap closure

### Session Management (4)
Commands in `session/` subdirectory:
- `/pause` - Save session state
- `/resume` - Restore session
- `/add-todo [desc]` - Capture idea
- `/check-todos` - List TODOs

### Utilities (5)
Commands in `util/` subdirectory:
- `/debug [desc]` - Systematic debugging
- `/help` - Show all commands
- `/update` - Update GSD system
- `/whats-new` - Recent changes
- `/web-search [query]` - Search and document

## Compatibility

All slash commands reference workflows in `.gsd/workflows/`.

**With Kiro**: Use slash commands for enhanced experience
**Without Kiro**: Use workflows directly

Both approaches work identically.

## Kiro Enhancements

- **Argument hints**: Autocomplete shows expected arguments
- **Bash pre-execution**: Commands show current state
- **File references**: @ syntax includes file contents
- **Subagent integration**: Commands reference appropriate subagents

## See Also

- `.gsd/workflows/` - Complete workflow definitions
- `.gsd/COMMANDS.md` - Command reference
- `.gsd/SYSTEM.md` - System documentation
- `.kiro/agents/` - Subagent definitions
