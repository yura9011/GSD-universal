---
phase: 8
milestone: v1.2
updated: 2026-01-19
---

# Phase 1 Research: Hotkey System & Recording Control

## Objective
Research best library for global hotkey detection on Windows and push-to-talk implementation strategy.

## Discovery Level: 2 (Standard Research)
- Choosing between keyboard libraries
- Medium-risk decision (can be changed if needed)
- Need to verify Windows compatibility

## Options Evaluated

### Option 1: keyboard (boppreh/keyboard)
**Source:** https://github.com/boppreh/keyboard

**Pros:**
- Global hotkey support on Windows and Linux
- Simple API: `keyboard.is_pressed('f1')`, `keyboard.on_press_key()`
- Can hook specific keys without blocking
- Can simulate key presses (useful for auto-PTT)
- Widely used, 3.5k+ stars on GitHub

**Cons:**
- Project currently unmaintained (as of 2024)
- Requires admin/root privileges on some systems
- May have compatibility issues with some games

**API Example:**
```python
import keyboard

# Hook specific key
keyboard.on_press_key('f1', lambda _: start_recording())
keyboard.on_release_key('f1', lambda _: stop_recording())

# Or check if pressed
if keyboard.is_pressed('f1'):
    # Recording...
```

### Option 2: pynput
**Source:** https://pypi.org/project/pynput/

**Pros:**
- Cross-platform (Windows, Mac, Linux)
- Actively maintained
- Can monitor and control keyboard/mouse
- More stable, fewer permission issues

**Cons:**
- More complex API for hotkeys
- Requires manual combination detection
- Slightly higher overhead

**API Example:**
```python
from pynput import keyboard

def on_press(key):
    if key == keyboard.Key.f1:
        start_recording()

def on_release(key):
    if key == keyboard.Key.f1:
        stop_recording()

listener = keyboard.Listener(on_press=on_press, on_release=on_release)
listener.start()
```

### Option 3: PyHotKey
**Source:** https://github.com/Xpp521/PyHotKey

**Pros:**
- Built on top of pynput
- Simpler hotkey API
- Cross-platform

**Cons:**
- Less mature (newer project)
- Smaller community
- May have bugs

## Decision: keyboard library

**Rationale:**
1. **Simplest API** for push-to-talk: `on_press_key()` and `on_release_key()`
2. **Can simulate keypresses** - essential for auto-PTT feature (Phase 4)
3. **Proven in gaming context** - used by many gaming tools
4. **Windows-first** - our primary target platform
5. **Easy to replace** if issues arise (low coupling)

**Mitigation for "unmaintained" concern:**
- Library is feature-complete for our needs
- Can fork if critical bugs found
- Alternative (pynput) available as fallback

## Push-to-Talk Architecture

### Current Architecture (v1.1)
```
[Microphone] → [Continuous Capture] → [VAD] → [Whisper] → [Translation] → [TTS] → [VB-Cable]
```

### New Architecture (v1.2)
```
[Hotkey Press] → [Start Recording] → [Buffer Audio] → [Hotkey Release] → [Process Pipeline]
                                                                           ↓
[VB-Cable] ← [TTS] ← [Translation] ← [Whisper] ← [Accumulated Audio]
```

### Implementation Strategy

**1. Recording State Machine:**
```
IDLE → (hotkey press) → RECORDING → (hotkey release) → PROCESSING → SENDING → IDLE
```

**2. Audio Buffering:**
- Use existing `AudioBuffer` class
- Accumulate chunks while hotkey pressed
- Process accumulated audio on release

**3. Integration Points:**
- Modify `VoiceTranslator` class to support PTT mode
- Add `recording_mode` config: "continuous" or "ptt"
- Keep VAD for noise filtering (optional in PTT mode)

**4. Configuration:**
- Default hotkey: F1 (configurable)
- Minimum recording duration: 0.3s (avoid accidental taps)
- Maximum recording duration: 10s (safety limit)

## Dependencies

```python
# requirements.txt additions
keyboard>=0.13.5  # Global hotkey support
```

## Implementation Notes

**Thread Safety:**
- Hotkey callbacks run in separate thread
- Use threading.Event for state coordination
- Queue for audio chunks (already implemented)

**Error Handling:**
- Graceful fallback if keyboard library fails
- User notification if admin privileges needed
- Timeout for stuck recording state

**Testing:**
- Unit tests for state machine
- Integration test with mock keyboard events
- Manual testing with actual hotkey

## References

- keyboard library: https://github.com/boppreh/keyboard
- pynput library: https://pypi.org/project/pynput/
- Push-to-talk pattern: Common in Discord, TeamSpeak, Mumble

## Next Steps

1. Install keyboard library
2. Create PTT controller class
3. Integrate with existing VoiceTranslator
4. Add configuration for hotkey selection
5. Test with real microphone and hotkey

---

*Research completed: 2026-01-19*
