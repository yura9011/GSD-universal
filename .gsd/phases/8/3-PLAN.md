---
phase: 8
plan: 3
wave: 3
milestone: v1.2
---

# Plan 8.3: Create PTT test script and update documentation

## Objective
Create test script for push-to-talk functionality and update documentation to explain PTT mode usage.

## Context
- .gsd/phases/8/2-PLAN.md - PTT integrated with VoiceTranslator
- src/ptt_controller.py - PTT controller
- src/voice_translator.py - Updated with PTT support
- README.md - Main documentation

## Tasks

<task type="auto">
  <name>Create PTT test script</name>
  <files>test_ptt.py</files>
  <action>
    Create test_ptt.py to test push-to-talk functionality:
    
    ```python
    #!/usr/bin/env python
    """
    Test script for Push-to-Talk functionality.
    Tests hotkey detection and state machine without full pipeline.
    """
    
    import sys
    import os
    import time
    
    # Add src to path
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'src'))
    
    from ptt_controller import PushToTalkController, PTTState
    import config
    
    
    def on_start():
        """Callback when recording starts."""
        print("[TEST] Recording started!")
    
    
    def on_stop():
        """Callback when recording stops."""
        print("[TEST] Recording stopped!")
    
    
    def main():
        """Test PTT controller."""
        print("="*60)
        print("Push-to-Talk Test")
        print("="*60)
        print(f"\nHotkey: {config.PTT_HOTKEY}")
        print(f"Press and hold {config.PTT_HOTKEY} to test recording")
        print("Press Ctrl+C to exit\n")
        
        # Create PTT controller
        ptt = PushToTalkController(
            hotkey=config.PTT_HOTKEY,
            on_start_recording=on_start,
            on_stop_recording=on_stop
        )
        
        # Start listening
        ptt.start()
        
        try:
            # Keep running
            while True:
                time.sleep(0.1)
                
                # Show current state
                state = ptt.get_state()
                if state == PTTState.RECORDING:
                    print(f"[STATE] {state.value} (hold {config.PTT_HOTKEY})", end='\r')
                elif state == PTTState.IDLE:
                    print(f"[STATE] {state.value} (waiting for {config.PTT_HOTKEY})", end='\r')
        
        except KeyboardInterrupt:
            print("\n\n[TEST] Stopping...")
            ptt.stop()
            print("[TEST] Test complete")
    
    
    if __name__ == "__main__":
        main()
    ```
    
    IMPORTANT:
    - Simple test without full pipeline
    - Tests hotkey detection and callbacks
    - Shows state changes in real-time
    - Easy to verify PTT works before full integration
  </action>
  <verify>python test_ptt.py --help 2>&1 | Select-String "test" -Quiet; if ($?) { echo "[OK] test_ptt.py exists" }</verify>
  <done>test_ptt.py created and can test PTT functionality</done>
</task>

<task type="auto">
  <name>Update README.md with PTT documentation</name>
  <files>README.md</files>
  <action>
    Update README.md to document push-to-talk mode:
    
    1. **Add PTT section after "Usage" section**:
    ```markdown
    ## Push-to-Talk Mode (v1.2)
    
    The translator now supports push-to-talk mode for better control over when to translate.
    
    ### Enable PTT Mode
    
    Edit src/config.py:
    ```python
    PTT_ENABLED = True  # Enable push-to-talk
    PTT_HOTKEY = "f1"   # Hotkey to trigger recording
    ```
    
    ### Using PTT Mode
    
    1. Start the translator: `python src/main.py`
    2. Press and hold F1 (or your configured hotkey)
    3. Speak in Spanish while holding the key
    4. Release the key when done speaking
    5. Translation processes and sends to VB-Cable
    
    ### PTT vs Continuous Mode
    
    | Mode | When to Use | Pros | Cons |
    |------|-------------|------|------|
    | Push-to-Talk | Gaming, Discord | Precise control, no accidental translations | Must press key |
    | Continuous | Casual use | Hands-free | May translate background noise |
    
    To switch modes, edit `PTT_ENABLED` in src/config.py.
    
    ### Hotkey Options
    
    Supported hotkeys:
    - Function keys: 'f1', 'f2', ..., 'f12'
    - Combinations: 'ctrl+space', 'alt+t', 'shift+f1'
    - Single keys: 'space', 'v', 'b'
    
    Note: Some games may conflict with certain hotkeys. Choose one that doesn't interfere with your game controls.
    ```
    
    2. **Update "Advanced Configuration" section**:
    Add PTT settings to the configuration list:
    ```markdown
    PTT_ENABLED - Enable push-to-talk mode (True/False)
    PTT_HOTKEY - Hotkey to trigger recording (default: 'f1')
    PTT_MIN_DURATION - Minimum recording duration (default: 0.3s)
    PTT_MAX_DURATION - Maximum recording duration (default: 10s)
    ```
    
    IMPORTANT:
    - Clear explanation of PTT vs continuous
    - Table comparing both modes
    - List of supported hotkeys
    - Note about game conflicts
  </action>
  <verify>cat README.md | Select-String "Push-to-Talk"</verify>
  <done>README.md documents PTT mode with usage instructions</done>
</task>

<task type="auto">
  <name>Update requirements.txt with keyboard library</name>
  <files>requirements-lock.txt</files>
  <action>
    Add keyboard library to requirements-lock.txt for full reproducibility:
    
    After the existing dependencies, add:
    ```
    keyboard==0.13.5
    ```
    
    Note: This ensures exact version for reproducibility. The main requirements.txt already has keyboard>=0.13.5 from Plan 8.1.
    
    IMPORTANT:
    - Use exact version in lock file
    - Maintain alphabetical or logical order
  </action>
  <verify>cat requirements-lock.txt | Select-String "keyboard"</verify>
  <done>requirements-lock.txt includes keyboard==0.13.5</done>
</task>

## Success Criteria
- [ ] test_ptt.py created and tests PTT functionality
- [ ] README.md documents PTT mode with clear instructions
- [ ] PTT vs Continuous comparison table added
- [ ] Hotkey options documented
- [ ] requirements-lock.txt updated with keyboard library
