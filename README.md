# GSD - Get Shit Done

A portable, spec-driven development methodology that works with any AI assistant.

## Universal Framework

GSD is truly universal - works identically across all environments:
- Terminal + ChatGPT
- Terminal + Claude
- Kiro IDE
- VS Code + Copilot
- Antigravity
- Any AI coding assistant

No IDE dependencies. Pure markdown + git + shell scripts.

## Ralph Loop - Autonomous Execution

Ralph Loop enables autonomous execution of GSD tasks through iterative AI assistance.

### How Ralph Works

Ralph is a **protocol**, not a tool. It coordinates work using:
- Markdown files for state
- Git for history
- Shell scripts for validation
- Any AI assistant for execution

### Quick Start

1. Ensure setup complete: `./scripts/ralph.sh --dry-run`
2. Start build mode: `./scripts/ralph.sh build`
3. Execute prompts with your AI assistant
4. Let Ralph coordinate validation and commits

### Modes

- `build` - Implement functionality from IMPLEMENTATION_PLAN.md
- `plan` - Update and prioritize tasks
- `--manual` - Full manual mode (no automation)
- `--dry-run` - Validate setup only

See `.gsd/protocols/ralph-loop.md` for complete protocol specification.

---

## About

Get Shit Done (GSD) is a context engineering framework created by [glittercowboy](https://github.com/glittercowboy) that makes AI coding reliable and consistent. This is the universal version that works with any AI assistant.

## Features

- 25 workflows for structured development
- Universal validation (no IDE dependencies)
- Cross-platform scripts (bash + PowerShell)
- File-based task coordination
- Portable across all AI assistants
- Complete validation system

## Quick Start

### Installation

1. Clone this repository:
```bash
git clone https://github.com/yura9011/GSD_KiroIDE.git
cd GSD_KiroIDE
```

2. Copy GSD to your project:
```bash
# Copy .gsd folder
cp -r .gsd /path/to/your/project/

# Copy scripts
cp -r scripts /path/to/your/project/

# Copy root files
cp loop.sh loop.ps1 PROMPT_*.md /path/to/your/project/
```

3. Start using GSD:
- Read `.gsd/workflows/new-project.md` to initialize
- Or use Ralph Loop: `./loop.sh build`

### For New Projects

Use this repository as a template:

```bash
# Clone into your new project directory
git clone https://github.com/yura9011/GSD_KiroIDE.git my-new-project
cd my-new-project

# Remove git history to start fresh
rm -rf .git
git init

# Initialize project
# Read .gsd/workflows/new-project.md and follow the process
```

## Available Workflows

### Core Workflow (6)
- `new-project.md` - Initialize with deep questioning
- `map.md` - Analyze existing codebase
- `plan.md` - Create execution plans for phase N
- `execute.md` - Implement phase with atomic commits
- `verify.md` - Validate with empirical evidence
- `progress.md` - Show current position

### Phase Management (6)
- `discuss-phase.md` - Clarify scope before planning
- `research-phase.md` - Deep technical research
- `add-phase.md` - Add phase to roadmap
- `insert-phase.md` - Insert urgent phase
- `remove-phase.md` - Remove future phase
- `list-phase-assumptions.md` - Surface planning assumptions

### Milestone Management (4)
- `new-milestone.md` - Start next version
- `complete-milestone.md` - Archive and tag release
- `audit-milestone.md` - Review quality
- `plan-milestone-gaps.md` - Create gap closure plans

### Session Management (4)
- `pause.md` - Save state for session handoff
- `resume.md` - Restore from last session
- `add-todo.md` - Quick capture idea
- `check-todos.md` - List pending items

### Utilities (5)
- `debug.md` - Systematic debugging
- `help.md` - Show all workflows
- `update.md` - Check for GSD updates
- `whats-new.md` - Show recent changes
- `web-search.md` - Research with web search

All workflows are in `.gsd/workflows/` directory.

## How It Works

### 1. Planning Lock
No code until SPEC.md status is "FINALIZED". This prevents building the wrong thing.

### 2. State Persistence
Update STATE.md after every significant action. Ensures memory across sessions.

### 3. Context Hygiene
3 failures leads to state dump and fresh session. Prevents circular debugging.

### 4. Empirical Validation
Every verification needs proof (screenshots, command output, test results).

## File Structure

```
Your Project/
├── SPEC.md              # Project specification
├── ROADMAP.md           # Phases and progress
├── STATE.md             # Current position
├── ARCHITECTURE.md      # System design
├── DECISIONS.md         # Architecture decisions
├── JOURNAL.md           # Session log
│
├── .gsd/                # System files
│   ├── workflows/       # 25 workflow definitions
│   ├── templates/       # 20+ document templates
│   ├── protocols/       # Universal protocols
│   ├── lib/             # Reusable components
│   └── examples/        # Usage examples
│
├── scripts/             # Executable scripts
│   ├── validate.sh      # Validation (bash)
│   ├── validate.ps1     # Validation (PowerShell)
│   ├── ralph.sh         # Ralph coordinator (bash)
│   └── ralph.ps1        # Ralph coordinator (PowerShell)
│
├── loop.sh              # Ralph Loop (bash)
├── loop.ps1             # Ralph Loop (PowerShell)
├── PROMPT_build.md      # Build mode prompt
└── PROMPT_plan.md       # Plan mode prompt
```

## Universal Protocols

GSD uses universal protocols that work in any environment:

- **Validation Protocol** - Language-specific linters via shell
- **Parallel Processing** - File-based task coordination
- **File Structure** - IDE-independent organization
- **Ralph Loop** - Protocol-based autonomous execution

See `.gsd/protocols/` for complete specifications.

## Portability

This GSD setup is completely portable:

- Works with any AI assistant (ChatGPT, Claude, Kiro, etc.)
- All files are markdown (git-friendly)
- No proprietary formats
- No IDE dependencies
- Share entire project folder

## Documentation

- `.gsd/SYSTEM.md` - Complete system instructions
- `.gsd/COMMANDS.md` - All workflows reference
- `.gsd/workflows/` - Detailed workflow definitions
- `.gsd/protocols/` - Universal protocol specifications
- `.gsd/examples/` - Usage examples
- `GSD-STYLE.md` - Complete style guide

## Validation

Run validation scripts to verify structure:

**Windows:**
```powershell
.\scripts\validate.ps1 -All
```

**Linux/Mac:**
```bash
./scripts/validate.sh --all
```

## Example Workflow

```bash
# Initialize project (read workflow)
cat .gsd/workflows/new-project.md

# Analyze existing code (if any)
cat .gsd/workflows/map.md

# Plan first phase
cat .gsd/workflows/plan.md

# Execute phase
cat .gsd/workflows/execute.md

# Verify work
cat .gsd/workflows/verify.md

# Check progress
cat .gsd/workflows/progress.md
```

Or use Ralph Loop for autonomous execution:

```bash
./loop.sh build
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - See LICENSE file for details

## Credits

This project is based on [Get Shit Done](https://github.com/glittercowboy/get-shit-done) by [glittercowboy](https://github.com/glittercowboy).

GSD is a context engineering framework created by glittercowboy that makes AI coding reliable and consistent. The original framework was designed for Claude Code and has been adapted here as a universal version that works with any AI assistant.

### What This Version Adds

This universal version extends the original GSD framework with:
- Universal protocols (no IDE dependencies)
- Cross-platform scripts (bash + PowerShell)
- File-based task coordination
- Ralph Loop protocol for autonomous execution
- Complete portability across all AI assistants

All core GSD concepts, workflows, and methodology are from the original work by glittercowboy.

## Related Projects

- [get-shit-done](https://github.com/glittercowboy/get-shit-done) - Original GSD for Claude Code
- [get-shit-done-for-antigravity](https://github.com/toonight/get-shit-done-for-antigravity) - GSD for Antigravity

## Support

For issues, questions, or suggestions, please open an issue on GitHub.
