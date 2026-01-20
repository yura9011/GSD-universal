---
phase: 9
milestone: v1.2
researched: 2026-01-19
---

# Phase 2 Research: Configuration UI

## Objective
Research technical approaches for implementing configuration UI with system tray icon, config management, and audio device testing.

## Research Questions
1. How to implement system tray icon in Python (Windows)?
2. How to create tkinter UI with tabs?
3. How to save/load JSON configuration?
4. How to list and test audio devices?
5. How to migrate from config.py to config.json?

---

## 1. System Tray Icon (Windows)

### Library: pystray
**Best option for cross-platform system tray**

**Installation:**
```python
# requirements.txt
pystray>=0.19.0
Pillow>=10.0.0  # Required for icon images
```

**Basic Implementation:**
```python
from pystray import Icon, Menu, MenuItem
from PIL import Image, ImageDraw

def create_icon_image():
    # Create simple icon (can use .ico file instead)
    image = Image.new('RGB', (64, 64), color='blue')
    draw = ImageDraw.Draw(image)
    draw.rectangle([16, 16, 48, 48], fill='white')
    return image

def on_settings_clicked(icon, item):
    # Open config UI
    pass

def on_quit_clicked(icon, item):
    icon.stop()

# Create menu
menu = Menu(
    MenuItem('Settings', on_settings_clicked),
    MenuItem('Start/Stop', on_toggle_clicked),
    MenuItem('Quit', on_quit_clicked)
)

# Create and run icon
icon = Icon('VoiceTranslator', create_icon_image(), menu=menu)
icon.run()
```

**Pros:**
- Cross-platform (Windows, Mac, Linux)
- Simple API
- Integrates well with tkinter

**Cons:**
- Requires Pillow for icon creation
- Runs in separate thread

**Decision:** Use pystray for system tray implementation

---

## 2. Tkinter UI with Tabs

### Built-in: tkinter.ttk.Notebook

**Basic Implementation:**
```python
import tkinter as tk
from tkinter import ttk

root = tk.Tk()
root.title("Voice Translator Settings")

# Create notebook (tabs)
notebook = ttk.Notebook(root)
notebook.pack(fill='both', expand=True)

# Basic tab
basic_frame = ttk.Frame(notebook)
notebook.add(basic_frame, text='Basic')

# Advanced tab
advanced_frame = ttk.Frame(notebook)
notebook.add(advanced_frame, text='Advanced')

# Add widgets to tabs
ttk.Label(basic_frame, text="Hotkey:").grid(row=0, column=0)
hotkey_entry = ttk.Entry(basic_frame)
hotkey_entry.grid(row=0, column=1)

root.mainloop()
```

**Widgets Needed:**
- `ttk.Label` - Text labels
- `ttk.Entry` - Text input (hotkey)
- `ttk.Combobox` - Dropdowns (devices, languages, models)
- `ttk.Scale` - Sliders (VAD threshold, TTS rate)
- `ttk.Button` - Buttons (Save, Test, Reset)
- `ttk.Checkbutton` - Checkboxes (PTT enabled)

**Layout:** Use `grid()` for organized layout

**Decision:** Use ttk.Notebook for tabs, grid layout for widgets

---

## 3. JSON Configuration Management

### Built-in: json module

**Config Structure:**
```python
# config.json
{
    "ptt": {
        "enabled": true,
        "hotkey": "f1",
        "min_duration": 0.3,
        "max_duration": 10.0
    },
    "audio": {
        "input_device": "Microphone (Jabra EVOLVE 30 II)",
        "output_device": "CABLE Input (VB-Audio Virtual Cable)",
        "sample_rate": 16000
    },
    "translation": {
        "source_lang": "es",
        "target_lang": "pt"
    },
    "speech": {
        "whisper_model": "tiny",
        "vad_threshold": 0.5
    },
    "tts": {
        "rate": 150
    }
}
```

**Implementation:**
```python
import json
from pathlib import Path

CONFIG_FILE = Path("config.json")
DEFAULT_CONFIG = {
    "ptt": {"enabled": True, "hotkey": "f1", ...},
    ...
}

def load_config():
    """Load config from JSON, return defaults if not found."""
    if not CONFIG_FILE.exists():
        return DEFAULT_CONFIG.copy()
    
    try:
        with open(CONFIG_FILE, 'r') as f:
            return json.load(f)
    except json.JSONDecodeError:
        print("[WARNING] Invalid config.json, using defaults")
        return DEFAULT_CONFIG.copy()

def save_config(config):
    """Save config to JSON with backup."""
    # Backup existing config
    if CONFIG_FILE.exists():
        backup = Path("config.json.backup")
        CONFIG_FILE.rename(backup)
    
    # Save new config
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=4)
```

**Decision:** Use JSON for config storage with validation and backup

---

## 4. Audio Device Listing and Testing

### Existing: sounddevice library (already in requirements)

**List Devices:**
```python
import sounddevice as sd

def list_audio_devices():
    """Get list of audio devices."""
    devices = sd.query_devices()
    input_devices = []
    output_devices = []
    
    for idx, device in enumerate(devices):
        if device['max_input_channels'] > 0:
            input_devices.append({
                'index': idx,
                'name': device['name']
            })
        if device['max_output_channels'] > 0:
            output_devices.append({
                'index': idx,
                'name': device['name']
            })
    
    return input_devices, output_devices

def find_device_by_name(device_name):
    """Find device index by name."""
    devices = sd.query_devices()
    for idx, device in enumerate(devices):
        if device_name in device['name']:
            return idx
    return None
```

