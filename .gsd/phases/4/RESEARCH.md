# Phase 4 Research: Command Modernization

**Phase**: 4 - Command Modernization
**Created**: 2026-01-20
**Research Level**: 2 (Standard Research)

---

## Research Question

How to migrate 25 GSD commands from workflow files to Kiro slash command format while maintaining compatibility?

---

## Findings

### 1. Kiro Slash Command Format

**Location**: `.claude/commands/` (project-level) or `~/.claude/commands/` (user-level)

**File Structure**:
```markdown
---
allowed-tools: Bash, Read, Write
argument-hint: "[phase-number]"
description: Brief description
model: claude-3-5-sonnet-20241022
context: fork | inline
---

# Command Content

Markdown content that becomes the prompt.
Can include:
- $ARGUMENTS placeholder for all args
- $1, $2, $3 for positional args
- @file references
- !`bash command` for pre-execution
```

### 2. Key Features for GSD Commands

**Frontmatter Fields**:
- `allowed-tools`: List of tools command can use
- `argument-hint`: Shows expected arguments in autocomplete
- `description`: Brief description (shown in /help)
- `model`: Specific model to use
- `context`: `fork` for subagent, `inline` for main conversation
- `hooks`: Command-scoped hooks

**Argument Handling**:
- `$ARGUMENTS`: All arguments as single string
- `$1`, `$2`, etc.: Individual positional arguments
- Example: `/plan 4` → `$1` = "4"

**Bash Execution**:
- Prefix with `!` to execute before command runs
- Output included in context
- Must specify allowed bash commands in `allowed-tools`
- Example: `!`git status`` runs git status

**File References**:
- Use `@` prefix to include file contents
- Example: `@.gsd/ROADMAP.md` includes ROADMAP content

### 3. GSD Command Categories

**Core Workflow (6)**:
- `/new-project` - No args, interactive
- `/map` - No args, uses map-explorer subagent
- `/plan [N]` - Phase number arg
- `/execute [N]` - Phase number arg
- `/verify [N]` - Phase number arg
- `/progress` - No args

**Phase Management (6)**:
- `/discuss-phase [N]` - Phase number arg
- `/research-phase [N]` - Phase number arg
- `/add-phase` - No args, interactive
- `/insert-phase [N]` - Phase number arg
- `/remove-phase [N]` - Phase number arg
- `/list-phase-assumptions` - No args

**Milestone Management (4)**:
- `/new-milestone [name]` - Milestone name arg
- `/complete-milestone` - No args
- `/audit-milestone` - No args
- `/plan-milestone-gaps` - No args

**Session Management (4)**:
- `/pause` - No args
- `/resume` - No args
- `/add-todo [desc]` - Description arg
- `/check-todos` - No args

**Utilities (5)**:
- `/debug [desc]` - Description arg
- `/help` - No args
- `/update` - No args
- `/whats-new` - No args
- `/web-search [query]` - Query arg

### 4. Migration Strategy

**Approach**: Create `.claude/commands/` versions that reference existing workflows

**Why Not Replace Workflows**:
- Workflows contain detailed process documentation
- Workflows are portable across AI assistants
- Slash commands are Kiro-specific
- Keep both for maximum compatibility

**Pattern**:
```markdown
---
argument-hint: "[phase-number]"
description: Create execution plans for a phase
---

# /plan Command

Read and follow the workflow at `.gsd/workflows/plan.md`.

**Phase**: $1

**Context**:
- @.gsd/ROADMAP.md
- @.gsd/STATE.md
- @.gsd/workflows/plan.md
```

### 5. Tool Permissions

**Common Tool Sets**:

**Read-only commands**:
```yaml
allowed-tools: Read, Grep, Glob
```

**Planning commands**:
```yaml
allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
```

**Execution commands**:
```yaml
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
```

**Verification commands**:
```yaml
allowed-tools: Read, Bash(npm test:*), Bash(pytest:*), Bash(git diff:*)
```

### 6. Argument Hints

**Format**: Shows in autocomplete

