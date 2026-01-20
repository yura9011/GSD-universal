---
phase: 4
plan: 1
wave: 1
milestone: v1.2
---

# Plan 4.1: Game Detection System

## Objective
Create game detection system using psutil to identify running games and load their PTT profiles. This provides the foundation for automatic PTT key pressing.

## Context
- .gsd/phases/4/RESEARCH.md - Game detection research
- src/config_loader.py - Config management
- ROADMAP.md - Phase 4 requirements

## Tasks

<task type="auto">
  <name>Add psutil to requirements</name>
  <files>requirements.txt, requirements-lock.txt</files>
  <action>
Add to requirements.txt after keyboard library:

```
# Game Integration (Phase 4 - v1.2)
psutil>=5.9.0
```

Add to requirements-lock.txt (alphabetically):
```
psutil==6.1.1
```

IMPORTANT:
- Maintain existing formatting
- Add comment header for Phase 4
- Keep alphabetical order in lock file
  </action>
  <verify>Select-String -Path requirements.txt -Pattern "psutil"</verify>
  <done>psutil added to requirements files</done>
</task>

<task type="auto">
  <name>Create game_detector.py with GameDetector class</name>
  <files>src/game_detector.py</files>
  <action>
Create src/game_detector.py with GameDetector class:

```python
"""Game detection for automatic PTT integration.

Detects running games and provides their PTT key profiles.
"""

import psutil
import time
from typing import Optional, Dict, List


# Default game profiles
DEFAULT_GAME_PROFILES = {
    "dota2": {
        "name": "Dota 2",
        "process_names": ["dota2.exe"],
        "ptt_key": "v",
        "enabled": True
    },
    "discord": {
        "name": "Discord",
        "process_names": ["Discord.exe"],
        "ptt_key": "grave",  # ` key
        "enabled": True
    },
    "csgo": {
        "name": "Counter-Strike",
        "process_names": ["csgo.exe", "cs2.exe"],
        "ptt_key": "k",
        "enabled": True
    },
    "valorant": {
        "name": "Valorant",
        "process_names": ["VALORANT.exe", "VALORANT-Win64-Shipping.exe"],
        "ptt_key": "v",
        "enabled": True
    }
}


class GameDetector:
    """Detects running games and provides PTT profiles."""
    
    def __init__(self, config: Dict):
        """Initialize game detector.
        
        Args:
            config: Configuration dictionary with auto_ptt settings
        """
        self.config = config
        self.game_profiles = self._load_game_profiles()
        
        # Cache for performance
        self._last_detection_time = 0
        self._last_detected_game = None
        self._cache_duration = 5.0  # seconds
    
    def _load_game_profiles(self) -> Dict:
        """Load game profiles from config or use defaults."""
        auto_ptt_config = self.config.get('auto_ptt', {})
        games_config = auto_ptt_config.get('games', {})
        
        # Start with defaults
        profiles = DEFAULT_GAME_PROFILES.copy()
        
        # Override with user config
        for game_id, game_config in games_config.items():
            if game_id in profiles:
                # Update existing profile
                profiles[game_id].update(game_config)
            else:
                # Add custom game
                profiles[game_id] = game_config
        
        return profiles
    
    def detect_active_game(self) -> Optional[str]:
        """Detect currently running game.
        
        Returns:
            Game ID if detected, None otherwise
        """
        # Check cache
        current_time = time.time()
        if current_time - self._last_detection_time < self._cache_duration:
            return self._last_detected_game
        
        # Get all running processes
        try:
            running_processes = {p.name().lower() for p in psutil.process_iter(['name'])}
        except (psutil.NoSuchProcess, psutil.AccessDenied):
            return None
        
        # Check each game profile
        for game_id, profile in self.game_profiles.items():
            if not profile.get('enabled', True):
                continue
            
            # Check if any of the game's processes are running
            process_names = profile.get('process_names', [])
            for process_name in process_names:
                if process_name.lower() in running_processes:
                    # Found game
                    self._last_detected_game = game_id
                    self._last_detection_time = current_time
                    return game_id
        
        # No game detected
        self._last_detected_game = None
        self._last_detection_time = current_time
        return None
    
    def get_game_profile(self, game_id: str) -> Optional[Dict]:
        """Get profile for specific game.
        
        Args:
            game_id: Game identifier
            
        Returns:
            Game profile dict or None
        """
        return self.game_profiles.get(game_id)
    
    def get_game_ptt_key(self, game_id: str) -> Optional[str]:
        """Get PTT key for specific game.
        
        Args:
            game_id: Game identifier
            
        Returns:
            PTT key string or None
        """
        profile = self.get_game_profile(game_id)
        if profile:
            return profile.get('ptt_key')
        return None
    
    def is_game_running(self, game_id: str) -> bool:
        """Check if specific game is running.
        
        Args:
            game_id: Game identifier
            
        Returns:
            True if game is running
        """
        detected = self.detect_active_game()
        return detected == game_id
    
    def get_all_games(self) -> Dict:
        """Get all game profiles.
        
        Returns:
            Dictionary of all game profiles
        """
        return self.game_profiles.copy()


