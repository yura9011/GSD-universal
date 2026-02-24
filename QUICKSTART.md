# GSD Universal - Quick Start Guide

**Get from idea to working code in 15 minutes.**

---

## What is GSD?

GSD (Get Shit Done) is a framework for building software with AI assistants. It works with **any AI** (ChatGPT, Claude, Kiro, etc.) in **any environment** (web, IDE, terminal).

**Core idea**: Break work into phases, plan each phase, execute with fresh context, verify results.

---

## Prerequisites

- Git installed
- Text editor (any)
- AI assistant (ChatGPT, Claude, Kiro, or any other)
- 15 minutes

---

## Installation

### Option 1: Automated Installer (Recommended)

**Windows:**
```cmd
# Clone GSD Universal
git clone https://github.com/yura9011/GSD-universal.git
cd GSD-universal

# Run installer
install.bat
```

**Linux/Mac:**
```bash
# Clone GSD Universal
git clone https://github.com/yura9011/GSD-universal.git
cd GSD-universal

# Make installer executable and run
chmod +x install.sh
./install.sh
```

The installer will:
1. Ask for your project directory path
2. Copy all GSD files (.gsd/, scripts/, loop files, etc.)
3. Optionally copy documentation
4. Set up proper permissions
5. Show you next steps

**Time**: 1-2 minutes

### Option 2: Manual Installation

```bash
# Clone GSD
git clone https://github.com/your-org/gsd-universal.git my-project
cd my-project

# Remove GSD git history
rm -rf .git

# Initialize your project
git init
git add .
git commit -m "Initial commit with GSD"
```

### Option 2: Manual Installation

```bash
# Clone GSD
git clone https://github.com/yura9011/GSD-universal.git my-project
cd my-project

# Remove GSD git history
rm -rf .git

# Initialize your project
git init
git add .
git commit -m "Initial commit with GSD"
```

### Option 3: Add to Existing Project

1. Download GSD from GitHub
2. Copy `.gsd/` folder to your project
3. Copy `scripts/` folder to your project
4. Copy `loop.sh` and `loop.ps1` to your project
5. Copy `PROMPT_build.md` and `PROMPT_plan.md` to your project
6. Copy `AGENTS.md` to your project

---

## First Project (New Codebase)

### Step 1: Define Your Project

Open your AI assistant and say:

```
I want to use GSD framework to build a project.
Please read .gsd/workflows/new-project.md and help me define:
- Project vision
- Requirements
- Roadmap with phases
```

**What happens**:
- AI asks questions about your project
- You answer (goals, constraints, tech stack)
- AI creates: `PROJECT.md`, `REQUIREMENTS.md`, `ROADMAP.md`, `STATE.md`

**Time**: 5-10 minutes

### Step 2: Plan First Phase

Once you have a roadmap, plan the first phase:

```
Please read .gsd/workflows/plan.md and help me plan Phase 1.
Create detailed execution plans.
```

**What happens**:
- AI researches how to implement the phase
- AI creates 2-3 atomic task plans
- Each plan is small enough to execute in one session

**Time**: 3-5 minutes

### Step 3: Execute with Ralph Loop

Now execute the plans using Ralph Loop:

**Option A: Interactive Mode** (works with any AI)

```bash
# v2 structure (recommended)
./.gsd/scripts/loop.sh

# v1 structure (legacy)
./loop.sh

# Ralph shows you the prompt
# Copy prompt to your AI
# AI executes, makes changes
# Press ENTER when AI is done
# Ralph validates changes
# Ralph commits if validation passes
# Loop continues with next task
```

**Option B: Automated Mode** (if you have AI CLI)

```bash
# If you have claude, kiro, or other AI CLI
./.gsd/scripts/loop.sh --auto  # v2
# or
./loop.sh --auto  # v1

# Ralph feeds prompts to AI automatically
# Validates after each task
# Commits when validation passes
# Continues until all tasks done
```

**Note**: Scripts automatically detect v1 or v2 structure.

**Time**: Varies (AI does the work)

### Step 4: Verify Results

After execution, verify the work:

```
Please read .gsd/workflows/verify.md and help me verify Phase 1.
Check that all requirements are met.
```

