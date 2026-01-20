---
phase: 4
plan: 2
wave: 2
milestone: v1.2
---

# Plan 4.2: Auto-PTT Integration

## Objective
Integrate automatic PTT key pressing with VoiceTranslator, pressing the detected game's PTT key before playing translated audio and releasing it after.

## Context
- src/game_detector.py - Game detection (from Plan 4.1)
- src/voice_translator.py - Main translator class
- .gsd/phases/4/RESEARCH.md - Auto-PTT workflow

## Tasks

<task type="auto">
  <name>Add auto-PTT logic to VoiceTranslator</name>
  <files>src/voice_translator.py</files>
  <action>
Update VoiceTranslator to integrate auto-PTT:

1. **Add imports at top:**
```python
from game_detector import GameDetector
import keyboard
```

2. **Add game_detector to __init__:**
```python
    def __init__(self,
                 input_device=None,
                 output_device=None,
                 source_lang=None,
                 target_lang=None,
                 sample_rate=None,
                 overlay=None,
                 config=None):
        # ... existing code ...
        self.overlay = overlay
        self.config = config or {}
        
        # Initialize game detector if auto-PTT enabled
        self.game_detector = None
        if self.config.get('auto_ptt', {}).get('enabled', False):
            self.game_detector = GameDetector(self.config)
            print("[INFO] Auto-PTT enabled")
```

3. **Add auto-PTT methods:**
```python
    def _press_game_ptt(self) -> bool:
        """Press game's PTT key if game detected.
        
        Returns:
            True if key was pressed, False otherwise
        """
        if not self.game_detector:
            return False
        
        try:
            # Detect active game
            game_id = self.game_detector.detect_active_game()
            if not game_id:
                return False
            
            # Get game's PTT key
            ptt_key = self.game_detector.get_game_ptt_key(game_id)
            if not ptt_key:
                return False
            
            # Get game profile for name
            profile = self.game_detector.get_game_profile(game_id)
            game_name = profile.get('name', game_id)
            
            # Press key
            keyboard.press(ptt_key)
            
            # Small delay for game to register
            hold_duration = self.config.get('auto_ptt', {}).get('hold_duration', 0.1)
            time.sleep(hold_duration)
            
            print(f"[AUTO-PTT] Pressed {ptt_key} for {game_name}")
            return True
        
        except Exception as e:
            print(f"[WARNING] Auto-PTT press failed: {e}")
            return False
    
    def _release_game_ptt(self) -> bool:
        """Release game's PTT key if it was pressed.
        
        Returns:
            True if key was released, False otherwise
        """
        if not self.game_detector:
            return False
        
        try:
            # Detect active game
            game_id = self.game_detector.detect_active_game()
            if not game_id:
                return False
            
            # Get game's PTT key
            ptt_key = self.game_detector.get_game_ptt_key(game_id)
            if not ptt_key:
                return False
            
            # Small delay before release
            hold_duration = self.config.get('auto_ptt', {}).get('hold_duration', 0.1)
            time.sleep(hold_duration)
            
            # Release key
            keyboard.release(ptt_key)
            
            print(f"[AUTO-PTT] Released {ptt_key}")
            return True
        
        except Exception as e:
            print(f"[WARNING] Auto-PTT release failed: {e}")
            return False
```

4. **Integrate in _processing_loop() around audio playback:**

Find the audio playback section and wrap it:
```python
                    if audio is not None:
                        # Update overlay to sending
                        self._update_overlay('sending')
                        
                        if config.LOG_TRANSLATIONS:
                            print()
                            print(f"[PLAYING] Portuguese audio: \"{translated_text}\"")
                        
                        # Press game PTT if auto-PTT enabled
                        ptt_pressed = self._press_game_ptt()
                        
                        # Play audio through VB-Cable
                        self.playback.play(audio)
                        
                        # Release game PTT if it was pressed
                        if ptt_pressed:
                            self._release_game_ptt()
                        
                        # Calculate total latency
                        if config.LOG_LATENCY:
                            total_latency = time.time() - start_time
                            print(f"[TIMING] Total latency: {total_latency:.2f}s")
                            print("[COMPLETE] Done")
                        
                        # Back to idle
                        self._update_overlay('idle')
```

IMPORTANT:
- Check if game_detector exists before using
- Handle all exceptions gracefully
- Don't fail audio playback if PTT fails
- Log auto-PTT actions for debugging
- Use config hold_duration for timing
  </action>
  <verify>python -m py_compile src/voice_translator.py</verify>
  <done>Auto-PTT integrated into VoiceTranslator with game detection</done>
</task>

<task type="auto">
  <name>Update main.py to pass config to VoiceTranslator</name>
  <files>src/main.py</files>
  <action>
Update main.py to pass full config to VoiceTranslator:

Find the VoiceTranslator initialization and update:
```python
        # Initialize translator with config and overlay
        translator = VoiceTranslator(
            input_device=input_device,
            output_device=output_device,
            source_lang=config['translation']['source_lang'],
            target_lang=config['translation']['target_lang'],
            sample_rate=config['audio']['sample_rate'],
            overlay=overlay,
            config=config  # Add full config for auto-PTT
        )
```

IMPORTANT:
- Pass entire config dict
- Maintain existing parameters
- No other changes needed
  </action>
  <verify>python -m py_compile src/main.py</verify>
  <done>Config passed to VoiceTranslator for auto-PTT access</done>
</task>

## Success Criteria
- [ ] VoiceTranslator initializes GameDetector if auto-PTT enabled
- [ ] Game PTT key pressed before audio playback
- [ ] Game PTT key released after audio playback
- [ ] Audio plays even if PTT press/release fails
- [ ] Auto-PTT actions logged for debugging
- [ ] Config passed from main.py to translator
