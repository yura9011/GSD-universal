---
phase: 4
plan: 1
wave: 1
---

# Plan 4.1: Core Workflow Commands

## Objective

Create slash commands for the 6 core GSD workflow commands that reference existing workflow files.

## Context

- .gsd/workflows/new-project.md
- .gsd/workflows/map.md
- .gsd/workflows/plan.md
- .gsd/workflows/execute.md
- .gsd/workflows/verify.md
- .gsd/workflows/progress.md
- .gsd/phases/4/RESEARCH.md (migration strategy)

## Tasks

<task type="auto">
  <name>Create directory structure</name>
  <files>.claude/commands/</files>
  <action>
    Create `.claude/commands/` directory for project-level slash commands.
    
    WHY project-level: Commands are specific to GSD framework, should be shared with team via git.
  </action>
  <verify>dir .claude\commands</verify>
  <done>Directory exists</done>
</task>

<task type="auto">
  <name>Create /new-project command</name>
  <files>.claude/commands/new-project.md</files>
  <action>
    Create slash command that references new-project workflow:
    
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    description: Initialize new GSD project with deep questioning
    ---
    
    # /new-project
    
    Read and follow the workflow at `.gsd/workflows/new-project.md`.
    
    **Context**:
    - @.gsd/workflows/new-project.md
    - @.gsd/templates/SPEC.md
    - @.gsd/templates/ROADMAP.md
    
    Follow the `<process>` section step by step to create SPEC.md and ROADMAP.md.
    ```
    
    WHY no arguments: Interactive command that asks questions
    WHY these tools: Needs to read templates, write files, commit to git
  </action>
  <verify>type .claude\commands\new-project.md</verify>
  <done>Command file exists with correct frontmatter</done>
</task>

<task type="auto">
  <name>Create /map command</name>
  <files>.claude/commands/map.md</files>
  <action>
    Create slash command that references map workflow and uses map-explorer subagent:
    
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    description: Analyze codebase and create ARCHITECTURE.md
    ---
    
    # /map
    
    Read and follow the workflow at `.gsd/workflows/map.md`.
    
    **Context**:
    - @.gsd/workflows/map.md
    - @.gsd/templates/ARCHITECTURE.md
    
    **Current Project**:
    !`git branch --show-current`
    !`ls -la`
    
    **With Kiro**: Use map-explorer subagent for codebase analysis (99% context savings).
    
    Follow the `<process>` section to analyze codebase and create ARCHITECTURE.md.
    ```
    
    WHY bash pre-execution: Shows current branch and project structure
    WHY reference subagent: Reminds to use map-explorer for efficiency
  </action>
  <verify>type .claude\commands\map.md</verify>
  <done>Command file exists with bash pre-execution</done>
</task>

<task type="auto">
  <name>Create /plan command</name>
  <files>.claude/commands/plan.md</files>
  <action>
    Create slash command with phase number argument:
    
    ```markdown
    ---
    allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*)
    argument-hint: "[phase-number]"
    description: Create execution plans for a phase
    ---
    
    # /plan
    
    Read and follow the workflow at `.gsd/workflows/plan.md`.
    
    **Phase**: $1
    
    **Context**:
    - @.gsd/workflows/plan.md
    - @.gsd/ROADMAP.md
    - @.gsd/STATE.md
    - @.gsd/templates/phase-N-PLAN.md
    
    **Current State**:
    !`git branch --show-current`
    !`git status --short`
    
    Follow the `<process>` section to create execution plans for phase $1.
    ```
    
    WHY $1: First positional argument is phase number
    WHY argument-hint: Shows expected format in autocomplete
  </action>
  <verify>type .claude\commands\plan.md</verify>
  <done>Command file exists with argument handling</done>
</task>

<task type="auto">
  <name>Create /execute command</name>
  <files>.claude/commands/execute.md</files>
  <action>
    Create slash command for execution:
    
    ```markdown
    ---
    allowed-tools: Read, Write, Edit, Bash, Grep, Glob
    argument-hint: "[phase-number]"
    description: Execute phase plans with atomic commits
    ---
    
    # /execute
    
    Read and follow the workflow at `.gsd/workflows/execute.md`.
    
    **Phase**: $1
    
    **Context**:
    - @.gsd/workflows/execute.md
    - @.gsd/ROADMAP.md
    - @.gsd/STATE.md
    
    **Current State**:
    !`git branch --show-current`
    !`git status --short`
    !`ls .gsd/phases/$1/*.md`
    
    Follow the `<process>` section to execute all plans for phase $1 in wave order.
    Create atomic commits for each task.
    ```
    
    WHY all tools: Execution needs full capabilities
    WHY list plans: Shows what will be executed
  </action>
  <verify>type .claude\commands\execute.md</verify>
  <done>Command file exists with full tool access</done>
</task>

<task type="auto">
  <name>Create /verify command</name>
  <files>.claude/commands/verify.md</files>
  <action>
    Create slash command for verification:
    
    ```markdown
    ---
    allowed-tools: Read, Bash
    argument-hint: "[phase-number]"
    description: Validate phase implementation with empirical evidence
    ---
    
    # /verify
    
    Read and follow the workflow at `.gsd/workflows/verify.md`.
    
    **Phase**: $1
    
    **Context**:
    - @.gsd/workflows/verify.md
    - @.gsd/ROADMAP.md
    - @.gsd/STATE.md
    
    **Current State**:
    !`git branch --show-current`
    !`git diff --stat`
    !`ls .gsd/phases/$1/*-SUMMARY.md`
    
    **With Kiro**: Use verify-agent subagent for autonomous verification.
    
    Follow the `<process>` section to verify all must-haves with empirical evidence.
    ```
    
    WHY read + bash: Verification runs tests and checks
    WHY reference subagent: Reminds to use verify-agent
  </action>
  <verify>type .claude\commands\verify.md</verify>
  <done>Command file exists with verification tools</done>
</task>

<task type="auto">
  <name>Create /progress command</name>
  <files>.claude/commands/progress.md</files>
  <action>
    Create slash command for progress check:
    
    ```markdown
    ---
    allowed-tools: Read, Bash(git branch:*), Bash(git status:*)
    description: Show current position and next steps
    ---
    
    # /progress
    
    Read and follow the workflow at `.gsd/workflows/progress.md`.
    
    **Context**:
    - @.gsd/workflows/progress.md
    - @.gsd/ROADMAP.md
    - @.gsd/STATE.md
    
    **Current State**:
    !`git branch --show-current`
    !`git status --short`
    
    Follow the `<process>` section to display current progress and next steps.
    ```
    
    WHY limited tools: Read-only status command
    WHY git commands: Shows current branch and changes
  </action>
  <verify>type .claude\commands\progress.md</verify>
  <done>Command file exists with read-only tools</done>
</task>

## Success Criteria

- [ ] `.claude/commands/` directory exists
- [ ] All 6 core commands created with proper frontmatter
- [ ] Commands reference existing workflows
- [ ] Argument hints specified where needed
- [ ] Bash pre-execution included where useful
- [ ] File references use @ syntax
- [ ] Changes committed to git

## Notes

These are the most frequently used GSD commands. They maintain compatibility by referencing existing workflows while providing Kiro-specific enhancements (argument hints, bash pre-execution, file references).
