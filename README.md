# GSD Universal - Get Shit Done

Spec-driven development framework that works with any AI assistant.

## What is GSD?

A portable methodology for AI-assisted development:
- **Spec-driven**: No code until requirements are clear
- **Universal**: Works with ChatGPT, Claude, Kiro, any AI
- **Autonomous**: Ralph Loop for long-running tasks
- **Memory System**: Agents learn and remember across sessions

## Quick Start

### Install

```bash
git clone https://github.com/yura9011/GSD-universal.git
cd GSD-universal
./install.sh  # or install.bat on Windows
```

### Use

```bash
# Read getting started guide
cat QUICKSTART.md

# Or start Ralph Loop
./.gsd/scripts/ralph.sh build
```

## Key Features

### 1. Ralph Loop - Autonomous Execution

AI works autonomously through iterations with fresh context:

```bash
./.gsd/scripts/ralph.sh build  # Execute tasks
./.gsd/scripts/ralph.sh plan   # Update plans
```

Each iteration: Read plan → Execute → Validate → Commit → Fresh context

**Credits**: Ralph Loop by [Geoffrey Huntley](https://github.com/ghuntley)

### 2. Memory System

Agents remember and learn:
- Journal entries after sessions
- Decision tracking
- Pattern recognition
- Search across all memory

```bash
# Search memory
./.gsd/scripts/memory-search.ps1 "query"

# View recent entries
./.gsd/scripts/memory-recent.ps1
```

### 3. External Knowledge Base

Index and search large directories (Obsidian vaults, docs, notes):

```bash
# Index external sources
./.gsd/scripts/memory-index-external.ps1

# Search everything
./.gsd/scripts/memory-search.ps1 "query" -All
```

### 4. Cross-Platform

Everything works on Windows, Mac, Linux:
- Bash scripts for Unix
- PowerShell scripts for Windows
- Automatic platform detection

## File Structure

```
Your Project/
├── .gsd/
│   ├── config/          # AGENTS.md, PROMPT files
│   ├── state/           # IMPLEMENTATION_PLAN.md
│   ├── memory/          # Agent memory system
│   ├── scripts/         # All executable scripts
│   ├── workflows/       # 25+ workflow definitions
│   └── docs/            # Documentation
└── src/                 # Your code
```

## Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - 15-minute getting started
- **[.gsd/guides/brownfield.md](.gsd/guides/brownfield.md)** - Add to existing project
- **[.gsd/docs/EXTERNAL-KNOWLEDGE-BASE.md](.gsd/docs/EXTERNAL-KNOWLEDGE-BASE.md)** - Knowledge base integration
- **[.gsd/protocols/ralph-loop.md](.gsd/protocols/ralph-loop.md)** - Ralph Loop protocol
- **[.gsd/workflows/](.gsd/workflows/)** - All workflows

## Update Existing Installation

```bash
cd GSD-universal
git pull
./update.sh  # or update.bat on Windows
```

Preserves your work, updates framework.

## Credits

- **GSD Framework**: [glittercowboy](https://github.com/glittercowboy)
- **Ralph Loop**: [Geoffrey Huntley](https://github.com/ghuntley)
- **Universal Implementation**: This repository

## License

MIT - See LICENSE file
