---
phase: 9
plan: 3
wave: 3
milestone: v1.2
---

# Plan 9.3: System Tray Integration & Main Update

## Objective
Integrate system tray icon with config UI, update main.py to use config.json, and add device testing functionality. This completes the Configuration UI phase.

## Context
- src/config_loader.py - Config management (from Plan 9.1)
- src/config_ui.py - UI implementation (from Plan 9.2)
- src/main.py - Current main entry point
- .gsd/phases/9/RESEARCH.md - System tray implementation

## Tasks

<task type="auto">
  <name>Create system_tray.py with icon and menu</name>
  <files>src/system_tray.py</files>
  <action>
Create src/system_tray.py with SystemTray class:

```python
import pystray
from PIL import Image, ImageDraw
import threading
import sys
import os

sys.path.insert(0, os.path.dirname(__file__))

class SystemTray:
    """System tray icon for voice translator."""
    
    def __init__(self, on_settings, on_start_stop, on_quit):
        """
        Initialize system tray.
        
        Args:
            on_settings: Callback when Settings clicked
            on_start_stop: Callback when Start/Stop clicked
            on_quit: Callback when Quit clicked
        """
        self.on_settings = on_settings
        self.on_start_stop = on_start_stop
        self.on_quit = on_quit
        
        self.icon = None
        self.is_running = False
    
    def create_icon_image(self):
        """Create simple icon image."""
        # Create 64x64 blue icon with white 'VT' text
        image = Image.new('RGB', (64, 64), color='#2196F3')
        draw = ImageDraw.Draw(image)
        
        # Draw simple microphone icon
        draw.rectangle([24, 20, 40, 44], fill='white')
        draw.ellipse([20, 16, 44, 24], fill='white')
        
        return image
    
    def _on_settings_clicked(self, icon, item):
        """Handle Settings menu click."""
        if self.on_settings:
            self.on_settings()
    
    def _on_start_stop_clicked(self, icon, item):
        """Handle Start/Stop menu click."""
        if self.on_start_stop:
            self.on_start_stop()
        
        # Toggle state
        self.is_running = not self.is_running
        
        # Update menu
        self._update_menu()
    
    def _on_quit_clicked(self, icon, item):
        """Handle Quit menu click."""
        if self.on_quit:
            self.on_quit()
        
        icon.stop()
    
    def _update_menu(self):
        """Update menu based on state."""
        start_stop_text = "Stop" if self.is_running else "Start"
        
        self.icon.menu = pystray.Menu(
            pystray.MenuItem('Settings', self._on_settings_clicked),
            pystray.MenuItem(start_stop_text, self._on_start_stop_clicked),
            pystray.MenuItem('Quit', self._on_quit_clicked)
        )
    
    def start(self):
        """Start system tray icon."""
        # Create menu
        self._update_menu()
        
        # Create icon
        self.icon = pystray.Icon(
            'VoiceTranslator',
            self.create_icon_image(),
            'Voice Translator',
            self.icon.menu
        )
        
        # Run in separate thread
        thread = threading.Thread(target=self.icon.run, daemon=True)
        thread.start()
        
        print("[INFO] System tray icon started")
    
    def stop(self):
        """Stop system tray icon."""
        if self.icon:
            self.icon.stop()

def main():
    """Test system tray."""
    def on_settings():
        print("[TEST] Settings clicked")
    
    def on_start_stop():
        print("[TEST] Start/Stop clicked")
    
    def on_quit():
        print("[TEST] Quit clicked")
    
    tray = SystemTray(on_settings, on_start_stop, on_quit)
    tray.start()
    
    # Keep running
    import time
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        tray.stop()

if __name__ == "__main__":
    main()
```

IMPORTANT:
- Use pystray for cross-platform support
- Run icon in separate thread
- Simple icon design (can improve later)
- Clear menu items
- Thread-safe callbacks
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); from system_tray import SystemTray; print('[OK] SystemTray imports successfully')"</verify>
  <done>system_tray.py created with icon and menu</done>
</task>

<task type="auto">
  <name>Update main.py to use config.json and add --config flag</name>
  <files>src/main.py</files>
  <action>
Update src/main.py to integrate config.json:

1. **Add imports at top:**
```python
from config_loader import load_config
from pathlib import Path
```

2. **Add --config flag to argument parser:**
```python
parser.add_argument(
    '--config',
    action='store_true',
    help='Open configuration UI'
)
```

3. **Handle --config flag before main logic:**
```python
# Handle config UI
if args.config:
    print("[INFO] Opening configuration UI...")
    from config_ui import ConfigUI
    ui = ConfigUI()
    ui.run()
    return 0
```