**What happens**:
- AI checks deliverables
- You test the actual functionality
- AI documents verification results

**Time**: 2-3 minutes

### Step 5: Repeat

Continue with next phases:
1. Plan phase → Execute → Verify
2. Repeat until milestone complete
3. Ship!

---

## Existing Project (Brownfield)

Already have code? Start here:

### Step 1: Add GSD to Your Project

```bash
# In your existing project
cd my-existing-project

# Copy GSD files (assuming you cloned GSD to ../gsd-universal)
cp -r ../gsd-universal/.gsd .
cp -r ../gsd-universal/scripts .
cp ../gsd-universal/loop.sh .
cp ../gsd-universal/loop.ps1 .
cp ../gsd-universal/PROMPT_*.md .
cp ../gsd-universal/AGENTS.md .

# Commit
git add .
git commit -m "Add GSD framework"
```

### Step 2: Index Your Codebase

```bash
# Generate codebase intelligence
# v2 structure
./.gsd/scripts/index-codebase.sh

# v1 structure (legacy)
./scripts/index-codebase.sh

# This creates .gsd/intel/ with:
# - index.json (exports/imports)
# - conventions.json (detected patterns)
# - graph.json (dependencies)
# - summary.md (AI-readable summary)
```

### Step 3: Map Your Codebase

Open your AI and say:

```
I have an existing codebase and want to use GSD.
Please read .gsd/intel/summary.md to understand my codebase.
Then read .gsd/workflows/map.md and help me document:
- Architecture
- File structure
- Key patterns
```

**What happens**:
- AI reads intelligence summary
- AI understands your codebase structure
- AI creates architecture documentation

### Step 4: Define What to Build Next

```
Now that you understand my codebase, let's define what to build next.
Please read .gsd/workflows/new-milestone.md and help me:
- Define the next feature/milestone
- Create requirements
- Plan phases
```

### Step 5: Continue as Normal

From here, same as new project:
- Plan phase → Execute → Verify → Repeat

---

## Common Workflows

### Add a New Feature

```
1. Update ROADMAP.md with new phase
2. Plan the phase: Read .gsd/workflows/plan.md
3. Execute: Run ./.gsd/scripts/loop.sh (or ./loop.sh for v1)
4. Verify: Read .gsd/workflows/verify.md
5. Commit and continue
```

### Fix a Bug

```
1. Document bug in IMPLEMENTATION_PLAN.md
2. Execute fix: Run ./.gsd/scripts/loop.sh (or ./loop.sh for v1)
3. Verify fix works
4. Commit
```

### Refactor Code

```
1. Create refactoring phase in ROADMAP.md
2. Plan refactoring: Read .gsd/workflows/plan.md
3. Execute: Run ./.gsd/scripts/loop.sh with tests as backpressure
4. Verify: All tests pass, behavior unchanged
5. Commit
```

### Update Documentation

```
1. Add documentation task to IMPLEMENTATION_PLAN.md
2. Execute: AI updates docs
3. Verify: Docs are accurate and complete
4. Commit
```

---

## Key Files

### You Create These

- `PROJECT.md` - Project vision and goals
- `REQUIREMENTS.md` - What needs to be built
- `ROADMAP.md` - Phases to complete the project
- `STATE.md` - Current position and decisions
- `IMPLEMENTATION_PLAN.md` - Current tasks (disposable)
- `specs/*.md` - Detailed specifications (optional)

### GSD Provides These

- `.gsd/workflows/*.md` - 25+ workflows for common tasks
- `.gsd/protocols/*.md` - Core patterns and principles
- `.gsd/templates/*.md` - Document templates
- `.gsd/examples/*.md` - Usage examples
- `scripts/*.sh` and `*.ps1` - Automation scripts
- `AGENTS.md` - Operational guide (validation, commands)

### AI Creates These

- `.gsd/intel/*.json` - Codebase intelligence (after indexing)
- `.gsd/tasks/*.md` - Task coordination (during execution)
- Phase plans and summaries
- Verification results

---

## Validation

Before marking any task complete, run validation:

