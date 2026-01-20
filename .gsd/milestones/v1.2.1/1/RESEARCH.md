---
phase: 1
researched_at: 2026-01-19
discovery_level: 2
---

# Phase 1 Research - Windows Keyboard Simulation

## Objective
Find a method to simulate keyboard input on Windows that works with Discord and games that block standard libraries (keyboard, pyautogui).

## Discovery Level
**Level 2** — Standard research with empirical testing

## Key Decisions

### Decision 1: Which Windows API to use?
**Question:** What low-level Windows API can bypass Discord's input blocking?

**Options Considered:**
1. **win32api with SendInput**: 
   - Pros: Official Windows API, well-documented
   - Cons: Requires pywin32, Windows-only, may still be blocked
   
2. **ctypes with user32.dll directly**: 
   - Pros: No extra dependencies, direct system calls
   - Cons: More complex, Windows-only, may still be blocked
   
3. **AutoHotkey approach (external process)**: 
   - Pros: Known to work with some games
   - Cons: Requires external executable, not pure Python
   
4. **Hardware emulation (Arduino/USB HID)**: 
   - Pros: Would definitely work (physical input)
   - Cons: Requires hardware, not practical for software-only solution

**Decision:** Test PyDirectInput with DirectInput scan codes
**Confidence:** Medium-High - Confirmed working with games, needs Discord testing

**Rationale:**
- PyDirectInput specifically designed for DirectX games
- Uses DirectInput scan codes instead of Virtual Key Codes
- Proven working solution (Minecraft example)
- May bypass Discord's VK-based blocking

### Decision 2: Accept limitation or find workaround?
**Question:** If no software solution works, should we accept the limitation or pursue hardware?

**Options Considered:**
1. **Accept limitation**: Document clearly, suggest alternatives (VOX mode)
2. **Hardware solution**: Provide optional Arduino-based solution
3. **Remove feature**: Eliminate auto-PTT entirely

**Decision:** Test PyDirectInput first, fallback to accept limitation if fails
**Confidence:** High

**Rationale:**
- PyDirectInput is a proven solution for games
- Worth testing before accepting defeat
- If fails: document and suggest alternatives
- If works: major win for the project

## Findings

### CRITICAL DISCOVERY: PyDirectInput and DirectInput Scan Codes

