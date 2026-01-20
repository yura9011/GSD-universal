# GSD Installation for Kiro

This GSD implementation is already installed and configured for Kiro.

## What's Installed

### Core System
- ✅ `.gsd/SYSTEM.md` - Complete system instructions
- ✅ `.gsd/COMMANDS.md` - All 25 commands reference
- ✅ `.gsd/workflows/` - 25 detailed workflow definitions
- ✅ `.gsd/templates/` - 26 document templates
- ✅ `.gsd/examples/` - Usage examples and quick reference

### Kiro Integration
- ✅ `.kiro/steering/gsd-system.md` - Automatic GSD integration
- ✅ Kiro-specific enhancements (getDiagnostics, context-gatherer, sub-agents)

### Documentation
- ✅ `README.md` - Main documentation
- ✅ `GSD-STYLE.md` - Complete style guide
- ✅ `CHANGELOG.md` - Version history
- ✅ `VERSION` - Current version

### Validation Scripts
- ✅ `scripts/validate-all.ps1` - Validate entire GSD structure
- ✅ `scripts/validate-workflows.ps1` - Validate workflows
- ✅ `scripts/validate-templates.ps1` - Validate templates

## Quick Start

Just type in Kiro:

```
/new-project
```

The system will guide you through deep questioning to create your SPEC.md.

## All Available Commands (25)

### Core Workflow
- `/new-project` - Initialize with deep questioning
- `/map` - Analyze existing codebase
- `/plan [N]` - Create execution plans for phase N
- `/execute [N]` - Implement phase with atomic commits
- `/verify [N]` - Validate with empirical evidence
- `/progress` - Show current position

### Phase Management
- `/discuss-phase [N]` - Clarify scope before planning
- `/research-phase [N]` - Deep technical research
- `/add-phase` - Add phase to roadmap
- `/insert-phase [N]` - Insert urgent phase
- `/remove-phase [N]` - Remove future phase
- `/list-phase-assumptions` - Surface planning assumptions

### Milestone Management
- `/new-milestone [name]` - Start next version
- `/complete-milestone` - Archive and tag release
- `/audit-milestone` - Review quality
- `/plan-milestone-gaps` - Create gap closure plans

### Session Management
- `/pause` - Save state for session handoff
- `/resume` - Restore from last session
- `/add-todo [desc]` - Quick capture idea
- `/check-todos` - List pending items

### Utilities
- `/debug [desc]` - Systematic debugging
- `/help` - Show all commands
- `/update` - Check for GSD updates
- `/whats-new` - Show recent changes
- `/web-search [query]` - Research with web search

## How It Works

1. **You type a command** (e.g., `/plan 1`)
2. **Kiro reads** `.gsd/workflows/plan.md`
3. **Kiro follows** the workflow step-by-step
4. **Kiro uses** templates from `.gsd/templates/`
5. **Kiro updates** STATE.md with progress
6. **Kiro creates** atomic git commits

## The 4 Laws

### 1. Planning Lock 🔒
No code until SPEC.md status = "FINALIZED"

### 2. State Persistence 💾
Update STATE.md after every significant action

### 3. Context Hygiene 🧹
3 failures → state dump → fresh session

### 4. Empirical Validation ✅
Every verification needs proof (screenshots, command output)

## Kiro-Specific Features

### Context Gatherer
For `/map` command, Kiro uses the context-gatherer sub-agent to analyze your codebase.

### Diagnostics
For verification, Kiro uses `getDiagnostics` instead of running linters manually.

### Parallel Execution
When executing independent tasks, Kiro can use sub-agents or parallel tool calls.

## File Structure

```
Your Project/
├── SPEC.md              # ← Start here (finalize first)
├── ROADMAP.md           # Phases and progress
├── STATE.md             # Current position
├── ARCHITECTURE.md      # System design (from /map)
├── DECISIONS.md         # Architecture decisions
├── JOURNAL.md           # Session log
├── TODO.md              # Quick capture
│
├── .gsd/                # System (never modify)
│   ├── workflows/       # 25 workflow definitions
│   ├── templates/       # 26 document templates
│   └── examples/        # Usage examples
│
├── .kiro/               # Kiro integration
│   └── steering/
│       └── gsd-system.md
│
├── .planning/           # Phase work
│   ├── phase-1-CONTEXT.md
│   ├── phase-1-RESEARCH.md
│   └── phase-1-PLAN.md
│
├── .summaries/          # Results
│   └── phase-1-SUMMARY.md
│
└── .todos/              # Captured ideas
    └── *.md
```

## Portability

This GSD setup is **completely portable**:

✅ Works with Kiro, Claude Code, Antigravity, or any AI assistant  
✅ All files are markdown (git-friendly)  
✅ No proprietary formats  
✅ Share entire project folder  

## Validation

Run validation scripts to verify structure:

```powershell
.\scripts\validate-all.ps1
```

## Getting Help

- Type `/help` in Kiro
- Read `.gsd/workflows/{command}.md` for detailed workflows
- Read `.gsd/examples/` for usage patterns
- Read `GSD-STYLE.md` for complete style guide

## Next Steps

1. Type `/new-project` to initialize
2. Answer deep questions about your project
3. Review generated SPEC.md and ROADMAP.md
4. Type `/plan 1` to create execution plans
5. Type `/execute 1` to start building

---

**You're ready to Get Shit Done!** 🚀
