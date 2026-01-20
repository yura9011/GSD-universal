---
phase: 1
plan: 2
wave: 2
---

# Plan 1.2: Document Limitation (If PyDirectInput Fails)

## Objective
If PyDirectInput test fails, document the limitation and update project documentation. This plan only executes if Plan 1.1 test returns "n".

## Context
- .gsd/phases/1/RESEARCH.md (with PyDirectInput test results)
- DECISIONS.md (ADR-001, ADR-002)
- README.md
- .gsd/phases/1/1-PLAN.md (PyDirectInput test results)

## Tasks

<task type="auto">
  <name>Create ADR-003 accepting limitation</name>
  <files>DECISIONS.md</files>
  <action>
    Add ADR-003 to DECISIONS.md:
    
    ```markdown
    ## ADR-003: Accept Auto-PTT Limitation with Discord
    
    **Date:** 2026-01-19
    **Status:** Accepted
    **Context:** Phase 1 Research - v1.2.1
    
    ### Problem
    Auto-PTT doesn't work with Discord or games with anti-cheat.
    
    ### Investigation
    Tested all available software approaches:
    - keyboard library: Blocked (Virtual Key Codes)
    - pyautogui library: Blocked (Virtual Key Codes)
    - pydirectinput library: Blocked (DirectInput scan codes)
    
    ### Root Cause
    Discord blocks ALL simulated keyboard input (both VK codes and scan codes)
    at driver/kernel level for security and anti-cheat purposes. This is
    intentional and cannot be bypassed with software-only solutions.
    
    ### Decision
    Accept the limitation and document clearly:
    - Auto-PTT is "best effort" feature
    - Works with apps that don't block simulated input
    - Doesn't work with Discord, most games with anti-cheat
    - Users should use manual PTT or VOX mode as alternatives
    
    ### Alternatives Considered
    - Hardware solution (Arduino USB HID): Works but requires hardware
    - Kernel driver (FakerInput): Blocked by anti-cheat systems
    - Remove feature: Rejected, may work in other contexts
    
    ### Consequences
    Feature stays in codebase with pyautogui but with clear documentation
    of limitations. Users are informed upfront.
    ```
  </action>
  <verify>grep "ADR-003" DECISIONS.md</verify>
  <done>ADR-003 created documenting limitation</done>
</task>

<task type="auto">
  <name>Update README.md with limitation details</name>
  <files>README.md</files>
  <action>
    Update the "Known Limitations" section in README.md:
    
    Add comprehensive explanation:
    - Tested multiple libraries (keyboard, pyautogui, pydirectinput)
    - All blocked by Discord's security measures
    - This is intentional security, not a bug
    - Suggest alternatives: manual PTT, VOX mode
    - Reference ADR-003 for technical details
    
    Emphasize that auto-PTT may work with other applications that
    don't have anti-cheat protection.
  </action>
  <verify>grep "ADR-003" README.md</verify>
  <done>README.md updated with complete limitation explanation</done>
</task>

## Success Criteria
- [ ] ADR-003 created with complete findings
- [ ] README.md updated with limitation details
- [ ] Clear guidance for users on alternatives
- [ ] Phase 1 research complete