def main():
    """Test game detector."""
    from config_loader import DEFAULT_CONFIG
    
    config = DEFAULT_CONFIG.copy()
    config['auto_ptt'] = {
        'enabled': True,
        'hold_duration': 0.1,
        'games': {}
    }
    
    detector = GameDetector(config)
    
    print("[TEST] Game Detector")
    print()
    print("Available games:")
    for game_id, profile in detector.get_all_games().items():
        print(f"  - {profile['name']} ({game_id})")
        print(f"    Processes: {', '.join(profile['process_names'])}")
        print(f"    PTT Key: {profile['ptt_key']}")
    
    print()
    print("Detecting active game...")
    game = detector.detect_active_game()
    if game:
        profile = detector.get_game_profile(game)
        print(f"[DETECTED] {profile['name']}")
        print(f"[PTT KEY] {profile['ptt_key']}")
    else:
        print("[INFO] No supported game detected")


if __name__ == "__main__":
    main()
```

IMPORTANT:
- Use psutil.process_iter() for process detection
- Cache detection for 5 seconds (performance)
- Support multiple process names per game
- Load profiles from config with defaults
- Handle psutil exceptions gracefully
  </action>
  <verify>python -m py_compile src/game_detector.py</verify>
  <done>game_detector.py created with GameDetector class</done>
</task>

<task type="auto">
  <name>Add auto_ptt config to DEFAULT_CONFIG</name>
  <files>src/config_loader.py</files>
  <action>
Update DEFAULT_CONFIG in src/config_loader.py to include auto_ptt settings:

Add after the "overlay" section:
```python
    "overlay": {
        "enabled": True,
        "position": {"x": 100, "y": 100},
        "size": {"width": 150, "height": 50},
        "opacity": 0.9
    },
    "auto_ptt": {
        "enabled": True,
        "hold_duration": 0.1,
        "games": {
            "dota2": {"enabled": True, "ptt_key": "v"},
            "discord": {"enabled": True, "ptt_key": "grave"},
            "csgo": {"enabled": True, "ptt_key": "k"},
            "valorant": {"enabled": True, "ptt_key": "v"}
        }
    }
```

Also update validate_config() to validate auto_ptt section:
```python
    # Validate auto_ptt section
    auto_ptt = config.get("auto_ptt", {})
    if not isinstance(auto_ptt.get("enabled"), bool):
        return False, "auto_ptt.enabled must be boolean"
    if not isinstance(auto_ptt.get("hold_duration"), (int, float)):
        return False, "auto_ptt.hold_duration must be number"
    if "games" not in auto_ptt:
        return False, "auto_ptt.games is required"
```

IMPORTANT:
- Maintain existing structure
- Add validation for all auto_ptt fields
- Include default game profiles
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); from config_loader import DEFAULT_CONFIG; assert 'auto_ptt' in DEFAULT_CONFIG; print('[OK] auto_ptt config added')"</verify>
  <done>Auto-PTT configuration added to DEFAULT_CONFIG with validation</done>
</task>

## Success Criteria
- [ ] psutil added to requirements
- [ ] GameDetector class detects running games
- [ ] Game profiles loaded from config
- [ ] Detection cached for performance
- [ ] auto_ptt config in DEFAULT_CONFIG
- [ ] Config validation includes auto_ptt section
