# Ralph Loop Architecture Specification

> **Status**: Initial specification for Phase 1
> **Purpose**: Define Ralph Loop system architecture and design patterns

## System Overview

Ralph Loop is an autonomous execution engine based on Geoffrey Huntley's implementation that provides:

- **Fresh Context Per Iteration**: Each loop starts a new AI session
- **File-Based State**: Persistent state stored in files, not conversation memory
- **Backpressure Validation**: Quality gates prevent bad work from being marked complete
- **Cross-Platform Support**: Bash and PowerShell implementations

## Core Components

### 1. Loop Scripts
- `loop.sh` - Bash implementation for Linux/Mac
- `loop.ps1` - PowerShell implementation for Windows
- Mode switching: build/plan
- Error handling and recovery

### 2. Operational Files
- `AGENTS.md` - Operational manual (under 60 lines)
- `IMPLEMENTATION_PLAN.md` - Dynamic task tracker
- `specs/` - Static requirements directory

### 3. Prompt Templates
- `PROMPT_build.md` - Build mode instructions with 999... guardrails
- `PROMPT_plan.md` - Planning mode instructions

### 4. Integration Layer
- GSD validation scripts (`./scripts/validate-all.*`)
- Git for version control and atomic commits
- AI CLI interface (claude, openai, etc.)

## Architecture Patterns

### Ralph Loop Pattern
```
while true; do
  cat PROMPT_${MODE}.md | ai-cli
  run_validation
  git_commit_if_passed
done
```

### State Management
- **Persistent**: Files on disk (IMPLEMENTATION_PLAN.md, specs/)
- **Ephemeral**: AI conversation context (cleared each iteration)
- **Version Control**: Git tracks all changes atomically

### Quality Gates
- Pre-execution: Validate setup and required files
- Post-execution: Run backpressure validation
- Commit: Only if validation passes

## Integration with GSD Framework

- **Extends**: Existing GSD structure and workflows
- **Leverages**: Current validation infrastructure
- **Maintains**: Cross-platform portability
- **Preserves**: Manual workflow compatibility

## Design Principles

1. **Simplicity Over Complexity**: Simple bash loop, not orchestration
2. **Fresh Context**: New session per iteration prevents pollution
3. **Empirical Validation**: All work must pass validation gates
4. **Atomic Operations**: One task, one commit, one iteration
5. **Cross-Platform**: Works on Windows, Linux, Mac equally