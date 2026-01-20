---
phase: 8
plan: 2
wave: 2
milestone: v1.2
---

# Plan 8.2: Integrate PTT controller with VoiceTranslator

## Objective
Modify VoiceTranslator class to support push-to-talk mode alongside existing continuous mode, using PushToTalkController for hotkey management.

## Context
- .gsd/phases/8/1-PLAN.md - PushToTalkController created
- src/voice_translator.py - Existing VoiceTranslator class
- src/ptt_controller.py - New PTT controller
- src/config.py - Configuration with PTT settings

## Tasks

<task type="auto">
  <name>Modify VoiceTranslator to support PTT mode</name>
  <files>src/voice_translator.py</files>
  <action>
    Update VoiceTranslator class to support push-to-talk mode:
    
    1. **Add imports**:
    ```python
    from ptt_controller import PushToTalkController, PTTState
    ```
    
    2. **Add PTT controller to __init__**:
    ```python
    # In __init__ method, after existing initialization:
    
    # Push-to-Talk controller (v1.2)
    self.ptt_enabled = config.PTT_ENABLED
    self.ptt_controller = None
    
    if self.ptt_enabled:
        self.ptt_controller = PushToTalkController(
            hotkey=config.PTT_HOTKEY,
            on_start_recording=self._on_ptt_start,
            on_stop_recording=self._on_ptt_stop
        )
        print(f"[INFO] Push-to-Talk mode enabled (hotkey: {config.PTT_HOTKEY})")
    else:
        print("[INFO] Continuous mode enabled")
    ```
    
    3. **Add PTT callback methods**:
    ```python
    def _on_ptt_start(self):
        """Callback when PTT hotkey is pressed."""
        print("[PTT] Recording started")
        # Audio capture already running, just note the state
    
    def _on_ptt_stop(self):
        """Callback when PTT hotkey is released."""
        print("[PTT] Recording stopped, processing...")
        # Processing will happen in _process_audio when buffer is ready
    ```
    
    4. **Modify _process_audio to respect PTT state**:
    ```python
    # In _process_audio method, modify the speech detection logic:
    
    # Check if speech detected
    is_speech = self.speech_pipeline.vad.is_speech(audio_chunk)
    
    # In PTT mode, only process if recording
    if self.ptt_enabled:
        if not self.ptt_controller.is_recording():
            # Not recording, skip processing
            continue
    
    # Rest of existing logic...
    ```
    
    5. **Update start() method**:
    ```python
    # In start() method, after starting audio capture:
    
    if self.ptt_enabled:
        self.ptt_controller.start()
        print(f"[INFO] Press {config.PTT_HOTKEY} to start recording")
    ```
    
    6. **Update stop() method**:
    ```python
    # In stop() method, before stopping audio capture:
    
    if self.ptt_enabled and self.ptt_controller:
        self.ptt_controller.stop()
    ```
    
    IMPORTANT:
    - Maintain backward compatibility with continuous mode
    - Don't break existing functionality
    - PTT mode should work alongside VAD (VAD filters noise even in PTT)
    - Thread-safe integration with existing threading model
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); from voice_translator import VoiceTranslator; print('[OK] VoiceTranslator imports with PTT support')"</verify>
  <done>VoiceTranslator class supports both PTT and continuous modes</done>
</task>

<task type="auto">
  <name>Update main.py to show PTT instructions</name>
  <files>src/main.py</files>
  <action>
    Update main.py to display PTT instructions when enabled:
    
    In the main() function, after the banner and before starting the translator:
    
    ```python
    # Show mode information
    import config
    if config.PTT_ENABLED:
        print(f"\n[MODE] Push-to-Talk")
        print(f"[HOTKEY] Press and hold {config.PTT_HOTKEY} to record")
        print(f"[HOTKEY] Release {config.PTT_HOTKEY} to process and send")
    else:
        print("\n[MODE] Continuous (always listening)")
    
    print("\nPress Ctrl+C to stop\n")
    ```
    
    IMPORTANT:
    - Clear instructions for user
    - Show which mode is active
    - Explain hotkey usage
  </action>
  <verify>python src/main.py --help</verify>
  <done>main.py displays PTT instructions when PTT mode is enabled</done>
</task>

## Success Criteria
- [ ] VoiceTranslator supports both PTT and continuous modes
- [ ] PTT controller integrates cleanly with existing threading
- [ ] Backward compatibility maintained (continuous mode still works)
- [ ] main.py shows clear PTT instructions
- [ ] No breaking changes to existing functionality
