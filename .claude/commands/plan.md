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
