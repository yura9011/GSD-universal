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
