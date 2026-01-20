# GSD for Kiro IDE

A portable, spec-driven development methodology adapted for Kiro IDE.

## About

Get Shit Done (GSD) is a context engineering framework that makes AI coding reliable and consistent. This is a complete adaptation for Kiro IDE with full support for Kiro-specific features.

## Features

- 25 workflow commands for structured development
- 26 document templates for consistency
- Automatic command detection in Kiro
- Integration with Kiro's getDiagnostics and context-gatherer
- Portable across all AI coding assistants
- Complete validation scripts

## Quick Start

### Installation

1. Clone this repository into your project:
```bash
git clone https://github.com/yura9011/GSD_KiroIDE.git
cd GSD_KiroIDE
```

2. Copy the GSD system to your project:
```bash
# Copy .gsd folder
cp -r .gsd /path/to/your/project/

# Copy .kiro integration
cp -r .kiro /path/to/your/project/

# Copy scripts (optional)
cp -r scripts /path/to/your/project/
```

3. Start using GSD in Kiro:
```
/new-project
```

### For New Projects

If you're starting a new project, you can use this repository as a template:

```bash
# Clone into your new project directory
git clone https://github.com/yura9011/GSD_KiroIDE.git my-new-project
cd my-new-project

# Remove the git history to start fresh
rm -rf .git
git init

# Start your project
# Open in Kiro and type: /new-project
```

## Available Commands

### Core Workflow (6)
- `/new-project` - Initialize with deep questioning
- `/map` - Analyze existing codebase
- `/plan [N]` - Create execution plans for phase N
- `/execute [N]` - Implement phase with atomic commits
- `/verify [N]` - Validate with empirical evidence
- `/progress` - Show current position

### Phase Management (6)
- `/discuss-phase [N]` - Clarify scope before planning
- `/research-phase [N]` - Deep technical research
- `/add-phase` - Add phase to roadmap
- `/insert-phase [N]` - Insert urgent phase
- `/remove-phase [N]` - Remove future phase
- `/list-phase-assumptions` - Surface planning assumptions

### Milestone Management (4)
- `/new-milestone [name]` - Start next version
- `/complete-milestone` - Archive and tag release
- `/audit-milestone` - Review quality
- `/plan-milestone-gaps` - Create gap closure plans

### Session Management (4)
- `/pause` - Save state for session handoff
- `/resume` - Restore from last session
- `/add-todo [desc]` - Quick capture idea
- `/check-todos` - List pending items

### Utilities (5)
- `/debug [desc]` - Systematic debugging
- `/help` - Show all commands
- `/update` - Check for GSD updates
- `/whats-new` - Show recent changes
- `/web-search [query]` - Research with web search

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
│   ├── templates/       # 26 document templates
│   └── examples/        # Usage examples
│
├── .kiro/               # Kiro integration
│   └── steering/
│       └── gsd-system.md
│
├── .planning/           # Phase work
├── .summaries/          # Results
└── .todos/              # Captured ideas
```

## Kiro-Specific Features

### Context Gatherer Integration
For `/map`, Kiro uses the context-gatherer sub-agent to analyze your codebase efficiently.

### Diagnostics Integration
For verification, Kiro uses `getDiagnostics` instead of running linters manually.

### Parallel Execution
When executing independent tasks, Kiro can use sub-agents or parallel tool calls.

## Portability

This GSD setup is completely portable:

- Works with Kiro, Claude Code, Antigravity, or any AI assistant
- All files are markdown (git-friendly)
- No proprietary formats
- Share entire project folder

## Documentation

- `.gsd/SYSTEM.md` - Complete system instructions
- `.gsd/COMMANDS.md` - All commands reference
- `.gsd/workflows/` - Detailed workflow definitions
- `.gsd/examples/` - Usage examples
- `GSD-STYLE.md` - Complete style guide

## Validation

Run validation scripts to verify structure:

```bash
# PowerShell
.\scripts\validate-all.ps1

# Bash
./scripts/validate-all.sh
```

## Example Workflow

```bash
# Initialize project
/new-project

# Analyze existing code (if any)
/map

# Plan first phase
/plan 1

# Execute phase
/execute 1

# Verify work
/verify 1

# Check progress
/progress
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - See LICENSE file for details

## Credits

Based on [Get Shit Done](https://github.com/glittercowboy/get-shit-done) by glittercowboy.

Adapted for Kiro IDE with additional features:
- Kiro-specific integrations (getDiagnostics, context-gatherer)
- Enhanced steering file for automatic command detection
- Complete workflow definitions for all 25 commands
- Validation scripts for structure verification

## Related Projects

- [get-shit-done](https://github.com/glittercowboy/get-shit-done) - Original GSD for Claude Code
- [get-shit-done-for-antigravity](https://github.com/toonight/get-shit-done-for-antigravity) - GSD for Antigravity

## Support

For issues, questions, or suggestions, please open an issue on GitHub.