Examples:
- `argument-hint: "[phase-number]"` → `/plan [phase-number]`
- `argument-hint: "[name]"` → `/new-milestone [name]`
- `argument-hint: "[description]"` → `/add-todo [description]`
- No hint for commands without args

### 7. Context Fork Usage

**Use `context: fork` for**:
- Commands that read many files (`/map`)
- Commands with verbose output (`/verify`)
- Commands that do research (`/research-phase`)

**Use `context: inline` (default) for**:
- Interactive commands (`/new-project`)
- Quick status commands (`/progress`)
- Commands that need conversation context

### 8. Bash Pre-execution

**Use Cases**:
- Get current state: `!`git status``
- Check file existence: `!`test -f SPEC.md && echo "exists"``
- List files: `!`ls .gsd/phases/``

**Example**:
```markdown
---
allowed-tools: Bash(git status:*), Bash(git branch:*)
---

Current branch: !`git branch --show-current`
Current status: !`git status --short`

[Rest of command]
```

### 9. Compatibility Considerations

**Maintain Portability**:
- Keep `.gsd/workflows/` as source of truth
- Slash commands reference workflows
- Users without Kiro can still use workflows directly
- Documentation stays in workflows

**Migration Path**:
- Phase 4: Create slash commands
- Phase 5: Document both approaches
- Future: Users choose their preferred method

### 10. Organization

**Directory Structure**:
```
.claude/commands/
├── new-project.md
├── map.md
├── plan.md
├── execute.md
├── verify.md
├── progress.md
├── phase/
│   ├── discuss.md
│   ├── research.md
│   ├── add.md
│   ├── insert.md
│   ├── remove.md
│   └── list-assumptions.md
├── milestone/
│   ├── new.md
│   ├── complete.md
│   ├── audit.md
│   └── plan-gaps.md
├── session/
│   ├── pause.md
│   ├── resume.md
│   ├── add-todo.md
│   └── check-todos.md
└── util/
    ├── debug.md
    ├── help.md
    ├── update.md
    ├── whats-new.md
    └── web-search.md
```

**Namespacing**: Subdirectories show as "(project:phase)" in `/help`

---

## Recommendations

### Phase 4 Implementation Strategy

**Wave 1: Core Commands**
- Create slash commands for 6 core workflow commands
- These are most frequently used
- Include proper frontmatter and argument hints

**Wave 2: Management Commands**
- Create slash commands for phase, milestone, session management
- Use subdirectories for organization
- Total: 14 commands

**Wave 3: Utility Commands**
- Create slash commands for utilities
- Update documentation
- Total: 5 commands

### Command Template

```markdown
---
allowed-tools: [appropriate tools]
argument-hint: "[args if any]"
description: Brief one-line description
---

# /command-name

Read and follow the workflow at `.gsd/workflows/[workflow-name].md`.

**Arguments**: $ARGUMENTS

**Context**:
- @.gsd/workflows/[workflow-name].md
- @[other relevant files]

**Current State**:
!`git branch --show-current`
!`git status --short`

Follow the `<process>` section in the workflow file step by step.
```

### Testing Strategy

1. Create slash commands
2. Test each command with typical arguments
3. Verify workflow is followed correctly
4. Confirm file references work
5. Test bash pre-execution
6. Validate argument handling

---

## Open Questions

1. Should we use `context: fork` for any commands?
   - **Recommendation**: Only for `/map`, `/research-phase`, `/verify` (already have subagents)
   - Reason: Most commands need conversation context

2. Should we organize commands in subdirectories?
   - **Recommendation**: Yes, use phase/, milestone/, session/, util/
   - Reason: Better organization, clear namespacing in `/help`

3. How to handle commands that reference other commands?
   - **Recommendation**: Use file references `@.claude/commands/other.md`
   - Reason: Maintains relationships, allows composition

---

## References

- `resarch/slash.md` - Complete Kiro slash commands documentation
- `.gsd/workflows/*.md` - Existing workflow definitions
- `.gsd/COMMANDS.md` - Command reference

---

## Next Steps

Proceed to planning with this research as foundation. Create 3 waves of plans:
1. Core workflow commands (6)
2. Management commands (14)
3. Utility commands (5)
