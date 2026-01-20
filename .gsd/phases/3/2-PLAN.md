---
phase: 3
plan: 2
wave: 2
milestone: v1.2
---

# Plan 3.2: Draggable Overlay with Position Persistence

## Objective
Make overlay window draggable and save position to config.json, allowing users to position the overlay wherever they want on screen and have it remember that position.

## Context
- src/overlay_window.py - Basic overlay (from Plan 3.1)
- src/config_loader.py - Config management
- .gsd/phases/3/RESEARCH.md - Dragging implementation

## Tasks

<task type="auto">
  <name>Add dragging functionality to OverlayWindow</name>
  <files>src/overlay_window.py</files>
  <action>
Update OverlayWindow class to support dragging:

1. **Add instance variables in __init__:**
```python
        self.drag_start_x = 0
        self.drag_start_y = 0
        self.on_position_changed = None  # Callback for position changes
```

2. **Add drag methods:**
```python
    def _start_drag(self, event):
        """Start dragging the window."""
        self.drag_start_x = event.x
        self.drag_start_y = event.y
    
    def _on_drag(self, event):
        """Handle window dragging."""
        x = self.root.winfo_x() + event.x - self.drag_start_x
        y = self.root.winfo_y() + event.y - self.drag_start_y
        self.root.geometry(f"+{x}+{y}")
    
    def _stop_drag(self, event):
        """Stop dragging and save position."""
        x = self.root.winfo_x()
        y = self.root.winfo_y()
        
        # Update config
        if 'overlay' not in self.config:
            self.config['overlay'] = {}
        if 'position' not in self.config['overlay']:
            self.config['overlay']['position'] = {}
        
        self.config['overlay']['position']['x'] = x
        self.config['overlay']['position']['y'] = y
        
        # Call callback if set
        if self.on_position_changed:
            self.on_position_changed(x, y)
```

3. **Bind mouse events in create_window() after creating state_label:**
```python
        # Make window draggable
        self.state_label.bind('<Button-1>', self._start_drag)
        self.state_label.bind('<B1-Motion>', self._on_drag)
        self.state_label.bind('<ButtonRelease-1>', self._stop_drag)
```

4. **Add method to save position:**
```python
    def save_position(self):
        """Save current position to config file."""
        from config_loader import save_config
        x = self.root.winfo_x() if self.root else 0
        y = self.root.winfo_y() if self.root else 0
        
        if 'overlay' not in self.config:
            self.config['overlay'] = {}
        if 'position' not in self.config['overlay']:
            self.config['overlay']['position'] = {}
        
        self.config['overlay']['position']['x'] = x
        self.config['overlay']['position']['y'] = y
        
        save_config(self.config)
        print(f"[INFO] Overlay position saved: ({x}, {y})")
```

IMPORTANT:
- Bind to state_label (the visible widget)
- Update config dict immediately on drag
- Save to file only when explicitly called
- Use winfo_x() and winfo_y() for current position
  </action>
  <verify>python -m py_compile src/overlay_window.py</verify>
  <done>Dragging functionality added with position persistence</done>
</task>

<task type="auto">
  <name>Add overlay toggle to config UI</name>
  <files>src/config_ui.py</files>
  <action>
Update ConfigUI to add overlay settings in Advanced tab:

1. **In _create_advanced_tab(), add after TTS rate:**
```python
        # Overlay enabled
        ttk.Label(parent, text="Show Overlay:").grid(row=5, column=0, sticky='w', pady=5)
        self.overlay_enabled_var = tk.BooleanVar()
        ttk.Checkbutton(parent, variable=self.overlay_enabled_var).grid(row=5, column=1, sticky='w')
        
        # Overlay opacity
        ttk.Label(parent, text="Overlay Opacity:").grid(row=6, column=0, sticky='w', pady=5)
        self.overlay_opacity_var = tk.DoubleVar()
        opacity_scale = ttk.Scale(parent, from_=0.5, to=1.0, orient='horizontal', 
                                 variable=self.overlay_opacity_var, length=200)
        opacity_scale.grid(row=6, column=1, sticky='w')
        self.opacity_label = ttk.Label(parent, text="0.9")
        self.opacity_label.grid(row=6, column=2)
        opacity_scale.configure(command=lambda v: self.opacity_label.configure(text=f"{float(v):.2f}"))
```

2. **In _load_values(), add:**
```python
        # Overlay settings
        overlay_cfg = self.config.get('overlay', {})
        self.overlay_enabled_var.set(overlay_cfg.get('enabled', True))
        self.overlay_opacity_var.set(overlay_cfg.get('opacity', 0.9))
```

3. **In _save_config(), add before save_config() call:**
```python
        # Overlay settings
        if 'overlay' not in self.config:
            self.config['overlay'] = {'position': {'x': 100, 'y': 100}, 'size': {'width': 150, 'height': 50}}
        self.config['overlay']['enabled'] = self.overlay_enabled_var.get()
        self.config['overlay']['opacity'] = self.overlay_opacity_var.get()
```

IMPORTANT:
- Add to Advanced tab (row 5 and 6)
- Initialize overlay dict if not exists
- Preserve position and size when saving
- Use checkbox for enabled, slider for opacity
  </action>
  <verify>python -m py_compile src/config_ui.py</verify>
  <done>Overlay settings added to configuration UI</done>
</task>

## Success Criteria
- [ ] Overlay window can be dragged with mouse
- [ ] Position is saved to config.json on drag
- [ ] Position is restored on next launch
- [ ] Config UI has overlay enable/disable toggle
- [ ] Config UI has overlay opacity slider
- [ ] Settings persist across restarts
