# Phase 4 Research: Game Integration & Auto-PTT

**Date**: 2026-01-19
**Phase**: 4 - Game Integration & Auto-PTT
**Objective**: Research game process detection and automatic PTT key pressing

## Problem Statement

Need to:
1. Detect when specific games are running (Dota 2, Discord, CS:GO)
2. Know which PTT key each game uses
3. Automatically press that game's PTT key when sending translated audio
4. Make this configurable per game

## Research Questions

1. How to detect running processes on Windows?
2. How to simulate keypresses to other applications?
3. What are the default PTT keys for popular games?
4. How to make game profiles configurable?

## Options Evaluated

### Option 1: psutil for Process Detection
**Pros:**
- Cross-platform
- Simple API
- Already common in Python projects
- Can get process name and executable path

**Cons:**
- Requires new dependency

**Verdict:** ✅ RECOMMENDED - Standard tool for process management

### Option 2: keyboard library for Key Simulation
**Pros:**
- Already using for PTT hotkey detection
- Can simulate keypresses
- Works on Windows

**Cons:**
- May not work with all games (anti-cheat)
- Some games require admin privileges

**Verdict:** ✅ RECOMMENDED - Already in use, sufficient for v1.2

### Option 3: pyautogui
**Pros:**
- Can simulate keyboard and mouse
- Cross-platform

**Cons:**
- Overkill for just keypresses
- Another dependency

**Verdict:** ❌ Not needed, keyboard library sufficient

## Decision: psutil + keyboard

Use psutil to detect games, keyboard to press their PTT keys.

## Implementation Approach

### Architecture
```
GameDetector (psutil)
├── detect_active_game() → game_name or None
├── get_game_profile(game_name) → GameProfile
└── is_game_running(process_name) → bool

GameProfile
├── name: str
├── process_names: List[str]
├── ptt_key: str
├── enabled: bool

AutoPTT
├── game_detector: GameDetector
├── press_game_ptt() → bool
└── release_game_ptt() → bool
```

### Game Profiles (Predefined)

```python
DEFAULT_GAME_PROFILES = {
    "dota2": {
        "name": "Dota 2",
        "process_names": ["dota2.exe"],
        "ptt_key": "v",  # Default Dota 2 voice key
        "enabled": True
    },
    "discord": {
        "name": "Discord",
        "process_names": ["Discord.exe"],
        "ptt_key": "grave",  # ` key (common Discord PTT)
        "enabled": True
    },
    "csgo": {
        "name": "Counter-Strike: Global Offensive",
        "process_names": ["csgo.exe", "cs2.exe"],
        "ptt_key": "k",  # Common CS:GO PTT
        "enabled": True
    },
    "valorant": {
        "name": "Valorant",
        "process_names": ["VALORANT.exe"],
        "ptt_key": "v",
        "enabled": True
    }
}
```

### Configuration
Add to config.json:
```json
{
  "auto_ptt": {
    "enabled": true,
    "hold_duration": 0.1,
    "games": {
      "dota2": {
        "enabled": true,
        "ptt_key": "v"
      },
      "discord": {
        "enabled": true,
        "ptt_key": "grave"
      }
    }
  }
}
```

### Workflow
1. User presses F1 (translator PTT)
2. User speaks Spanish
3. User releases F1
4. Translator processes and translates
5. **Before playing audio:**
   - Detect active game
   - If game found and has profile:
     - Press game's PTT key
     - Play translated audio
     - Release game's PTT key after audio finishes

### Thread Safety
- Game detection runs in main thread (quick check)
- Key pressing happens in translator thread
- Use keyboard library's press/release (thread-safe)

## Technical Decisions

### 1. Process Detection Frequency
- Check on each translation (not continuous polling)
- Cache result for 5 seconds to avoid overhead
- Only check when about to send audio

### 2. Key Press Timing
```python
# Press game PTT
keyboard.press(game_ptt_key)
time.sleep(0.1)  # Small delay for game to register

# Play audio
playback.play(audio)

# Release game PTT
time.sleep(0.1)  # Small delay after audio
keyboard.release(game_ptt_key)
```

### 3. Configuration UI
- Add "Game Integration" section to Advanced tab
- Enable/disable auto-PTT globally
- List of games with checkboxes
- Edit PTT key per game
- Test button to verify key works

### 4. Fallback Behavior
- If no game detected: Just play audio (normal behavior)
- If game detected but no profile: Just play audio
- If key press fails: Log warning, still play audio

## Dependencies

**New dependency:**
- `psutil>=5.9.0` - Process and system utilities

**Existing:**
- `keyboard>=0.13.5` - Already in use for PTT

## Risks & Mitigations

**Risk 1**: Anti-cheat software blocks keyboard simulation
- **Mitigation**: Document known issues
- **Fallback**: User can disable auto-PTT
- **Future**: Consider DirectInput for games

**Risk 2**: Process names vary by region/version
- **Mitigation**: Support multiple process names per game
- **Example**: csgo.exe vs cs2.exe

**Risk 3**: Key press doesn't reach game
- **Mitigation**: Add hold_duration config (adjustable delay)
- **Test button** in UI to verify

**Risk 4**: Performance impact of process detection
- **Mitigation**: Cache detection result for 5 seconds
- Only check when needed (before audio playback)

## Implementation Plan

### Wave 1: Game Detection
- Add psutil to requirements
- Create GameDetector class
- Implement process detection
- Add game profiles to config

### Wave 2: Auto-PTT Logic
- Create AutoPTT class
- Integrate with VoiceTranslator
- Press/release game PTT around audio playback
- Add timing configuration

### Wave 3: Configuration UI
- Add Game Integration section to config UI
- List games with enable/disable
- Edit PTT keys per game
- Test button for verification

## Default PTT Keys Research

| Game | Default PTT Key | Notes |
|------|----------------|-------|
| Dota 2 | V | Voice chat key |
| Discord | ` (grave) | Common default |
| CS:GO/CS2 | K | Common binding |
| Valorant | V | Party voice |
| TeamSpeak | Configurable | No standard |
| Mumble | Configurable | No standard |

## Success Criteria

- [ ] Detects when Dota 2, Discord, CS:GO are running
- [ ] Automatically presses game's PTT key before audio
- [ ] Releases PTT key after audio completes
- [ ] Configurable per-game PTT keys
- [ ] Can enable/disable auto-PTT globally
- [ ] Can enable/disable per game
- [ ] No audio playback failures if key press fails

---

**Conclusion**: psutil for detection + keyboard for simulation is sufficient for v1.2. Simple, uses existing dependencies where possible, configurable per game.