**Test Audio:**
```python
import numpy as np

def test_input_device(device_index, duration=2.0):
    """Test input device by recording."""
    try:
        recording = sd.rec(
            int(duration * 16000),
            samplerate=16000,
            channels=1,
            device=device_index
        )
        sd.wait()
        
        # Check if audio was captured
        if np.max(np.abs(recording)) > 0.01:
            return True, "Device working"
        else:
            return False, "No audio detected"
    except Exception as e:
        return False, str(e)

def test_output_device(device_index):
    """Test output device by playing tone."""
    try:
        # Generate 440Hz tone (A note)
        duration = 0.5
        frequency = 440
        t = np.linspace(0, duration, int(16000 * duration))
        tone = 0.3 * np.sin(2 * np.pi * frequency * t)
        
        sd.play(tone, samplerate=16000, device=device_index)
        sd.wait()
        
        return True, "Tone played"
    except Exception as e:
        return False, str(e)
```

**Decision:** Use sounddevice for device listing and testing (already available)

---

## 5. Migration from config.py to config.json

### Strategy: Gradual Migration

**Phase 2 Approach:**
1. Keep config.py as defaults source
2. Create config.json loader
3. Override defaults with JSON values
4. Update main.py to use JSON config

**Implementation:**
```python
# src/config_loader.py
import json
from pathlib import Path
import config as default_config

def load_config():
    """Load config from JSON, fallback to config.py defaults."""
    config_file = Path("config.json")
    
    # Start with defaults from config.py
    cfg = {
        'PTT_ENABLED': default_config.PTT_ENABLED,
        'PTT_HOTKEY': default_config.PTT_HOTKEY,
        'SOURCE_LANG': default_config.SOURCE_LANG,
        # ... all other settings
    }
    
    # Override with JSON if exists
    if config_file.exists():
        try:
            with open(config_file, 'r') as f:
                json_cfg = json.load(f)
                
            # Map JSON structure to flat config
            cfg['PTT_ENABLED'] = json_cfg.get('ptt', {}).get('enabled', cfg['PTT_ENABLED'])
            cfg['PTT_HOTKEY'] = json_cfg.get('ptt', {}).get('hotkey', cfg['PTT_HOTKEY'])
            # ... map all settings
        except Exception as e:
            print(f"[WARNING] Error loading config.json: {e}")
    
    return cfg
```

**Benefits:**
- Backward compatible (config.py still works)
- Gradual migration path
- Easy to test

**Decision:** Create config_loader.py to bridge config.py and config.json

---

## 6. UI Layout Design

### Basic Tab
```
┌─────────────────────────────────────┐
│ Basic Settings                      │
├─────────────────────────────────────┤
│                                     │
│ Hotkey:          [f1        ] [?]   │
│                                     │
│ Input Device:    [Microphone ▼]     │
│                  [Test Input]       │
│                                     │
│ Output Device:   [CABLE Input▼]     │
│                  [Test Output]      │
│                                     │
│ Source Language: [Spanish    ▼]     │
│ Target Language: [Portuguese ▼]     │
│                                     │
│ [Save & Restart]  [Reset Defaults]  │
└─────────────────────────────────────┘
```

### Advanced Tab
```
┌─────────────────────────────────────┐
│ Advanced Settings                   │
├─────────────────────────────────────┤
│                                     │
│ Whisper Model:   [tiny       ▼]     │
│                                     │
│ VAD Threshold:   [====|-----] 0.5   │
│                                     │
│ TTS Rate:        [====|-----] 150   │
│                                     │
│ Min Duration:    [0.3] seconds      │
│ Max Duration:    [10.0] seconds     │
│                                     │
│ [Save & Restart]  [Reset Defaults]  │
└─────────────────────────────────────┘
```

---

## Dependencies Summary

**New dependencies needed:**
```
pystray>=0.19.0      # System tray icon
Pillow>=10.0.0       # Icon image creation
```

**Existing dependencies (already available):**
```
sounddevice>=0.5.3   # Audio device management
keyboard>=0.13.5     # Hotkey detection (from Phase 1)
```

---

## Implementation Risks

### Risk 1: System tray thread conflicts
**Issue:** pystray runs in separate thread, tkinter in main thread
**Mitigation:** Use thread-safe queue for communication

### Risk 2: Config corruption
**Issue:** Invalid JSON breaks translator
**Mitigation:** Validation + backup + fallback to defaults

### Risk 3: Device name changes
**Issue:** Device names might change between sessions
**Mitigation:** Fuzzy matching + fallback to auto-detect

### Risk 4: Hotkey conflicts
**Issue:** User chooses hotkey used by game
**Mitigation:** Show warning for common game keys (F1-F12, Space, V)

---

## Recommended Implementation Order

**Wave 1: Config Management**
1. Create config_loader.py
2. Create config.json structure
3. Implement load/save with validation

**Wave 2: UI Foundation**
1. Create config_ui.py with tkinter
2. Implement Basic tab
3. Implement Advanced tab

**Wave 3: System Tray & Integration**
1. Implement system tray icon
2. Connect UI to system tray
3. Update main.py to use config.json
4. Add device testing

---

## Conclusion

All technical approaches are well-established and low-risk:
- pystray for system tray (proven library)
- tkinter for UI (built-in, simple)
- JSON for config (standard approach)
- sounddevice for audio testing (already in use)

**Estimated complexity:** Medium
**Estimated time:** 3-4 hours implementation
**Dependencies:** 2 new (pystray, Pillow)

Ready for planning phase.
