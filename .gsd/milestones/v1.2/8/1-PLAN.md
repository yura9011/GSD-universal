---
phase: 8
plan: 1
wave: 1
milestone: v1.2
---

# Plan 8.1: Install keyboard library and create PTT controller

## Objective
Install keyboard library and create PushToTalkController class to manage hotkey detection and recording state machine.

## Context
- .gsd/phases/8/RESEARCH.md - Decision to use keyboard library
- src/voice_translator.py - Existing VoiceTranslator class
- src/config.py - Configuration file

## Tasks

<task type="auto">
  <name>Add keyboard library to requirements</name>
  <files>requirements.txt</files>
  <action>
    Add keyboard library to requirements.txt:
    
    After the existing dependencies, add:
    ```
    # Push-to-Talk (Phase 8 - v1.2)
    keyboard>=0.13.5
    ```
    
    IMPORTANT:
    - Add comment to indicate this is for v1.2 PTT feature
    - Use >= to allow newer compatible versions
  </action>
  <verify>cat requirements.txt | Select-String "keyboard"</verify>
  <done>requirements.txt contains keyboard>=0.13.5</done>
</task>

<task type="auto">
  <name>Create PushToTalkController class</name>
  <files>src/ptt_controller.py</files>
  <action>
    Create src/ptt_controller.py with PushToTalkController class:
    
    ```python
    """
    Push-to-Talk controller for hotkey-based recording.
    Manages recording state machine and hotkey detection.
    """
    
    import keyboard
    import threading
    from enum import Enum
    
    
    class PTTState(Enum):
        """Push-to-Talk states."""
        IDLE = "idle"
        RECORDING = "recording"
        PROCESSING = "processing"
        SENDING = "sending"
    
    
    class PushToTalkController:
        """
        Manages push-to-talk hotkey and recording state.
        
        State machine:
        IDLE -> (hotkey press) -> RECORDING -> (hotkey release) -> PROCESSING -> SENDING -> IDLE
        """
        
        def __init__(self, hotkey='f1', on_start_recording=None, on_stop_recording=None):
            """
            Initialize PTT controller.
            
            Args:
                hotkey (str): Hotkey to trigger recording (default: 'f1')
                on_start_recording (callable): Callback when recording starts
                on_stop_recording (callable): Callback when recording stops
            """
            self.hotkey = hotkey
            self.on_start_recording = on_start_recording
            self.on_stop_recording = on_stop_recording
            
            self.state = PTTState.IDLE
            self.state_lock = threading.Lock()
            
            self._is_running = False
            self._hook_registered = False
        
        def start(self):
            """Start listening for hotkey."""
            if self._is_running:
                return
            
            self._is_running = True
            
            # Register hotkey hooks
            keyboard.on_press_key(self.hotkey, self._on_key_press)
            keyboard.on_release_key(self.hotkey, self._on_key_release)
            self._hook_registered = True
            
            print(f"[PTT] Listening for hotkey: {self.hotkey}")
        
        def stop(self):
            """Stop listening for hotkey."""
            if not self._is_running:
                return
            
            self._is_running = False
            
            # Unregister hotkey hooks
            if self._hook_registered:
                keyboard.unhook_all()
                self._hook_registered = False
            
            print("[PTT] Stopped listening")
        
        def _on_key_press(self, event):
            """Handle hotkey press event."""
            with self.state_lock:
                if self.state == PTTState.IDLE:
                    self.state = PTTState.RECORDING
                    print(f"[PTT] State: {self.state.value}")
                    
                    if self.on_start_recording:
                        self.on_start_recording()
        
        def _on_key_release(self, event):
            """Handle hotkey release event."""
            with self.state_lock:
                if self.state == PTTState.RECORDING:
                    self.state = PTTState.PROCESSING
                    print(f"[PTT] State: {self.state.value}")
                    
                    if self.on_stop_recording:
                        self.on_stop_recording()
        
        def set_state(self, new_state):
            """
            Set PTT state (for external state management).
            
            Args:
                new_state (PTTState): New state
            """
            with self.state_lock:
                self.state = new_state
                print(f"[PTT] State: {self.state.value}")
        
        def get_state(self):
            """Get current PTT state."""
            with self.state_lock:
                return self.state
        
        def is_recording(self):
            """Check if currently recording."""
            return self.get_state() == PTTState.RECORDING
    ```
    
    IMPORTANT:
    - Thread-safe state management with lock
    - Clean callback pattern for integration
    - State machine enforces valid transitions
    - Proper cleanup in stop()
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); from ptt_controller import PushToTalkController, PTTState; print('[OK] PTT controller imports')"</verify>
  <done>src/ptt_controller.py created with PushToTalkController class</done>
</task>

<task type="auto">
  <name>Add PTT configuration to config.py</name>
  <files>src/config.py</files>
  <action>
    Add PTT configuration section to src/config.py:
    
    After the existing configuration sections, add:
    ```python
    
    # ============================================================================
    # Push-to-Talk Settings (v1.2)
    # ============================================================================
    
    PTT_ENABLED = True  # Enable push-to-talk mode (False = continuous mode)
    PTT_HOTKEY = "f1"   # Hotkey to trigger recording
                        # Options: 'f1', 'f2', ..., 'f12', 'ctrl+space', etc.
    
    PTT_MIN_DURATION = 0.3  # Minimum recording duration (seconds)
                            # Prevents accidental taps
    
    PTT_MAX_DURATION = 10.0  # Maximum recording duration (seconds)
                             # Safety limit to prevent stuck recording
    ```
    
    IMPORTANT:
    - Add clear comments explaining each setting
    - Use sensible defaults (F1 is common for PTT)
    - Include safety limits
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); import config; print(f'[OK] PTT_ENABLED={config.PTT_ENABLED}, PTT_HOTKEY={config.PTT_HOTKEY}')"</verify>
  <done>src/config.py contains PTT configuration section</done>
</task>

## Success Criteria
- [ ] keyboard library added to requirements.txt
- [ ] PushToTalkController class created with state machine
- [ ] PTT configuration added to config.py
- [ ] All imports work correctly
- [ ] Thread-safe state management implemented
