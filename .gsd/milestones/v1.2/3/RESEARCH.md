# Phase 3 Research: Visual Overlay

**Date**: 2026-01-19
**Phase**: 3 - Visual Overlay
**Objective**: Research transparent overlay implementation for Windows

## Problem Statement

Need to create a transparent, always-on-top overlay window that:
- Shows translator state (Idle, Recording, Processing, Sending)
- Stays visible over games and applications
- Is configurable (position, visibility)
- Has minimal performance impact
- Works on Windows

## Research Questions

1. What library should we use for transparent overlay on Windows?
2. How to make window always-on-top and click-through?
3. How to update overlay from background thread (translator)?
4. How to make it configurable (position, show/hide)?

## Options Evaluated

### Option 1: tkinter (Built-in)
**Pros:**
- Already using for config UI
- No new dependencies
- Cross-platform
- Simple API

**Cons:**
- Limited transparency control on Windows
- Can be clunky for overlays
- Not designed for gaming overlays

**Verdict:** ✅ RECOMMENDED - Good enough for v1.2, already in use

### Option 2: PyQt5/PySide6
**Pros:**
- Excellent transparency support
- Professional appearance
- Rich widget library

**Cons:**
- Large dependency (~50MB)
- Overkill for simple overlay
- Learning curve

**Verdict:** ❌ Too heavy for this use case

### Option 3: pygame
**Pros:**
- Good for gaming overlays
- Hardware accelerated

**Cons:**
- Not designed for UI overlays
- Requires game loop
- Overkill

**Verdict:** ❌ Wrong tool for the job

## Decision: tkinter with Transparency

Use tkinter with these techniques:
- `root.attributes('-alpha', 0.9)` for transparency
- `root.attributes('-topmost', True)` for always-on-top
- `root.overrideredirect(True)` for borderless window
- `root.attributes('-transparentcolor', 'black')` for click-through (Windows)

## Implementation Approach

### Architecture
```
OverlayWindow (tkinter.Toplevel)
├── State display (Label with colored background)
├── Position tracking (save to config)
└── Thread-safe updates (queue-based)
```

### State Colors
- **Idle**: Gray (#808080)
- **Recording**: Red (#FF0000)
- **Processing**: Yellow (#FFD700)
- **Sending**: Green (#00FF00)

### Configuration
Add to config.json:
```json
{
  "overlay": {
    "enabled": true,
    "position": {"x": 100, "y": 100},
    "opacity": 0.9,
    "size": {"width": 150, "height": 50}
  }
}
```

### Thread Safety
Use queue for state updates:
```python
# Translator thread
overlay_queue.put(("state", "Recording"))

# Overlay thread (tkinter main loop)
def check_queue():
    while not overlay_queue.empty():
        msg_type, value = overlay_queue.get()
        update_display(value)
    root.after(100, check_queue)
```

## Technical Decisions

### 1. Window Positioning
- Save position to config.json on drag
- Restore position on startup
- Default: top-right corner (x=screen_width-200, y=100)

### 2. Draggable Window
- Bind mouse events to title bar area
- Track drag offset
- Update position in real-time

### 3. Minimize/Hide
- Add small "X" button to hide
- Add to system tray menu: "Show/Hide Overlay"
- Save visibility state to config

### 4. Performance
- Update only on state change (not continuous)
- Use after() for queue checking (100ms interval)
- Minimal redraws

## Dependencies

None! tkinter is built-in to Python.

## Risks & Mitigations

**Risk 1**: Overlay blocks game input
- **Mitigation**: Use `-transparentcolor` for click-through on Windows
- **Fallback**: Make overlay very small and position in corner

**Risk 2**: Overlay not visible in fullscreen games
- **Mitigation**: Document that borderless windowed mode works best
- **Future**: Consider DirectX overlay (Phase 4+)

**Risk 3**: Thread safety issues with tkinter
- **Mitigation**: Use queue-based communication
- **Never** call tkinter methods from non-main thread

## Implementation Plan

### Wave 1: Basic Overlay
- Create OverlayWindow class
- Display current state with colors
- Always-on-top, borderless

### Wave 2: Configuration & Dragging
- Add overlay config to config.json
- Make window draggable
- Save/restore position

### Wave 3: Integration
- Connect to VoiceTranslator state changes
- Add overlay toggle to config UI
- Update main.py to launch overlay

## References

- tkinter transparency: `root.attributes('-alpha', value)`
- Always-on-top: `root.attributes('-topmost', True)`
- Borderless: `root.overrideredirect(True)`
- Click-through (Windows): `root.attributes('-transparentcolor', 'color')`

## Success Criteria

- [ ] Overlay shows 4 states with distinct colors
- [ ] Window stays on top of other applications
- [ ] Position is configurable and persistent
- [ ] Can be hidden/shown via config or hotkey
- [ ] No performance impact on translator
- [ ] Thread-safe state updates

---

**Conclusion**: tkinter is sufficient for v1.2 overlay. Simple, no new dependencies, cross-platform. Use queue-based communication for thread safety.