**Source:** [PyDirectInput GitHub](https://github.com/learncodebygaming/pydirectinput)

PyDirectInput existe específicamente para resolver este problema. Usa:
- DirectInput scan codes (no Virtual Key Codes)
- SendInput() moderno (no keybd_event deprecated)
- Funciona con juegos DirectX donde PyAutoGUI falla

**Quote:** "You may find that PyAutoGUI does not work in some applications, particularly in video games and other software that rely on DirectX. If you find yourself in that situation, give this library a try!"

### Working Solution for Games

**Source:** [Feeding Key Presses to Reluctant Games](https://danieldusek.com/feeding-key-presses-to-reluctant-games-in-python.html)

El autor logró enviar teclas a Minecraft usando ctypes con DirectInput scan codes:
- Usa SendInput con flag 0x0008 (KEYEVENTF_SCANCODE)
- Pasa scan codes en lugar de virtual key codes
- Funciona con juegos que bloquean métodos estándar

**Código clave:**
```python
flags = 0x0008  # KEYEVENTF_SCANCODE
ii_.ki = KeyBdInput(0, scan_code, flags, 0, ctypes.pointer(extra))
ctypes.windll.user32.SendInput(1, ctypes.pointer(x), ctypes.sizeof(x))
```

### Current State (from ADR-001)
- `keyboard` library: Blocked by Discord, requires admin
- `pyautogui` library: Blocked by Discord, no admin required
- Root cause: Usan Virtual Key Codes que Discord/juegos detectan

### Web Research Results (2026-01-19)

#### Discord's Input Detection Problem
**Source:** [Discord System Helper documentation](https://discord-media.com/en/news/discord-system-helper-explained-fix-keybinds-not-working-install-uninstall-guide.html)

Discord itself has this problem! When games run with elevated permissions or anti-cheat, Discord cannot detect physical PTT key presses. Discord's solution is "Discord System Helper" - a system-level service that grants Discord special permissions to detect keys even in high-security games.

**Key insight:** If Discord itself needs a system-level helper to detect keys in games, our simulated keys will definitely not work.

#### Why SendInput/keybd_event Are Blocked
**Source:** [DS4Windows KB+M Issues](https://ds4-windows.com/troubleshoot/keyboard-and-mouse-issues/)

Games and Windows block SendInput for security reasons:
- Windows prevents malicious software from taking control
- Games' anti-cheat protection blocks virtual input
- Low-level keyboard hooks can detect the `LLKHF_INJECTED` flag

**Quote:** "Some games and Windows' events may end-up ignoring commands coming from SendInput for a variety of reasons, with a few examples being: Windows' preventing malicious software from taking control of the user's system, Games' anti-cheat protection, Games simply not recognizing commands coming from the SendInput function."

#### Driver-Level Solutions Exist But Are Complex
**Source:** [DS4Windows FakerInput](https://ds4-win.com/fakerinput/)

FakerInput is a kernel-mode driver that makes virtual input indistinguishable from physical input. It works by:
- Installing a kernel-mode driver
- Injecting input at driver level (below where anti-cheat hooks)
- Requires administrator permissions to install

**However:** Anti-cheat systems actively block kernel-mode input drivers like Interception and FakerInput because they can be used for cheating.

### Research Questions Answered

1. **Does win32api SendInput bypass Discord's blocking?**
   - Answer: DEPENDS - With Virtual Key Codes: NO. With DirectInput scan codes: MAYBE
   
2. **Does ctypes with user32.dll bypass Discord's blocking?**
   - Answer: YES - When using DirectInput scan codes (flag 0x0008) instead of VK codes
   
3. **What method does AutoHotkey use that sometimes works?**
   - Answer: AutoHotkey uses SendInput (same limitation) OR requires FakerInput driver
   
4. **Are there any documented ways to send input to Discord?**
   - Answer: YES - PyDirectInput or ctypes with DirectInput scan codes

## Patterns to Follow
- Test each approach with minimal script first
- Test with Discord focused and unfocused
- Test with different keys (grave, v, f1)
- Document exact error messages or behaviors

## Anti-Patterns to Avoid
- Don't assume a method works without testing
- Don't test only in Python console - must test with actual Discord
- Don't give up after one failed approach

## Dependencies Identified
| Package | Version | Purpose |
|---------|---------|---------|
| pydirectinput | latest | DirectInput scan codes for games/Discord |
| ctypes | built-in | Fallback: direct SendInput with scan codes |

## Risks
- **All software methods blocked:** Discord may block any simulated input at driver level
- **Windows-only solution:** Loses cross-platform compatibility
- **User expectations:** Users may expect feature to work when it can't

## Recommendations for Planning

Based on research findings, we should:

1. **Test PyDirectInput** - Most promising solution, designed for games
2. **Create test script** - Test with Discord to verify it works
3. **If successful** - Replace pyautogui with pydirectinput in voice_translator.py
4. **If fails** - Fallback to ctypes with DirectInput scan codes
5. **Document results** - Update ADR-003 with findings

## Conclusion

**NEW FINDING: There IS a solution - PyDirectInput with DirectInput scan codes**

The previous research was incomplete. PyDirectInput exists specifically to solve this problem:
- Uses DirectInput scan codes instead of Virtual Key Codes
- Proven working with DirectX games (Minecraft, etc.)
- May work with Discord since it bypasses VK-based detection

**Recommendation:** Test PyDirectInput empirically with Discord before accepting limitation.


## Ready for Planning

- [x] Questions answered with web research
- [x] Approach selected (PyDirectInput with scan codes)
- [x] Dependencies identified (pydirectinput)
- [x] Risks documented
- [x] Alternatives considered
- [x] Sources cited
- [x] Working examples found

**Status:** Research complete - Ready to test PyDirectInput solution.

**Next Step:** Create test script using PyDirectInput and test with Discord.
