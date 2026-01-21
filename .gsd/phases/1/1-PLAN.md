---
phase: 1
plan: 1
wave: 1
---

# Plan 1.1: Core Loop Scripts

## Objective
Implement the fundamental Ralph Loop scripts (loop.sh and loop.ps1) that provide autonomous execution capabilities. These scripts form the heart of the Ralph system - simple bash/PowerShell loops that repeatedly execute AI prompts until completion.

## Context
- .gsd/phases/1/RESEARCH.md
- ROADMAP.md
- scripts/validate-all.sh (existing GSD validation)
- scripts/validate-all.ps1 (existing GSD validation)

## Tasks

<task type="auto">
  <name>Create loop.sh for Linux/Mac</name>
  <files>loop.sh</files>
  <action>
    Create bash script implementing Geoffrey Huntley's exact Ralph Loop pattern:
    - Simple while loop that feeds PROMPT.md to AI CLI
    - Mode switching support (plan/build via command line argument)
    - Max iterations parameter for safety (default 50)
    - Auto git push after each successful iteration
    - Error handling for AI CLI failures
    - Sleep between iterations to prevent rate limiting
    - Exit codes for different failure modes
    
    Use exact pattern from research: `while :; do cat PROMPT_${MODE}.md | $AI_CLI ; done`
    
    What to avoid and WHY:
    - Complex orchestration logic (Ralph's power is in simplicity)
    - Conversation state management (fresh context is the key)
    - Multi-agent coordination (single process only)
  </action>
  <verify>chmod +x loop.sh && ./loop.sh --help</verify>
  <done>loop.sh exists, is executable, shows help text, and accepts plan/build modes</done>
</task>

<task type="auto">
  <name>Create loop.ps1 for Windows</name>
  <files>loop.ps1</files>
  <action>
    Create PowerShell equivalent of loop.sh with identical functionality:
    - PowerShell while loop feeding PROMPT.md to AI CLI
    - Same mode switching and parameter support as bash version
    - Windows-compatible path handling and command execution
    - Equivalent error handling and exit codes
    - Auto git push functionality
    - Cross-platform compatibility with shared prompt files
    
    Maintain exact same interface as bash version for consistency.
    
    What to avoid and WHY:
    - PowerShell-specific features that break cross-platform compatibility
    - Different parameter names or behavior from bash version
    - Complex Windows-specific integrations
  </action>
  <verify>powershell -ExecutionPolicy Bypass -File loop.ps1 -Help</verify>
  <done>loop.ps1 exists, shows help text, and accepts same parameters as loop.sh</done>
</task>

<task type="auto">
  <name>Add validation integration</name>
  <files>loop.sh, loop.ps1</files>
  <action>
    Integrate existing GSD validation scripts as Ralph's backpressure system:
    - Add validation hooks that run ./scripts/validate-all.sh (Linux/Mac)
    - Add validation hooks that run ./scripts/validate-all.ps1 (Windows)
    - Validation runs after each AI iteration before marking complete
    - If validation fails, loop continues with error context
    - If validation passes, task marked complete and committed
    - Log validation results for debugging
    
    This leverages existing GSD infrastructure as Ralph's quality gates.
    
    What to avoid and WHY:
    - Creating new validation systems (use existing GSD scripts)
    - Skipping validation to speed up iterations (defeats Ralph's purpose)
    - Complex validation orchestration (simple pass/fail only)
  </action>
  <verify>grep -q "validate-all" loop.sh && grep -q "validate-all" loop.ps1</verify>
  <done>Both scripts integrate with existing GSD validation and show validation status</done>
</task>

## Success Criteria
- [ ] loop.sh executes autonomous iterations with mode switching
- [ ] loop.ps1 provides identical functionality on Windows
- [ ] Both scripts integrate with existing GSD validation scripts
- [ ] Scripts handle errors gracefully and provide clear exit codes
- [ ] Cross-platform compatibility verified
- [ ] Help documentation shows proper usage