---
phase: 4
plan: 3
wave: 3
---

# Plan 4.3: Session & Utility Commands + Documentation

## Objective

Create slash commands for session management (4) and utility commands (5), then update documentation.

## Context

- .gsd/workflows/pause.md
- .gsd/workflows/resume.md
- .gsd/workflows/add-todo.md
- .gsd/workflows/check-todos.md
- .gsd/workflows/debug.md
- .gsd/workflows/help.md
- .gsd/workflows/update.md
- .gsd/workflows/whats-new.md
- .gsd/workflows/web-search.md
- .gsd/SYSTEM.md
- .gsd/COMMANDS.md

## Tasks

<task type="auto">
  <name>Create session management subdirectory</name>
  <files>.claude/commands/session/</files>
  <action>
    Create `.claude/commands/session/` subdirectory for session management commands.
    
    WHY subdirectory: Groups session commands, shows as "(project:session)" in /help
  </action>
  <verify>dir .claude\commands\session</verify>
  <done>Subdirectory exists</done>
</task>

<task type="auto">
  <name>Create session management commands</name>
  <files>
    .claude/commands/session/pause.md
    .claude/commands/session/resume.md
    .claude/commands/session/add-todo.md
    .claude/commands/session/check-todos.md
  </files>
  <action>
    Create 4 session management commands:
    
    **pause.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    description: Save state for session handoff
    ---
    
    # /pause
    
    Read and follow the workflow at `.gsd/workflows/pause.md`.
    
    **Context**:
    - @.gsd/workflows/pause.md
    - @.gsd/STATE.md
    - @.gsd/JOURNAL.md
    
    **Current State**:
    !`git branch --show-current`
    !`git status --short`
    
    Follow the `<process>` section to save session state.
    ```
    
    **resume.md**:
    ```markdown
    ---
    allowed-tools: Read
    description: Restore from last session
    ---
    
    # /resume
    
    Read and follow the workflow at `.gsd/workflows/resume.md`.
    
    **Context**:
    - @.gsd/workflows/resume.md
    - @.gsd/STATE.md
    - @.gsd/JOURNAL.md
    
    **Last Session**:
    !`tail -20 .gsd/JOURNAL.md`
    
    Follow the `<process>` section to restore session context.
    ```
    
    **add-todo.md**:
    ```markdown
    ---
    allowed-tools: Write, Bash(git add:*), Bash(git commit:*)
    argument-hint: "[description]"
    description: Capture idea for later
    ---
    
    # /add-todo
    
    Read and follow the workflow at `.gsd/workflows/add-todo.md`.
    
    **Description**: $ARGUMENTS
    
    **Context**:
    - @.gsd/workflows/add-todo.md
    
    Follow the `<process>` section to create TODO: $ARGUMENTS
    ```
    
    **check-todos.md**:
    ```markdown
    ---
    allowed-tools: Read, Glob
    description: List pending TODO items
    ---
    
    # /check-todos
    
    Read and follow the workflow at `.gsd/workflows/check-todos.md`.
    
    **Context**:
    - @.gsd/workflows/check-todos.md
    
    **Existing TODOs**:
    !`ls .todos/*.md 2>/dev/null || echo "No TODOs"`
    
    Follow the `<process>` section to list all TODOs.
    ```
    
    WHY different tools: Each command has specific needs
    WHY bash pre-execution: Shows current state or existing items
  </action>
  <verify>dir .claude\commands\session\*.md</verify>
  <done>All 4 session commands exist</done>
</task>

<task type="auto">
  <name>Create utility commands subdirectory</name>
  <files>.claude/commands/util/</files>
  <action>
    Create `.claude/commands/util/` subdirectory for utility commands.
    
    WHY subdirectory: Groups utility commands, shows as "(project:util)" in /help
  </action>
  <verify>dir .claude\commands\util</verify>
  <done>Subdirectory exists</done>
</task>

<task type="auto">
  <name>Create utility commands</name>
  <files>
    .claude/commands/util/debug.md
    .claude/commands/util/help.md
    .claude/commands/util/update.md
    .claude/commands/util/whats-new.md
    .claude/commands/util/web-search.md
  </files>
  <action>
    Create 5 utility commands:
    
    **debug.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash, Grep
    argument-hint: "[description]"
    description: Systematic debugging with 3-strike rule
    ---
    
    # /debug
    
    Read and follow the workflow at `.gsd/workflows/debug.md`.
    
    **Issue**: $ARGUMENTS
    
    **Context**:
    - @.gsd/workflows/debug.md
    - @.gsd/STATE.md
    
    **Current State**:
    !`git status --short`
    !`git diff --stat`
    
    Follow the `<process>` section to debug: $ARGUMENTS
    ```
    
    **help.md**:
    ```markdown
    ---
    allowed-tools: Read
    description: Show all GSD commands and usage
    ---
    
    # /help
    
    Read and follow the workflow at `.gsd/workflows/help.md`.
    
    **Context**:
    - @.gsd/workflows/help.md
    - @.gsd/COMMANDS.md
    - @.gsd/SYSTEM.md
    
    Follow the `<process>` section to display help.
    ```
    
    **update.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git pull:*), Bash(git fetch:*)
    description: Update GSD system files
    ---
    
    # /update
    
    Read and follow the workflow at `.gsd/workflows/update.md`.
    
    **Context**:
    - @.gsd/workflows/update.md
    
    **Current Version**:
    !`cat VERSION`
    
    Follow the `<process>` section to update GSD system.
    ```
    
    **whats-new.md**:
    ```markdown
    ---
    allowed-tools: Read
    description: Show recent changes and new features
    ---
    
    # /whats-new
    
    Read and follow the workflow at `.gsd/workflows/whats-new.md`.
    
    **Context**:
    - @.gsd/workflows/whats-new.md
    - @CHANGELOG.md
    
    **Recent Changes**:
    !`head -50 CHANGELOG.md`
    
    Follow the `<process>` section to display recent changes.
    ```
    
    **web-search.md**:
    ```markdown
    ---
    allowed-tools: WebSearch, WebFetch, Write
    argument-hint: "[query]"
    description: Search web and document findings
    ---
    
    # /web-search
    
    Read and follow the workflow at `.gsd/workflows/web-search.md`.
    
    **Query**: $ARGUMENTS
    
    **Context**:
    - @.gsd/workflows/web-search.md
    
    Follow the `<process>` section to search: $ARGUMENTS
    ```
    
    WHY different tools: Each utility has specific requirements
    WHY web-search tools: Needs web access for searching
  </action>
  <verify>dir .claude\commands\util\*.md</verify>
  <done>All 5 utility commands exist</done>
</task>

<task type="auto">
  <name>Create commands README</name>
  <files>.claude/commands/README.md</files>
  <action>
    Create comprehensive README for slash commands:
    
    ```markdown
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
    ```
    
    WHY comprehensive: Helps users discover and understand commands
    WHY compatibility section: Explains relationship to workflows
  </action>
  <verify>type .claude\commands\README.md</verify>
  <done>README exists with complete documentation</done>
</task>

<task type="auto">
  <name>Update GSD SYSTEM.md</name>
  <files>.gsd/SYSTEM.md</files>
  <action>
    Add section about slash commands to SYSTEM.md after "Kiro Subagents" section:
    
    ```markdown
    ## Kiro Slash Commands
    
    GSD commands are available as Kiro slash commands in `.claude/commands/`:
    
    **Core Workflow**: `/new-project`, `/map`, `/plan`, `/execute`, `/verify`, `/progress`
    **Phase Management**: `/discuss-phase`, `/research-phase`, `/add-phase`, etc.
    **Milestone Management**: `/new-milestone`, `/complete-milestone`, `/audit-milestone`, etc.
    **Session Management**: `/pause`, `/resume`, `/add-todo`, `/check-todos`
    **Utilities**: `/debug`, `/help`, `/update`, `/whats-new`, `/web-search`
    
    All slash commands reference workflows in `.gsd/workflows/` for compatibility.
    
    **With Kiro**: Use slash commands for argument hints and bash pre-execution
    **Without Kiro**: Use workflows directly
    
    See `.claude/commands/README.md` for complete documentation.
    ```
    
    WHY after subagents: Logical grouping of Kiro-specific features
    WHY reference workflows: Emphasizes portability
  </action>
  <verify>findstr /C:"Kiro Slash Commands" .gsd\SYSTEM.md</verify>
  <done>SYSTEM.md references slash commands</done>
</task>

## Success Criteria

- [ ] `session/` subdirectory exists with 4 commands
- [ ] `util/` subdirectory exists with 5 commands
- [ ] All commands have proper frontmatter
- [ ] Commands README created
- [ ] SYSTEM.md updated with slash commands section
- [ ] All 25 commands functional
- [ ] Changes committed to git

## Notes

Phase 4 complete! All 25 GSD commands now available as Kiro slash commands:
- 6 core workflow
- 6 phase management
- 4 milestone management
- 4 session management
- 5 utilities

Commands maintain compatibility by referencing existing workflows.
