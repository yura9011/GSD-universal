---
phase: 1
plan: 1
wave: 1
---

# Plan 1.1: Test PyDirectInput Approach

## Objective
Test if PyDirectInput with DirectInput scan codes can work with Discord. PyDirectInput was specifically created to work with DirectX games where PyAutoGUI fails.

## Context
- .gsd/phases/1/RESEARCH.md (updated with PyDirectInput findings)
- DECISIONS.md (ADR-001, ADR-002)
- test_pydirectinput_ptt.py (already created)

## Tasks

<task type="auto">
  <name>Install pydirectinput dependency</name>
  <files>requirements.txt</files>
  <action>
    Add pydirectinput to requirements.txt:
    - Add line: pydirectinput>=1.0.4
    - Install with: pip install pydirectinput
    - Verify installation with: python -c "import pydirectinput; print('OK')"
    
    WHY PyDirectInput:
    - Uses DirectInput scan codes (not Virtual Key Codes)
    - Designed specifically for DirectX games
    - Proven working with games where PyAutoGUI fails
  </action>
  <verify>python -c "import pydirectinput; print('OK')"</verify>
  <done>pydirectinput imported successfully without errors</done>
</task>

<task type="checkpoint:human-verify">
  <name>Run PyDirectInput test with Discord</name>
  <files>test_pydirectinput_ptt.py</files>
  <action>
    User must run the test script manually:
    1. Open Discord
    2. Configure PTT to grave key (`) if not already
    3. Run: python test_pydirectinput_ptt.py
    4. Watch Discord PTT indicator during 2-second test
    5. Answer y/n when prompted
    
    IMPORTANT: This MUST be tested by the user because:
    - Discord must be running and focused
    - Visual verification of PTT indicator required
    - Cannot be automated
    
    EXPECTED: PyDirectInput should work since it uses DirectInput scan codes
  </action>
  <verify>User reports test result (y/n)</verify>
  <done>Test completed and result documented in RESEARCH.md</done>
</task>

## Success Criteria
- [ ] pydirectinput installed and working
- [ ] test_pydirectinput_ptt.py executed with Discord running
- [ ] Result documented (works or doesn't work)
- [ ] If works: Ready to implement in voice_translator.py (Plan 1.3)
- [ ] If fails: Ready to accept limitation and document (Plan 1.2)
