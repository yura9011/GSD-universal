---
phase: 1
plan: 3
wave: 2
---

# Plan 1.3: Implement PyDirectInput Solution (If Test Succeeds)

## Objective
If PyDirectInput test succeeds, replace pyautogui with pydirectinput in voice_translator.py and update documentation. This plan only executes if Plan 1.1 test returns "y".

## Context
- .gsd/phases/1/RESEARCH.md (with successful PyDirectInput test)
- src/voice_translator.py (currently using pyautogui)
- src/config_ui.py (test button using pyautogui)
- requirements.txt

## Tasks

<task type="auto">
  <name>Replace pyautogui with pydirectinput in voice_translator.py</name>
  <files>src/voice_translator.py</files>
  <action>
    Update auto-PTT implementation:
    
    1. Change import:
       FROM: import pyautogui
       TO: import pydirectinput
    
    2. Update _press_game_ptt method:
       FROM: pyautogui.keyDown(ptt_key)
       TO: pydirectinput.keyDown(ptt_key)
    
    3. Update _release_game_ptt method:
       FROM: pyautogui.keyUp(ptt_key)
       TO: pydirectinput.keyUp(ptt_key)
    
    WHY: PyDirectInput uses DirectInput scan codes that work with
    Discord/games where PyAutoGUI fails.
    
    AVOID: Don't change any other logic, just swap the library.
  </action>
  <verify>grep "import pydirectinput" src/voice_translator.py</verify>
  <done>voice_translator.py using pydirectinput for auto-PTT</done>
</task>

<task type="auto">
  <name>Update config UI test button</name>
  <files>src/config_ui.py</files>
  <action>
    Update test_game_ptt method in GameIntegrationTab:
    
    Change import at top of file:
    FROM: import pyautogui
    TO: import pydirectinput
    
    Update test button logic:
    FROM: pyautogui.keyDown(ptt_key) / pyautogui.keyUp(ptt_key)
    TO: pydirectinput.keyDown(ptt_key) / pydirectinput.keyUp(ptt_key)
    
    WHY: Keep test button consistent with actual implementation.
  </action>
  <verify>grep "import pydirectinput" src/config_ui.py</verify>
  <done>config_ui.py test button using pydirectinput</done>
</task>

<task type="auto">
  <name>Create ADR-003 documenting solution</name>
  <files>DECISIONS.md</files>
  <action>
    Add ADR-003 to DECISIONS.md:
    
    ```markdown
    ## ADR-003: PyDirectInput for Auto-PTT Implementation
    
    **Date:** 2026-01-19
    **Status:** Accepted
    **Context:** Phase 1 Research - v1.2.1
    
    ### Problem
    Previous attempts with keyboard and pyautogui libraries failed with Discord.
    
    ### Investigation
    Tested PyDirectInput - a library specifically designed for DirectX games:
    - Uses DirectInput scan codes (not Virtual Key Codes)
    - Uses modern SendInput() function
    - Proven working with games like Half-Life 2, Minecraft
    - Test with Discord: SUCCESS
    
    ### Decision
    Replace pyautogui with pydirectinput because:
    - Works with Discord (empirically verified)
    - No additional dependencies beyond pip install
    - Same API as pyautogui (easy migration)
    - Better compatibility with games
    
    ### Implementation
    - Replace pyautogui imports with pydirectinput
    - Update voice_translator.py auto-PTT methods
    - Update config_ui.py test button
    - Update requirements.txt
    
    ### Consequences
    **Positive:**
    - Auto-PTT now works with Discord!
    - Better game compatibility
    - Solves the core problem
    
    **Negative:**
    - Windows-only solution (DirectInput is Windows API)
    - May still fail with some anti-cheat systems
    ```
  </action>
  <verify>grep "ADR-003" DECISIONS.md</verify>
  <done>ADR-003 created documenting PyDirectInput solution</done>
</task>

<task type="auto">
  <name>Update README.md with success</name>
  <files>README.md</files>
  <action>
    Update the "Known Limitations" section in README.md:
    
    REMOVE or UPDATE the limitation note about auto-PTT not working.
    
    ADD new section explaining the solution:
    - Auto-PTT now works with Discord using PyDirectInput
    - Uses DirectInput scan codes instead of Virtual Key Codes
    - Windows-only feature (DirectInput is Windows API)
    - May not work with some anti-cheat systems
    - Reference ADR-003 for technical details
  </action>
  <verify>grep "PyDirectInput" README.md</verify>
  <done>README.md updated with PyDirectInput solution</done>
</task>

## Success Criteria
- [ ] pydirectinput replaces pyautogui in voice_translator.py
- [ ] pydirectinput replaces pyautogui in config_ui.py
- [ ] ADR-003 created documenting solution
- [ ] README.md updated with success story
- [ ] Phase 1 complete with working solution!
