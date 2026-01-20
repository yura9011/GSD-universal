---
phase: 4
plan: 2
wave: 2
---

# Plan 4.2: Management Commands (Phase & Milestone)

## Objective

Create slash commands for phase management (6) and milestone management (4) commands using subdirectory organization.

## Context

- .gsd/workflows/discuss-phase.md
- .gsd/workflows/research-phase.md
- .gsd/workflows/add-phase.md
- .gsd/workflows/insert-phase.md
- .gsd/workflows/remove-phase.md
- .gsd/workflows/list-phase-assumptions.md
- .gsd/workflows/new-milestone.md
- .gsd/workflows/complete-milestone.md
- .gsd/workflows/audit-milestone.md
- .gsd/workflows/plan-milestone-gaps.md
- .gsd/phases/4/RESEARCH.md (subdirectory organization)

## Tasks

<task type="auto">
  <name>Create phase management subdirectory</name>
  <files>.claude/commands/phase/</files>
  <action>
    Create `.claude/commands/phase/` subdirectory for phase management commands.
    
    WHY subdirectory: Groups related commands, shows as "(project:phase)" in /help
  </action>
  <verify>dir .claude\commands\phase</verify>
  <done>Subdirectory exists</done>
</task>

<task type="auto">
  <name>Create phase management commands</name>
  <files>
    .claude/commands/phase/discuss.md
    .claude/commands/phase/research.md
    .claude/commands/phase/add.md
    .claude/commands/phase/insert.md
    .claude/commands/phase/remove.md
    .claude/commands/phase/list-assumptions.md
  </files>
  <action>
    Create 6 phase management commands:
    
    **discuss.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    argument-hint: "[phase-number]"
    description: Clarify phase scope before planning
    ---
    
    # /discuss-phase
    
    Read and follow the workflow at `.gsd/workflows/discuss-phase.md`.
    
    **Phase**: $1
    
    **Context**:
    - @.gsd/workflows/discuss-phase.md
    - @.gsd/ROADMAP.md
    
    Follow the `<process>` section to capture implementation preferences.
    ```
    
    **research.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    argument-hint: "[phase-number]"
    description: Conduct technical research for phase planning
    ---
    
    # /research-phase
    
    Read and follow the workflow at `.gsd/workflows/research-phase.md`.
    
    **Phase**: $1
    
    **Context**:
    - @.gsd/workflows/research-phase.md
    - @.gsd/ROADMAP.md
    - @.gsd/ARCHITECTURE.md
    
    **With Kiro**: Use research-agent subagent for context-efficient research.
    
    Follow the `<process>` section to conduct research and create RESEARCH.md.
    ```
    
    **add.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    description: Add new phase to ROADMAP.md
    ---
    
    # /add-phase
    
    Read and follow the workflow at `.gsd/workflows/add-phase.md`.
    
    **Context**:
    - @.gsd/workflows/add-phase.md
    - @.gsd/ROADMAP.md
    
    Follow the `<process>` section to add a new phase.
    ```
    
    **insert.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    argument-hint: "[position]"
    description: Insert phase at specific position
    ---
    
    # /insert-phase
    
    Read and follow the workflow at `.gsd/workflows/insert-phase.md`.
    
    **Position**: $1
    
    **Context**:
    - @.gsd/workflows/insert-phase.md
    - @.gsd/ROADMAP.md
    
    Follow the `<process>` section to insert phase at position $1.
    ```
    
    **remove.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    argument-hint: "[phase-number]"
    description: Remove phase from ROADMAP.md
    ---
    
    # /remove-phase
    
    Read and follow the workflow at `.gsd/workflows/remove-phase.md`.
    
    **Phase**: $1
    
    **Context**:
    - @.gsd/workflows/remove-phase.md
    - @.gsd/ROADMAP.md
    
    Follow the `<process>` section to remove phase $1.
    ```
    
    **list-assumptions.md**:
    ```markdown
    ---
    allowed-tools: Read, Grep
    description: List all phase assumptions from plans
    ---
    
    # /list-phase-assumptions
    
    Read and follow the workflow at `.gsd/workflows/list-phase-assumptions.md`.
    
    **Context**:
    - @.gsd/workflows/list-phase-assumptions.md
    - @.gsd/ROADMAP.md
    
    Follow the `<process>` section to extract and list assumptions.
    ```
    
    WHY separate files: Each command has different arguments and tools
    WHY in phase/: Groups related commands together
  </action>
  <verify>dir .claude\commands\phase\*.md</verify>
  <done>All 6 phase commands exist</done>
</task>

<task type="auto">
  <name>Create milestone management subdirectory</name>
  <files>.claude/commands/milestone/</files>
  <action>
    Create `.claude/commands/milestone/` subdirectory for milestone management commands.
    
    WHY subdirectory: Groups milestone commands, shows as "(project:milestone)" in /help
  </action>
  <verify>dir .claude\commands\milestone</verify>
  <done>Subdirectory exists</done>
</task>

<task type="auto">
  <name>Create milestone management commands</name>
  <files>
    .claude/commands/milestone/new.md
    .claude/commands/milestone/complete.md
    .claude/commands/milestone/audit.md
    .claude/commands/milestone/plan-gaps.md
  </files>
  <action>
    Create 4 milestone management commands:
    
    **new.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    argument-hint: "[name]"
    description: Create new milestone with phases
    ---
    
    # /new-milestone
    
    Read and follow the workflow at `.gsd/workflows/new-milestone.md`.
    
    **Milestone Name**: $ARGUMENTS
    
    **Context**:
    - @.gsd/workflows/new-milestone.md
    - @.gsd/templates/milestone.md
    - @.gsd/ROADMAP.md
    
    Follow the `<process>` section to create milestone: $ARGUMENTS
    ```
    
    **complete.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    description: Archive completed milestone
    ---
    
    # /complete-milestone
    
    Read and follow the workflow at `.gsd/workflows/complete-milestone.md`.
    
    **Context**:
    - @.gsd/workflows/complete-milestone.md
    - @.gsd/ROADMAP.md
    - @.gsd/STATE.md
    
    **Current Milestone**:
    !`grep "Current Milestone" .gsd/STATE.md`
    
    Follow the `<process>` section to complete and archive milestone.
    ```
    
    **audit.md**:
    ```markdown
    ---
    allowed-tools: Read, Bash(git log:*)
    description: Review milestone quality and completeness
    ---
    
    # /audit-milestone
    
    Read and follow the workflow at `.gsd/workflows/audit-milestone.md`.
    
    **Context**:
    - @.gsd/workflows/audit-milestone.md
    - @.gsd/ROADMAP.md
    
    **Recent Commits**:
    !`git log --oneline -20`
    
    Follow the `<process>` section to audit milestone.
    ```
    
    **plan-gaps.md**:
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    description: Create plans to close milestone gaps
    ---
    
    # /plan-milestone-gaps
    
    Read and follow the workflow at `.gsd/workflows/plan-milestone-gaps.md`.
    
    **Context**:
    - @.gsd/workflows/plan-milestone-gaps.md
    - @.gsd/ROADMAP.md
    
    Follow the `<process>` section to identify and plan gap closure.
    ```
    
    WHY $ARGUMENTS for new: Milestone name can be multiple words
    WHY bash pre-execution: Shows current state for context
  </action>
  <verify>dir .claude\commands\milestone\*.md</verify>
  <done>All 4 milestone commands exist</done>
</task>

## Success Criteria

- [ ] `phase/` subdirectory exists with 6 commands
- [ ] `milestone/` subdirectory exists with 4 commands
- [ ] All commands have proper frontmatter
- [ ] Commands reference existing workflows
- [ ] Argument hints specified where needed
- [ ] Subdirectory organization working
- [ ] Changes committed to git

## Notes

Subdirectory organization provides clear namespacing in `/help`:
- Phase commands show as "(project:phase)"
- Milestone commands show as "(project:milestone)"

This makes it easy to discover related commands.
