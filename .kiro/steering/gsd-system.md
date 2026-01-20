---
inclusion: always
---

# GSD System Integration for Kiro

You are operating within the **Get Shit Done (GSD)** framework - a portable, spec-driven development methodology.

## Quick Reference

When the user types a GSD command (e.g., `/new-project`, `/plan 1`, `/execute 2`), read the corresponding workflow file from `.gsd/workflows/` and follow it exactly.

## Core Files

- `.gsd/SYSTEM.md` - Complete system instructions
- `.gsd/COMMANDS.md` - All 25 available commands
- `.gsd/workflows/*.md` - Detailed workflow definitions (25 files)
- `.gsd/templates/*.md` - Document templates (20+ templates)
- `.gsd/examples/` - Usage examples and quick reference
- `GSD-STYLE.md` - Complete style guide

## All Available Commands (25)

### Core Workflow (6)
- `/new-project` → `.gsd/workflows/new-project.md`
- `/map` → `.gsd/workflows/map.md`
- `/plan [N]` → `.gsd/workflows/plan.md`
- `/execute [N]` → `.gsd/workflows/execute.md`
- `/verify [N]` → `.gsd/workflows/verify.md`
- `/progress` → `.gsd/workflows/progress.md`

### Phase Management (6)
- `/discuss-phase [N]` → `.gsd/workflows/discuss-phase.md`
- `/research-phase [N]` → `.gsd/workflows/research-phase.md`
- `/add-phase` → `.gsd/workflows/add-phase.md`
- `/insert-phase [N]` → `.gsd/workflows/insert-phase.md`
- `/remove-phase [N]` → `.gsd/workflows/remove-phase.md`
- `/list-phase-assumptions` → `.gsd/workflows/list-phase-assumptions.md`

### Milestone Management (4)
- `/new-milestone [name]` → `.gsd/workflows/new-milestone.md`
- `/complete-milestone` → `.gsd/workflows/complete-milestone.md`
- `/audit-milestone` → `.gsd/workflows/audit-milestone.md`
- `/plan-milestone-gaps` → `.gsd/workflows/plan-milestone-gaps.md`

### Session Management (4)
- `/pause` → `.gsd/workflows/pause.md`
- `/resume` → `.gsd/workflows/resume.md`
- `/add-todo [desc]` → `.gsd/workflows/add-todo.md`
- `/check-todos` → `.gsd/workflows/check-todos.md`

### Utilities (5)
- `/debug [desc]` → `.gsd/workflows/debug.md`
- `/help` → `.gsd/workflows/help.md`
- `/update` → `.gsd/workflows/update.md`
- `/whats-new` → `.gsd/workflows/whats-new.md`
- `/web-search [query]` → `.gsd/workflows/web-search.md`

## Command Execution Protocol

When user types a GSD command:

1. **Read the workflow file** from `.gsd/workflows/{command}.md`
2. **Follow the `<process>` section** step by step
3. **Use templates** from `.gsd/templates/` when creating files
4. **Update STATE.md** after significant actions
5. **Create atomic commits** for each completed task
6. **Display the `<offer_next>` section** at the end

## Critical Rules

1. **Planning Lock**: Check `SPEC.md` status before generating code. If not FINALIZED, refuse.
2. **State Persistence**: Update `STATE.md` after significant decisions or phase completions
3. **Atomic Commits**: Each task gets its own commit with format: `feat(phase-N): description`
4. **Use Templates**: Copy from `.gsd/templates/` when creating new GSD files
5. **Empirical Verification**: All verifications must produce evidence

## Kiro-Specific Enhancements

When working in Kiro, leverage these native features:

### For `/map` command
Use `context-gatherer` sub-agent:
```
invokeSubAgent(
  name: "context-gatherer",
  prompt: "Analyze this codebase and identify: tech stack, architecture patterns, code conventions, and technical debt"
)
```

### For verification
Use `getDiagnostics` instead of running linters:
```
getDiagnostics(paths: ["file1.ts", "file2.ts"])
```

### For parallel execution
When executing multiple independent tasks, use sub-agents or parallel tool calls.

## File Locations

GSD uses these locations (portable across all agents):
- Root: `SPEC.md`, `ROADMAP.md`, `STATE.md`, `ARCHITECTURE.md`
- Planning: `.planning/phase-N-*.md`
- Summaries: `.summaries/phase-N-SUMMARY.md`
- Todos: `.todos/*.md`
- System: `.gsd/` (system files, never modify)

## Workflow Integration

When user starts a GSD command:
1. Read `.gsd/COMMANDS.md` for the command definition
2. Follow the workflow specified
3. Use templates from `.gsd/templates/`
4. Update `STATE.md` when complete
5. Create atomic git commits

## Portability

This GSD setup is portable. Users can:
- Share the entire project (including `.gsd/` folder)
- Work on it with different AI assistants
- Version control everything (all markdown)
- Switch between Kiro, Claude Code, Antigravity, etc.

The `.gsd/` folder contains the system definition. The root files (`SPEC.md`, `ROADMAP.md`, etc.) contain the project state.

---

**When you see a GSD command, read `.gsd/COMMANDS.md` for the complete workflow.**


