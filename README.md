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

### What is Ralph Loop?

Ralph Loop is a methodology created by **Geoffrey Huntley** that enables AI assistants to work autonomously on long-running tasks by breaking them into iterations with fresh context.

**Key Concept**: Each iteration gets a fresh 200k token context window, preventing context pollution and quality degradation.

### How Ralph Works

Ralph is a **protocol**, not a tool. It coordinates work using:
- **Markdown files** for state (IMPLEMENTATION_PLAN.md)
- **Git** for history and commits
- **Shell scripts** for validation (backpressure)
- **Any AI assistant** for execution

### The Ralph Loop Cycle

```
1. Read IMPLEMENTATION_PLAN.md (what needs to be done)
2. Choose most important task
3. Execute task with AI
4. Validate changes (backpressure)
5. Commit if validation passes
6. Update IMPLEMENTATION_PLAN.md
7. Loop restarts with FRESH CONTEXT
```

**Why it works**: Each iteration starts fresh. No accumulated context, no degradation, consistent quality.

### Universal Ralph Loop

Our implementation makes Ralph Loop truly universal:

**Original Ralph Loop** (Geoffrey Huntley):
- Requires AI CLI (claude, openai, etc.)
- Automated execution
- Works in terminal

**GSD Universal Ralph Loop**:
- Works with ANY AI (ChatGPT web, Claude web, Kiro, terminal)
- Interactive mode (no CLI needed)
- Automated mode (if CLI available)
- Cross-platform (bash + PowerShell)

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

### Credits

Ralph Loop methodology created by [Geoffrey Huntley](https://github.com/ghuntley). Our implementation makes it universal and IDE-agnostic.

---

## About

Get Shit Done (GSD) is a context engineering framework created by [glittercowboy](https://github.com/glittercowboy) that makes AI coding reliable and consistent. This is the universal version that works with any AI assistant.

## Features

- **25+ workflows** for structured development
- **Codebase Intelligence** - Automatic indexing and pattern detection
- **Universal validation** (no IDE dependencies)
- **Cross-platform scripts** (bash + PowerShell)
- **File-based task coordination** with parallel execution support
- **Ralph Loop** - Autonomous execution protocol
- **Git hooks** - Automatic validation and indexing
- **Quick mode** - Ad-hoc tasks without full planning
- **Portable** across all AI assistants
- **Complete validation system**

## Quick Start

**New to GSD?** Read [QUICKSTART.md](QUICKSTART.md) for a 15-minute getting started guide.

**Existing project?** Read [.gsd/guides/brownfield.md](.gsd/guides/brownfield.md) for brownfield adoption.

### Installation

**Option 1: Automated Installer (Recommended)**

**Windows:**
```cmd
# Clone GSD Universal
git clone https://github.com/yura9011/GSD-universal.git
cd GSD-universal

# Run installer
install.bat

# Follow prompts to install to your project
```

**Linux/Mac:**
```bash
# Clone GSD Universal
git clone https://github.com/yura9011/GSD-universal.git
cd GSD-universal

# Make installer executable
chmod +x install.sh

# Run installer
./install.sh

# Follow prompts to install to your project
```

The installer will:
- Ask for your project directory
- Copy all necessary GSD files
- Set up proper permissions
- Provide next steps

**Option 2: Manual Installation**

1. Clone this repository:
```bash
git clone https://github.com/yura9011/GSD-universal.git
cd GSD-universal
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

### Original Creators

**GSD Framework**: Created by [glittercowboy](https://github.com/glittercowboy)
- Original project: [get-shit-done](https://github.com/glittercowboy/get-shit-done)
- Context engineering framework for Claude Code
- Spec-driven development methodology
- Multi-agent orchestration patterns

**Ralph Loop**: Created by [Geoffrey Huntley](https://github.com/ghuntley)
- Autonomous AI execution methodology
- Fresh context per iteration pattern
- Backpressure-driven quality control
- File-based state management

### GSD Universal

This project combines both methodologies into a truly universal framework:

**What we added**:
- Universal protocols (no IDE dependencies)
- Cross-platform scripts (bash + PowerShell)
- Interactive Ralph Loop (works without AI CLI)
- Codebase intelligence system
- Works with any AI (ChatGPT, Claude, Kiro, Gemini, etc.)
- Complete portability across all environments

**Core concepts and methodology**: Original work by glittercowboy and Geoffrey Huntley.

**Universal implementation**: This repository.

### Related Projects

- [get-shit-done](https://github.com/glittercowboy/get-shit-done) - Original GSD for Claude Code
- [ralph-playbook](https://github.com/ClaytonFarr/ralph-playbook) - Comprehensive Ralph Loop guide
- [get-shit-done-for-antigravity](https://github.com/toonight/get-shit-done-for-antigravity) - GSD for Antigravity

### Acknowledgments

Special thanks to:
- **glittercowboy** for creating the GSD framework and proving spec-driven AI development works
- **Geoffrey Huntley** for the Ralph Loop methodology and fresh context pattern
- **Clayton Farr** for the comprehensive Ralph Playbook documentation
- The AI development community for feedback and contributions

## Support

For issues, questions, or suggestions, please open an issue on GitHub.