**Windows**:
```powershell
# v2 structure
.\.gsd\scripts\validate.ps1 -All

# v1 structure (legacy)
.\scripts\validate.ps1 -All
```

**Mac/Linux**:
```bash
# v2 structure
./.gsd/scripts/validate.sh --all

# v1 structure (legacy)
./scripts/validate.sh --all
```

**Note**: Scripts automatically detect your structure version.

**What it checks**:
- Code syntax (language-specific linters)
- Workflow structure
- File structure
- Git status

---

## Tips for Success

### 1. Start Small
- Don't plan entire project upfront
- Plan 1-2 phases at a time
- Iterate and adjust

### 2. Keep Context Fresh
- Start new AI conversation per phase
- Don't let conversations get too long
- Ralph Loop handles this automatically

### 3. Use Validation
- Run validation before committing
- Validation is your backpressure
- Catches issues early

### 4. Trust the Process
- Let AI pick task order
- Don't micromanage
- Observe and adjust

### 5. Document Decisions
- Update STATE.md with important decisions
- Update AGENTS.md with operational learnings
- Keep IMPLEMENTATION_PLAN.md current

---

## Troubleshooting

### "AI doesn't understand the workflow"

**Solution**: Copy the entire workflow file content and paste it to AI. Be explicit: "Follow these instructions exactly."

### "Validation fails"

**Solution**: 
1. Read error message
2. Fix the issue
3. Run validation again
4. Don't commit until validation passes

### "Ralph Loop doesn't work"

**Solution**:
1. Check you have `PROMPT_build.md` or `PROMPT_plan.md` (v1) or `.gsd/config/PROMPT_build.md` (v2)
2. Check you have `AGENTS.md` (v1) or `.gsd/config/AGENTS.md` (v2)
3. Try `./.gsd/scripts/loop.sh --help` for usage (or `./loop.sh --help` for v1)
4. Use interactive mode if automated fails

### "AI makes inconsistent changes"

**Solution**:
1. Index your codebase: `./.gsd/scripts/index-codebase.sh` (or `./scripts/index-codebase.sh` for v1)
2. AI will read `.gsd/intel/summary.md` for conventions
3. Be explicit about patterns in prompts

### "Context gets too long"

**Solution**:
1. Start new conversation
2. Load only necessary context
3. Use Ralph Loop (fresh context per task)

---

## Next Steps

### Learn More

- Read `.gsd/protocols/README.md` - Core principles
- Read `.gsd/workflows/help.md` - All available workflows
- Read `AGENTS.md` - Operational commands

### Explore Workflows

- `/new-project` - Start new project
- `/new-milestone` - Add milestone to existing project
- `/plan` - Plan a phase
- `/execute` - Execute plans
- `/verify` - Verify work
- `/map` - Map existing codebase
- `/pause` - Pause work session
- `/resume` - Resume work session

### Advanced Features

- **Codebase Intelligence**: `./.gsd/scripts/index-codebase.sh` (or `./scripts/index-codebase.sh` for v1)
- **Parallel Execution**: Read `.gsd/protocols/parallel.md`
- **Git Hooks**: Automatic validation and indexing
- **Custom Workflows**: Create your own in `.gsd/workflows/`
- **Structure Migration**: Use `.gsd/scripts/migrate-to-v2.sh` to upgrade to v2

---

## Getting Help

### Documentation

- `README.md` - Project overview
- `.gsd/workflows/help.md` - All workflows
- `.gsd/protocols/*.md` - Core patterns
- `AGENTS.md` - Operational guide

### Community

- GitHub Issues - Report bugs or ask questions
- GitHub Discussions - Share experiences
- Examples - See `.gsd/examples/` for patterns

---

## Summary

**GSD in 3 steps**:
1. **Plan** - Define what to build (workflows)
2. **Execute** - Build it (Ralph Loop)
3. **Verify** - Confirm it works (validation)

**Works with**:
- Any AI (ChatGPT, Claude, Kiro, etc.)
- Any environment (web, IDE, terminal)
- Any platform (Windows, Mac, Linux)

**Key insight**: Fresh context per task = consistent quality.

**Start now**: Follow "First Project" section above.

---

**Welcome to GSD Universal. Let's get shit done.**
