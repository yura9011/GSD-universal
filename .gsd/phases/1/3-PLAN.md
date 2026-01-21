---
phase: 1
plan: 3
wave: 2
---

# Plan 1.3: Prompt Templates & Testing

## Objective
Create the PROMPT_build.md and PROMPT_plan.md templates that define autonomous agent behavior, and validate the complete Ralph Loop system. These prompts are the "DNA" of Ralph - they get injected into every iteration and determine how the AI behaves autonomously.

## Context
- .gsd/phases/1/RESEARCH.md
- AGENTS.md (from Plan 1.2)
- IMPLEMENTATION_PLAN.md (from Plan 1.2)
- specs/ (from Plan 1.2)
- loop.sh, loop.ps1 (from Plan 1.1)

## Tasks

<task type="auto">
  <name>Create PROMPT_build.md template</name>
  <files>PROMPT_build.md</files>
  <action>
    Create the build mode prompt following Geoffrey Huntley's exact template structure:
    - Phase 0 (0a, 0b, 0c): Orient by studying specs, IMPLEMENTATION_PLAN.md, source code
    - Phase 1-4: Main instructions for implementation, validation, commit
    - 999... numbering system for guardrails (higher number = more critical)
    - Exact subagent patterns: up to 500 Sonnet for searches, 1 for build/tests, Opus for reasoning
    - Integration with GSD validation scripts in guardrails
    - Atomic commit instructions with proper git workflow
    
    Copy exact template from research with GSD-specific adaptations:
    - Reference specs/roadmap.md instead of generic specs
    - Use ./scripts/validate-all.sh for validation
    - Maintain exact 999... guardrail numbering system
    
    What to avoid and WHY:
    - Changing the proven prompt structure (exact replication is critical)
    - Adding GSD-specific complexity (keep Ralph's simplicity)
    - Modifying guardrail numbering (system is precisely tuned)
  </action>
  <verify>grep -q "0a\. Study" PROMPT_build.md && grep -q "999999999999" PROMPT_build.md</verify>
  <done>PROMPT_build.md exists with exact Geoffrey Huntley template structure and GSD integration</done>
</task>

<task type="auto">
  <name>Create PROMPT_plan.md template</name>
  <files>PROMPT_plan.md</files>
  <action>
    Create the planning mode prompt for generating/updating IMPLEMENTATION_PLAN.md:
    - Study specs/ to understand requirements
    - Analyze current IMPLEMENTATION_PLAN.md state
    - Generate new tasks or update existing ones
    - Prioritize tasks by dependencies and importance
    - Update IMPLEMENTATION_PLAN.md with findings
    - Commit changes with descriptive message
    
    Planning mode is simpler than build mode - focused on task generation and prioritization.
    
    What to avoid and WHY:
    - Implementation instructions in planning mode (that's build mode's job)
    - Complex planning algorithms (simple task breakdown works best)
    - Overwriting existing valid tasks (update, don't replace)
  </action>
  <verify>grep -q "IMPLEMENTATION_PLAN.md" PROMPT_plan.md && grep -q "specs" PROMPT_plan.md</verify>
  <done>PROMPT_plan.md exists and focuses on task planning and IMPLEMENTATION_PLAN.md updates</done>
</task>

<task type="auto">
  <name>Test complete Ralph Loop system</name>
  <files>test-ralph.sh, test-ralph.ps1</files>
  <action>
    Create test scripts that validate the complete Ralph Loop system:
    - Test loop.sh and loop.ps1 help functionality
    - Verify all required files exist (AGENTS.md, PROMPT_*.md, specs/, IMPLEMENTATION_PLAN.md)
    - Test mode switching (plan/build)
    - Validate integration with existing GSD validation scripts
    - Test error handling and exit codes
    - Verify cross-platform compatibility
    - Create dry-run mode that doesn't call AI but validates file structure
    
    These tests ensure Ralph is properly configured before first autonomous run.
    
    What to avoid and WHY:
    - Testing actual AI execution (too expensive for validation)
    - Complex integration tests (focus on file structure and basic functionality)
    - Platform-specific tests (ensure cross-platform compatibility)
  </action>
  <verify>chmod +x test-ralph.sh && ./test-ralph.sh --dry-run</verify>
  <done>Test scripts exist, are executable, and validate complete Ralph Loop system setup</done>
</task>

## Success Criteria
- [ ] PROMPT_build.md follows exact Geoffrey Huntley template with GSD integration
- [ ] PROMPT_plan.md enables autonomous task planning and updates
- [ ] Test scripts validate complete Ralph Loop system configuration
- [ ] All prompt templates use exact 999... guardrail numbering system
- [ ] Integration with existing GSD validation scripts confirmed
- [ ] Cross-platform compatibility verified through testing
- [ ] System ready for first autonomous execution test