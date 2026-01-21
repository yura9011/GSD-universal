---
phase: 1
plan: 2
wave: 1
---

# Plan 1.2: Essential Ralph Files

## Objective
Create the core Ralph files that define autonomous agent behavior: AGENTS.md operational manual and IMPLEMENTATION_PLAN.md task tracker. These files provide the persistent state and operational instructions that enable Ralph's autonomous execution.

## Context
- .gsd/phases/1/RESEARCH.md
- ROADMAP.md
- .gsd/templates/ (existing GSD templates)
- scripts/validate-all.sh (for AGENTS.md validation commands)

## Tasks

<task type="auto">
  <name>Create AGENTS.md operational manual</name>
  <files>AGENTS.md</files>
  <action>
    Create the operational manual following Geoffrey Huntley's exact specifications:
    - Under 60 lines total (critical for context efficiency)
    - Contains ONLY operational commands and project conventions
    - Includes validation commands for backpressure system
    - References existing GSD validation scripts (./scripts/validate-all.sh)
    - Project-specific build/test/lint commands
    - NO status updates, progress notes, or logs (those go in IMPLEMENTATION_PLAN.md)
    
    Structure based on research:
    ## Validation Commands (Backpressure)
    ## Project Conventions
    ## Build/Test Commands
    
    What to avoid and WHY:
    - Status tracking or progress logs (pollutes every loop iteration)
    - Complex instructions (keep operational only)
    - Bloated content over 60 lines (degrades context quality)
  </action>
  <verify>wc -l AGENTS.md | grep -E "^[1-5][0-9]|^[1-9]" && grep -q "validate-all" AGENTS.md</verify>
  <done>AGENTS.md exists, under 60 lines, contains validation commands, no status content</done>
</task>

<task type="auto">
  <name>Create IMPLEMENTATION_PLAN.md task tracker</name>
  <files>IMPLEMENTATION_PLAN.md</files>
  <action>
    Create the dynamic task tracker that serves as Ralph's shared state between iterations:
    - Initialize with Phase 1 tasks from ROADMAP.md
    - Use checkbox format for task tracking (- [ ] Task name)
    - Include task priorities and dependencies
    - Structure for easy updates by autonomous agents
    - Clear sections for: Current Tasks, Completed Tasks, Discovered Issues
    - Template for adding new tasks discovered during execution
    
    This file replaces conversation memory - it's how Ralph remembers what to do next.
    
    What to avoid and WHY:
    - Static task lists (must be updateable by agents)
    - Complex formatting (simple checkboxes work best)
    - Detailed implementation notes (keep task-focused)
  </action>
  <verify>grep -q "Phase 1" IMPLEMENTATION_PLAN.md && grep -q "\- \[ \]" IMPLEMENTATION_PLAN.md</verify>
  <done>IMPLEMENTATION_PLAN.md exists with Phase 1 tasks in checkbox format</done>
</task>

<task type="auto">
  <name>Create specs directory structure</name>
  <files>specs/roadmap.md, specs/architecture.md</files>
  <action>
    Create Ralph's specs/ directory with GSD integration:
    - Copy ROADMAP.md content to specs/roadmap.md (Ralph's requirements source)
    - Create specs/architecture.md from existing ARCHITECTURE.md if it exists
    - If no ARCHITECTURE.md exists, create minimal placeholder
    - Ensure specs/ contains static requirements that don't change during execution
    - Link back to original GSD files for consistency
    
    The specs/ directory provides Ralph with stable requirements that persist across iterations.
    
    What to avoid and WHY:
    - Duplicating dynamic content (specs should be static requirements)
    - Breaking links to original GSD files (maintain compatibility)
    - Complex spec structures (simple markdown files work best)
  </action>
  <verify>test -d specs && test -f specs/roadmap.md && grep -q "Phase 1" specs/roadmap.md</verify>
  <done>specs/ directory exists with roadmap.md containing Phase 1 requirements</done>
</task>

## Success Criteria
- [ ] AGENTS.md under 60 lines with validation commands only
- [ ] IMPLEMENTATION_PLAN.md tracks Phase 1 tasks with checkboxes
- [ ] specs/ directory contains static requirements from GSD
- [ ] All files follow exact Ralph repository patterns
- [ ] Integration maintains compatibility with existing GSD structure
- [ ] Files provide complete operational context for autonomous execution