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
