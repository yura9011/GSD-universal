---
phase: 3
plan: 1
wave: 1
milestone: v1.2
---

# Plan 3.1: Basic Overlay Window

## Objective
Create transparent, always-on-top overlay window that displays translator state with color-coded visual feedback. This provides the foundation for user awareness of what the translator is doing.

## Context
- .gsd/phases/3/RESEARCH.md - Overlay implementation research
- src/config_loader.py - Config management (for overlay settings)
- ROADMAP.md - Phase 3 requirements

## Tasks

<task type="auto">
  <name>Create overlay_window.py with OverlayWindow class</name>
  <files>src/overlay_window.py</files>
  <action>
Create src/overlay_window.py with OverlayWindow class:

**Class Structure:**
```python
import tkinter as tk
from tkinter import ttk
import queue
import threading

class OverlayWindow:
    """Transparent overlay window for translator state display."""
    
    # State colors
    STATE_COLORS = {
        'idle': '#808080',      # Gray
        'recording': '#FF0000',  # Red
        'processing': '#FFD700', # Yellow
        'sending': '#00FF00'     # Green
    }
    
    STATE_TEXT = {
        'idle': 'Idle',
        'recording': 'Recording',
        'processing': 'Processing',
        'sending': 'Sending'
    }
    
    def __init__(self, config):
        """Initialize overlay window.
        
        Args:
            config: Configuration dictionary with overlay settings
        """
        self.config = config
        self.state_queue = queue.Queue()
        self.current_state = 'idle'
        
        # Create window in main thread
        self.root = None
        self.state_label = None
        self.is_running = False
    
    def create_window(self):
        """Create the overlay window (must be called from main thread)."""
        self.root = tk.Toplevel()
        self.root.title("Voice Translator")
        
        # Get config values
        overlay_cfg = self.config.get('overlay', {})
        width = overlay_cfg.get('size', {}).get('width', 150)
        height = overlay_cfg.get('size', {}).get('height', 50)
        x = overlay_cfg.get('position', {}).get('x', 100)
        y = overlay_cfg.get('position', {}).get('y', 100)
        opacity = overlay_cfg.get('opacity', 0.9)
        
        # Set window properties
        self.root.geometry(f"{width}x{height}+{x}+{y}")
        self.root.overrideredirect(True)  # Borderless
        self.root.attributes('-topmost', True)  # Always on top
        self.root.attributes('-alpha', opacity)  # Transparency
        
        # Create state label
        self.state_label = tk.Label(
            self.root,
            text=self.STATE_TEXT['idle'],
            font=('Arial', 12, 'bold'),
            fg='white',
            bg=self.STATE_COLORS['idle'],
            width=20,
            height=2
        )
        self.state_label.pack(fill='both', expand=True)
        
        # Start queue checker
        self.check_queue()
        
        self.is_running = True
    
    def check_queue(self):
        """Check for state updates from other threads."""
        if not self.is_running:
            return
        
        try:
            while not self.state_queue.empty():
                state = self.state_queue.get_nowait()
                self._update_display(state)
        except queue.Empty:
            pass
        
        # Check again in 100ms
        if self.root:
            self.root.after(100, self.check_queue)
    
    def _update_display(self, state):
        """Update the display with new state (main thread only)."""
        if state not in self.STATE_COLORS:
            return
        
        self.current_state = state
        
        if self.state_label:
            self.state_label.config(
                text=self.STATE_TEXT[state],
                bg=self.STATE_COLORS[state]
            )
    
    def set_state(self, state):
        """Set overlay state (thread-safe).
        
        Args:
            state: One of 'idle', 'recording', 'processing', 'sending'
        """
        self.state_queue.put(state)
    
    def show(self):
        """Show the overlay window."""
        if self.root:
            self.root.deiconify()
    
    def hide(self):
        """Hide the overlay window."""
        if self.root:
            self.root.withdraw()
    
    def destroy(self):
        """Destroy the overlay window."""
        self.is_running = False
        if self.root:
            self.root.destroy()


def main():
    """Test overlay window."""
    import time
    from config_loader import DEFAULT_CONFIG
    
    # Create root window (required for Toplevel)
    root = tk.Tk()
    root.withdraw()  # Hide root
    
    # Create overlay
    config = DEFAULT_CONFIG.copy()
    config['overlay'] = {
        'enabled': True,
        'position': {'x': 100, 'y': 100},
        'size': {'width': 150, 'height': 50},
        'opacity': 0.9
    }
    
    overlay = OverlayWindow(config)
    overlay.create_window()
    
    # Test state changes
    def test_states():
        states = ['idle', 'recording', 'processing', 'sending']
        for i, state in enumerate(states * 3):
            time.sleep(1)
            overlay.set_state(state)
            print(f"[TEST] State: {state}")
    
    # Run test in background thread
    test_thread = threading.Thread(target=test_states, daemon=True)
    test_thread.start()
    
    # Run tkinter main loop
    root.mainloop()


if __name__ == "__main__":
    main()
```

IMPORTANT:
- Use queue for thread-safe state updates
- Never call tkinter methods from non-main thread
- Use after() for periodic queue checking
- Borderless, always-on-top, transparent
- No emojis in display text
  </action>
  <verify>python -m py_compile src/overlay_window.py</verify>
  <done>overlay_window.py created with OverlayWindow class and state display</done>
</task>

<task type="auto">
  <name>Add overlay config to DEFAULT_CONFIG</name>
  <files>src/config_loader.py</files>
  <action>
Update DEFAULT_CONFIG in src/config_loader.py to include overlay settings:

Add after the "tts" section:
```python
    "tts": {
        "rate": 150
    },
    "overlay": {
        "enabled": True,
        "position": {"x": 100, "y": 100},
        "size": {"width": 150, "height": 50},
        "opacity": 0.9
    }
```

Also update validate_config() to validate overlay section:
```python
    # Validate overlay section
    overlay = config.get("overlay", {})
    if not isinstance(overlay.get("enabled"), bool):
        return False, "overlay.enabled must be boolean"
    if "position" not in overlay:
        return False, "overlay.position is required"
    if "size" not in overlay:
        return False, "overlay.size is required"
    if not isinstance(overlay.get("opacity"), (int, float)):
        return False, "overlay.opacity must be number"
```

IMPORTANT:
- Maintain existing structure
- Add validation for all overlay fields
- Keep default position in top-left area
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); from config_loader import DEFAULT_CONFIG; assert 'overlay' in DEFAULT_CONFIG; print('[OK] overlay config added')"</verify>
  <done>Overlay configuration added to DEFAULT_CONFIG with validation</done>
</task>

## Success Criteria
- [ ] OverlayWindow class creates transparent window
- [ ] Window is always-on-top and borderless
- [ ] Displays 4 states with correct colors
- [ ] Thread-safe state updates via queue
- [ ] Overlay config in DEFAULT_CONFIG
- [ ] Config validation includes overlay section
