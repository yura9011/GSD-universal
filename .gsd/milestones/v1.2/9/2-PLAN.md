---
phase: 9
plan: 2
wave: 2
milestone: v1.2
---

# Plan 9.2: Configuration UI with Tabs

## Objective
Create tkinter-based configuration UI with Basic and Advanced tabs, allowing users to edit all settings with proper widgets (entries, dropdowns, sliders).

## Context
- src/config_loader.py - Config management (from Plan 9.1)
- .gsd/phases/9/RESEARCH.md - UI design and layout
- DECISIONS.md - UI structure decisions

## Tasks

<task type="auto">
  <name>Create config_ui.py with tabbed interface</name>
  <files>src/config_ui.py</files>
  <action>
Create src/config_ui.py with ConfigUI class:

**Class Structure:**
```python
import tkinter as tk
from tkinter import ttk, messagebox
from config_loader import load_config, save_config, DEFAULT_CONFIG
import sounddevice as sd

class ConfigUI:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Voice Translator - Settings")
        self.root.geometry("500x400")
        
        self.config = load_config()
        
        self._create_widgets()
        self._load_values()
    
    def _create_widgets(self):
        # Create notebook (tabs)
        notebook = ttk.Notebook(self.root)
        notebook.pack(fill='both', expand=True, padx=10, pady=10)
        
        # Basic tab
        basic_frame = ttk.Frame(notebook, padding=10)
        notebook.add(basic_frame, text='Basic')
        self._create_basic_tab(basic_frame)
        
        # Advanced tab
        advanced_frame = ttk.Frame(notebook, padding=10)
        notebook.add(advanced_frame, text='Advanced')
        self._create_advanced_tab(advanced_frame)
        
        # Buttons at bottom
        button_frame = ttk.Frame(self.root, padding=10)
        button_frame.pack(fill='x')
        
        ttk.Button(button_frame, text="Save & Restart", 
                  command=self._save_config).pack(side='left', padx=5)
        ttk.Button(button_frame, text="Reset to Defaults", 
                  command=self._reset_defaults).pack(side='left', padx=5)
        ttk.Button(button_frame, text="Cancel", 
                  command=self.root.destroy).pack(side='right', padx=5)
    
    def _create_basic_tab(self, parent):
        # Hotkey
        ttk.Label(parent, text="Hotkey:").grid(row=0, column=0, sticky='w', pady=5)
        self.hotkey_var = tk.StringVar()
        ttk.Entry(parent, textvariable=self.hotkey_var, width=20).grid(row=0, column=1, sticky='w')
        
        # Input device
        ttk.Label(parent, text="Input Device:").grid(row=1, column=0, sticky='w', pady=5)
        self.input_device_var = tk.StringVar()
        input_devices = self._get_input_devices()
        ttk.Combobox(parent, textvariable=self.input_device_var, 
                    values=input_devices, width=30, state='readonly').grid(row=1, column=1, sticky='w')
        ttk.Button(parent, text="Test", command=self._test_input).grid(row=1, column=2, padx=5)
        
        # Output device
        ttk.Label(parent, text="Output Device:").grid(row=2, column=0, sticky='w', pady=5)
        self.output_device_var = tk.StringVar()
        output_devices = self._get_output_devices()
        ttk.Combobox(parent, textvariable=self.output_device_var, 
                    values=output_devices, width=30, state='readonly').grid(row=2, column=1, sticky='w')
        ttk.Button(parent, text="Test", command=self._test_output).grid(row=2, column=2, padx=5)
        
        # Source language
        ttk.Label(parent, text="Source Language:").grid(row=3, column=0, sticky='w', pady=5)
        self.source_lang_var = tk.StringVar()
        ttk.Combobox(parent, textvariable=self.source_lang_var, 
                    values=['es', 'en', 'pt'], width=20, state='readonly').grid(row=3, column=1, sticky='w')
        
        # Target language
        ttk.Label(parent, text="Target Language:").grid(row=4, column=0, sticky='w', pady=5)
        self.target_lang_var = tk.StringVar()
        ttk.Combobox(parent, textvariable=self.target_lang_var, 
                    values=['pt', 'es', 'en'], width=20, state='readonly').grid(row=4, column=1, sticky='w')
    
    def _create_advanced_tab(self, parent):
        # Whisper model
        ttk.Label(parent, text="Whisper Model:").grid(row=0, column=0, sticky='w', pady=5)
        self.whisper_model_var = tk.StringVar()
        ttk.Combobox(parent, textvariable=self.whisper_model_var, 
                    values=['tiny', 'base', 'small'], width=20, state='readonly').grid(row=0, column=1, sticky='w')
        
        # VAD threshold
        ttk.Label(parent, text="VAD Threshold:").grid(row=1, column=0, sticky='w', pady=5)
        self.vad_threshold_var = tk.DoubleVar()
        vad_scale = ttk.Scale(parent, from_=0.0, to=1.0, orient='horizontal', 
                             variable=self.vad_threshold_var, length=200)
        vad_scale.grid(row=1, column=1, sticky='w')
        self.vad_label = ttk.Label(parent, text="0.5")
        self.vad_label.grid(row=1, column=2)
        vad_scale.configure(command=lambda v: self.vad_label.configure(text=f"{float(v):.2f}"))
        
        # TTS rate
        ttk.Label(parent, text="TTS Rate (wpm):").grid(row=2, column=0, sticky='w', pady=5)
        self.tts_rate_var = tk.IntVar()
        tts_scale = ttk.Scale(parent, from_=100, to=200, orient='horizontal', 
                             variable=self.tts_rate_var, length=200)
        tts_scale.grid(row=2, column=1, sticky='w')
        self.tts_label = ttk.Label(parent, text="150")
        self.tts_label.grid(row=2, column=2)
        tts_scale.configure(command=lambda v: self.tts_label.configure(text=f"{int(float(v))}"))
        
        # Min duration
        ttk.Label(parent, text="Min Duration (s):").grid(row=3, column=0, sticky='w', pady=5)
        self.min_duration_var = tk.DoubleVar()
        ttk.Entry(parent, textvariable=self.min_duration_var, width=10).grid(row=3, column=1, sticky='w')
        
        # Max duration
        ttk.Label(parent, text="Max Duration (s):").grid(row=4, column=0, sticky='w', pady=5)
        self.max_duration_var = tk.DoubleVar()
        ttk.Entry(parent, textvariable=self.max_duration_var, width=10).grid(row=4, column=1, sticky='w')
    
    def _get_input_devices(self):
        devices = sd.query_devices()
        return ["Auto-detect"] + [d['name'] for d in devices if d['max_input_channels'] > 0]
    
    def _get_output_devices(self):
        devices = sd.query_devices()
        return ["Auto-detect"] + [d['name'] for d in devices if d['max_output_channels'] > 0]
    
    def _load_values(self):
        # Load config values into widgets
        self.hotkey_var.set(self.config['ptt']['hotkey'])
        self.input_device_var.set(self.config['audio']['input_device'] or "Auto-detect")
        self.output_device_var.set(self.config['audio']['output_device'] or "Auto-detect")
        self.source_lang_var.set(self.config['translation']['source_lang'])
        self.target_lang_var.set(self.config['translation']['target_lang'])
        self.whisper_model_var.set(self.config['speech']['whisper_model'])
        self.vad_threshold_var.set(self.config['speech']['vad_threshold'])
        self.tts_rate_var.set(self.config['tts']['rate'])
        self.min_duration_var.set(self.config['ptt']['min_duration'])
        self.max_duration_var.set(self.config['ptt']['max_duration'])
    
    def _save_config(self):
        # Update config from widgets
        self.config['ptt']['hotkey'] = self.hotkey_var.get()
        self.config['ptt']['min_duration'] = self.min_duration_var.get()
        self.config['ptt']['max_duration'] = self.max_duration_var.get()
        
        input_dev = self.input_device_var.get()
        self.config['audio']['input_device'] = None if input_dev == "Auto-detect" else input_dev
        
        output_dev = self.output_device_var.get()
        self.config['audio']['output_device'] = None if output_dev == "Auto-detect" else output_dev
        
        self.config['translation']['source_lang'] = self.source_lang_var.get()
        self.config['translation']['target_lang'] = self.target_lang_var.get()
        self.config['speech']['whisper_model'] = self.whisper_model_var.get()
        self.config['speech']['vad_threshold'] = self.vad_threshold_var.get()
        self.config['tts']['rate'] = self.tts_rate_var.get()
        
        # Save to file
        save_config(self.config)
        
        messagebox.showinfo("Settings Saved", 
                           "Configuration saved successfully.\nPlease restart the translator for changes to take effect.")
        self.root.destroy()
    
    def _reset_defaults(self):
        if messagebox.askyesno("Reset to Defaults", 
                              "Are you sure you want to reset all settings to defaults?"):
            self.config = DEFAULT_CONFIG.copy()
            self._load_values()
    
    def _test_input(self):
        messagebox.showinfo("Test Input", "Input device testing not implemented yet")
    
    def _test_output(self):
        messagebox.showinfo("Test Output", "Output device testing not implemented yet")
    
    def run(self):
        self.root.mainloop()

def main():
    ui = ConfigUI()
    ui.run()

if __name__ == "__main__":
    main()
```

IMPORTANT:
- Use ttk widgets for modern look
- Grid layout for organized appearance
- All config values editable
- Clear labels and tooltips
- No emojis in UI text
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); from config_ui import ConfigUI; print('[OK] ConfigUI imports successfully')"</verify>
  <done>config_ui.py created with Basic and Advanced tabs</done>
</task>

## Success Criteria
- [ ] ConfigUI class imports without errors
- [ ] UI has Basic and Advanced tabs
- [ ] All config values are editable
- [ ] Save button writes to config.json
- [ ] Reset button restores defaults
- [ ] Device dropdowns populated from sounddevice