## Critical Rules (The 4 Laws)

### 1. Planning Lock 🔒
**BEFORE writing any implementation code:**
```
✓ SPEC.md exists AND status = "FINALIZED"
✓ ROADMAP.md exists with defined phases
```
**If not met:** STOP. Help user finalize SPEC.md first.

**Exceptions:** Documentation, config files, test scaffolding only.

### 2. State Persistence 💾
**AFTER every significant action:**
- Update `STATE.md` with current position
- Update `JOURNAL.md` for session entries
- Document decisions in `DECISIONS.md`

### 3. Context Hygiene 🧹
**IF 3 consecutive debugging failures:**
1. STOP current approach
2. Document to STATE.md what was tried
3. Recommend `/pause` for fresh session

**Why:** Fresh context sees solutions polluted context misses.

### 4. Empirical Validation ✅
**Every verification needs proof:**

| Change Type | Required Evidence |
|-------------|-------------------|
| UI | Screenshot or browser output |
| API | curl/fetch command output |
| Build | Build command success output |
| Tests | Test runner output |
| File | ls/dir command showing file |

**Never accept:** "should work", "looks correct", "follows pattern"

## Kiro-Specific Enhancements

### For `/map` Command
Use context-gatherer sub-agent:
```javascript
invokeSubAgent({
  name: "context-gatherer",
  prompt: "Analyze this codebase: tech stack, architecture patterns, conventions, technical debt",
  explanation: "Gathering codebase context for ARCHITECTURE.md"
})
```

### For Verification
Use getDiagnostics instead of manual linting:
```javascript
getDiagnostics({
  paths: ["src/file1.ts", "src/file2.ts"]
})
```

### For Parallel Execution
When executing independent tasks in same wave, use parallel tool calls or sub-agents.

## File Structure (Portable)

```
Root Files (Project State):
├── SPEC.md              # Project specification (DRAFT → FINALIZED)
├── ROADMAP.md           # Phases and milestones
├── STATE.md             # Current position and decisions
├── ARCHITECTURE.md      # System design (from /map)
├── DECISIONS.md         # Architecture Decision Records
├── JOURNAL.md           # Session log
└── TODO.md              # Quick capture list

.gsd/ (System - Never Modify):
├── SYSTEM.md            # System instructions
├── COMMANDS.md          # Command reference
├── workflows/           # 25 workflow definitions
├── templates/           # 20+ document templates
└── examples/            # Usage examples

.planning/ (Phase Work):
├── phase-1-CONTEXT.md   # Implementation decisions
├── phase-1-RESEARCH.md  # Technical research
├── phase-1-PLAN.md      # Execution plan
└── ...

.summaries/ (Results):
├── phase-1-SUMMARY.md   # What was done
└── ...

.todos/ (Captured Ideas):
└── *.md
```

## Workflow Execution Pattern

All workflows follow this structure:

```markdown
<objective>
What this workflow accomplishes
</objective>

<context>
Required files, arguments, flags
</context>

<process>
## 1. Step Name
Instructions...

## 2. Next Step
Instructions...
</process>

<offer_next>
Display next steps to user
</offer_next>
```

## Phase Lifecycle

```
1. /discuss-phase N  → Clarify scope (optional)
2. /research-phase N → Technical research (optional)
3. /plan N           → Create execution plans
4. /execute N        → Implement with atomic commits
5. /verify N         → Validate with evidence
6. Repeat for next phase
```

## Wave-Based Execution

Plans are grouped by dependencies:
- **Wave 1:** Foundation (types, schemas, utilities)
- **Wave 2:** Core implementations (depends on Wave 1)
- **Wave 3:** Integration and validation (depends on Wave 2)

Plans in same wave execute in parallel. Later waves wait for earlier waves.

## Atomic Commits

Each task gets its own commit:
```bash
git commit -m "feat(phase-N): [specific task description]"
```

**Benefits:**
- Git bisect finds exact failing task
- Each task independently revertable
- Clear history for future AI sessions

## Quality Gates

Before marking phase complete:
- [ ] All tasks executed
- [ ] Atomic commits created
- [ ] Verification evidence collected
- [ ] STATE.md updated
- [ ] No failing diagnostics (use getDiagnostics)
- [ ] All must-haves from ROADMAP.md verified

## Portability

This GSD setup works across:
- ✅ Kiro (Windows/Mac/Linux)
- ✅ Claude Code (Mac/Linux)
- ✅ Antigravity (All platforms)
- ✅ Any AI coding assistant

**How to share:**
1. Copy entire project folder
2. All state in markdown files
3. No proprietary formats
4. Git-friendly

## Quick Start

```
/new-project     # Initialize with deep questioning
/map             # Analyze existing code (if brownfield)
/plan 1          # Create execution plans
/execute 1       # Implement phase 1
/verify 1        # Validate with evidence
/progress        # Check status
```

## Getting Help

- `/help` - Show all commands
- Read `.gsd/workflows/{command}.md` for detailed workflow
- Read `.gsd/examples/` for usage patterns
- Read `GSD-STYLE.md` for complete style guide

---

**Remember:** When you see a GSD command, read the corresponding workflow file from `.gsd/workflows/` and follow it exactly.
