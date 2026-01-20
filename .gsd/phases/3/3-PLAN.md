---
phase: 3
plan: 3
wave: 3
milestone: v1.2
---

# Plan 3.3: Integrate Overlay with Translator

## Objective
Connect overlay to VoiceTranslator state changes and integrate with main.py, completing the visual feedback system for the translator.

## Context
- src/overlay_window.py - Overlay implementation (from Plans 3.1, 3.2)
- src/voice_translator.py - Main translator class
- src/main.py - Application entry point
- src/ptt_controller.py - PTT state machine

## Tasks

<task type="auto">
  <name>Add overlay state updates to VoiceTranslator</name>
  <files>src/voice_translator.py</files>
  <action>
Update VoiceTranslator to send state updates to overlay:

1. **Add overlay parameter to __init__:**
```python
    def __init__(self, input_device=None, output_device=None, 
                 source_lang='es', target_lang='pt', sample_rate=16000,
                 overlay=None):
        # ... existing code ...
        self.overlay = overlay
```

2. **Add state update method:**
```python
    def _update_overlay(self, state):
        """Update overlay state if available.
        
        Args:
            state: One of 'idle', 'recording', 'processing', 'sending'
        """
        if self.overlay:
            self.overlay.set_state(state)
```

3. **Add overlay updates in _ptt_loop() method:**

Find the PTT state machine and add overlay updates:
```python
        # When starting recording
        if self.ptt_controller.state == PTTState.RECORDING:
            self._update_overlay('recording')
        
        # When processing
        if audio_data is not None:
            self._update_overlay('processing')
            # ... transcription code ...
        
        # When sending
        if translated_text:
            self._update_overlay('sending')
            # ... TTS and playback ...
        
        # Back to idle
        self._update_overlay('idle')
```

4. **For continuous mode, add in _continuous_loop():**
```python
        # When speech detected
        if self.vad.is_speech(audio_chunk):
            self._update_overlay('recording')
        
        # When transcribing
        if transcription:
            self._update_overlay('processing')
        
        # When sending
        if translated_text:
            self._update_overlay('sending')
        
        # Back to idle
        self._update_overlay('idle')
```

IMPORTANT:
- Check if overlay exists before calling
- Update at each state transition
- Don't block on overlay updates (queue-based)
- Match states to overlay color scheme
  </action>
  <verify>python -m py_compile src/voice_translator.py</verify>
  <done>Overlay state updates integrated into VoiceTranslator</done>
</task>

<task type="auto">
  <name>Update main.py to launch overlay</name>
  <files>src/main.py</files>
  <action>
Update main.py to create and manage overlay window:

1. **Add import at top:**
```python
from overlay_window import OverlayWindow
import tkinter as tk
```

2. **After loading config and before translator initialization:**
```python
    # Create tkinter root for overlay (if enabled)
    overlay = None
    tk_root = None
    
    if config.get('overlay', {}).get('enabled', True):
        tk_root = tk.Tk()
        tk_root.withdraw()  # Hide root window
        
        overlay = OverlayWindow(config)
        overlay.create_window()
        
        print("[INFO] Overlay window created")
```

3. **Pass overlay to VoiceTranslator:**
```python
        # Initialize translator with config and overlay
        translator = VoiceTranslator(
            input_device=input_device,
            output_device=output_device,
            source_lang=config['translation']['source_lang'],
            target_lang=config['translation']['target_lang'],
            sample_rate=config['audio']['sample_rate'],
            overlay=overlay
        )
```

4. **Update signal handler to cleanup overlay:**
```python
        def signal_handler(sig, frame):
            print("\n")
            print("[STOPPED] Stopping translator...")
            translator.stop()
            
            # Cleanup overlay
            if overlay:
                overlay.destroy()
            if tk_root:
                tk_root.quit()
            
            print()
            print("Goodbye!")
            sys.exit(0)
```

5. **Replace the wait loop with tkinter mainloop:**
```python
        # Start translator
        translator.start()
        
        print("Press Ctrl+C to stop")
        print()
        
        # Run tkinter main loop if overlay exists, otherwise wait
        if tk_root:
            tk_root.mainloop()
        else:
            # Original wait logic for no overlay
            try:
                while True:
                    signal.pause()
            except AttributeError:
                try:
                    while True:
                        input()
                except EOFError:
                    pass
```

IMPORTANT:
- Create tk_root before overlay (required for Toplevel)
- Hide tk_root (withdraw)
- Pass overlay to translator
- Use tk_root.mainloop() to keep overlay alive
- Cleanup overlay on exit
  </action>
  <verify>python -m py_compile src/main.py</verify>
  <done>Overlay integrated into main.py with proper lifecycle management</done>
</task>

## Success Criteria
- [ ] Overlay shows correct state during translation
- [ ] State changes: idle → recording → processing → sending → idle
- [ ] Overlay can be disabled via config
- [ ] Overlay persists position across restarts
- [ ] No crashes or threading issues
- [ ] Overlay updates in real-time during operation