4. **Load config.json at start of main():**
```python
# Load configuration
config = load_config()

# Check if config.json exists, if not open UI
config_file = Path("config.json")
if not config_file.exists():
    print("[INFO] No configuration found. Opening setup wizard...")
    from config_ui import ConfigUI
    ui = ConfigUI()
    ui.run()
    
    # Reload config after setup
    config = load_config()
```

5. **Use config values instead of importing config module:**
Replace:
```python
import config
```

With config dictionary access:
```python
# Use config['ptt']['enabled'] instead of config.PTT_ENABLED
# Use config['audio']['input_device'] instead of None
# etc.
```

6. **Update VoiceTranslator initialization:**
```python
# Get device indices from names
input_device = None
output_device = None

if config['audio']['input_device']:
    # Find device by name
    from audio.utils import find_device_by_name
    input_device = find_device_by_name(config['audio']['input_device'])

if config['audio']['output_device']:
    output_device = find_device_by_name(config['audio']['output_device'])

# Initialize translator with config
translator = VoiceTranslator(
    input_device=input_device,
    output_device=output_device,
    source_lang=config['translation']['source_lang'],
    target_lang=config['translation']['target_lang'],
    sample_rate=config['audio']['sample_rate']
)
```

IMPORTANT:
- Maintain backward compatibility
- Auto-open UI on first run (no config.json)
- Use config dictionary throughout
- Keep existing command-line flags working
- No emojis in output
  </action>
  <verify>python src/main.py --help | Select-String "config"</verify>
  <done>main.py updated to use config.json with --config flag</done>
</task>

<task type="auto">
  <name>Add device testing to config_ui.py</name>
  <files>src/config_ui.py</files>
  <action>
Update config_ui.py to implement device testing:

1. **Add imports:**
```python
import numpy as np
import threading
```

2. **Replace _test_input method:**
```python
def _test_input(self):
    """Test input device by recording."""
    device_name = self.input_device_var.get()
    
    if device_name == "Auto-detect":
        messagebox.showinfo("Test Input", "Please select a specific device to test")
        return
    
    # Find device index
    devices = sd.query_devices()
    device_idx = None
    for idx, dev in enumerate(devices):
        if dev['name'] == device_name:
            device_idx = idx
            break
    
    if device_idx is None:
        messagebox.showerror("Error", f"Device not found: {device_name}")
        return
    
    # Test recording
    try:
        duration = 2.0
        messagebox.showinfo("Recording", 
                           f"Recording for {duration} seconds...\nSpeak into your microphone!")
        
        recording = sd.rec(
            int(duration * 16000),
            samplerate=16000,
            channels=1,
            device=device_idx
        )
        sd.wait()
        
        # Check if audio was captured
        max_amplitude = np.max(np.abs(recording))
        if max_amplitude > 0.01:
            messagebox.showinfo("Test Result", 
                               f"[OK] Device working\nMax amplitude: {max_amplitude:.3f}")
        else:
            messagebox.showwarning("Test Result", 
                                  "[WARNING] No audio detected\nCheck microphone volume")
    
    except Exception as e:
        messagebox.showerror("Test Failed", f"[ERROR] {str(e)}")
```

3. **Replace _test_output method:**
```python
def _test_output(self):
    """Test output device by playing tone."""
    device_name = self.output_device_var.get()
    
    if device_name == "Auto-detect":
        messagebox.showinfo("Test Output", "Please select a specific device to test")
        return
    
    # Find device index
    devices = sd.query_devices()
    device_idx = None
    for idx, dev in enumerate(devices):
        if dev['name'] == device_name:
            device_idx = idx
            break
    
    if device_idx is None:
        messagebox.showerror("Error", f"Device not found: {device_name}")
        return
    
    # Test playback
    try:
        messagebox.showinfo("Playing", "Playing test tone...")
        
        # Generate 440Hz tone (A note)
        duration = 0.5
        frequency = 440
        t = np.linspace(0, duration, int(16000 * duration))
        tone = 0.3 * np.sin(2 * np.pi * frequency * t)
        
        sd.play(tone, samplerate=16000, device=device_idx)
        sd.wait()
        
        messagebox.showinfo("Test Result", "[OK] Tone played successfully")
    
    except Exception as e:
        messagebox.showerror("Test Failed", f"[ERROR] {str(e)}")
```

IMPORTANT:
- Test actual audio capture/playback
- Show clear feedback to user
- Handle errors gracefully
- Use messagebox for results
  </action>
  <verify>python -m py_compile src/config_ui.py</verify>
  <done>Device testing implemented in config_ui.py</done>
</task>

## Success Criteria
- [ ] SystemTray class creates icon in system tray
- [ ] System tray menu has Settings, Start/Stop, Quit
- [ ] main.py loads config.json on startup
- [ ] main.py opens UI on first run (no config.json)
- [ ] --config flag opens configuration UI
- [ ] Device testing works for input and output
- [ ] Test buttons show clear feedback
