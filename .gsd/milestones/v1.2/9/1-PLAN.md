---
phase: 9
plan: 1
wave: 1
milestone: v1.2
---

# Plan 9.1: Config Management Foundation

## Objective
Create configuration management system that loads/saves JSON config with validation, backup, and fallback to defaults. This provides the foundation for the UI to read/write settings.

## Context
- src/config.py - Current configuration (will become defaults)
- .gsd/phases/9/RESEARCH.md - Technical research
- DECISIONS.md - Phase 2 decisions

## Tasks

<task type="auto">
  <name>Create config_loader.py with JSON management</name>
  <files>src/config_loader.py</files>
  <action>
Create src/config_loader.py with these functions:

1. **DEFAULT_CONFIG dictionary** - Complete config structure:
```python
DEFAULT_CONFIG = {
    "ptt": {
        "enabled": True,
        "hotkey": "f1",
        "min_duration": 0.3,
        "max_duration": 10.0
    },
    "audio": {
        "input_device": None,  # None = auto-detect
        "output_device": None,  # None = auto-detect VB-Cable
        "sample_rate": 16000
    },
    "translation": {
        "source_lang": "es",
        "target_lang": "pt"
    },
    "speech": {
        "whisper_model": "tiny",
        "vad_threshold": 0.5,
        "min_phrase_duration": 0.5,
        "max_phrase_duration": 10.0
    },
    "tts": {
        "rate": 150
    }
}
```

2. **load_config()** function:
   - Check if config.json exists
   - If not, return DEFAULT_CONFIG copy
   - If exists, try to load JSON
   - If JSON invalid, print warning and return defaults
   - Validate loaded config has all required keys
   - Return config dictionary

3. **save_config(config)** function:
   - Validate config structure
   - If config.json exists, rename to config.json.backup
   - Write config to config.json with indent=4
   - Handle write errors gracefully

4. **validate_config(config)** function:
   - Check all required keys exist
   - Check value types are correct
   - Return (is_valid, error_message)

IMPORTANT:
- Use pathlib.Path for file operations
- Handle all exceptions gracefully
- Print clear [INFO], [WARNING], [ERROR] messages
- No emojis in output
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); from config_loader import load_config, save_config, DEFAULT_CONFIG; print('[OK] config_loader imports successfully')"</verify>
  <done>config_loader.py created with load/save/validate functions</done>
</task>

<task type="auto">
  <name>Add pystray and Pillow to requirements</name>
  <files>requirements.txt, requirements-lock.txt</files>
  <action>
Add to requirements.txt after keyboard library:

```
# Configuration UI (Phase 9 - v1.2)
pystray>=0.19.0
Pillow>=10.0.0
```

Add to requirements-lock.txt (alphabetically):
```
pystray==0.19.5
Pillow==10.4.0
```

IMPORTANT:
- Maintain existing formatting
- Add comment header for Phase 9
- Keep alphabetical order in lock file
  </action>
  <verify>cat requirements.txt | Select-String "pystray"</verify>
  <done>pystray and Pillow added to requirements files</done>
</task>

## Success Criteria
- [ ] config_loader.py imports without errors
- [ ] load_config() returns valid config dictionary
- [ ] save_config() creates config.json file
- [ ] validate_config() catches invalid configs
- [ ] pystray and Pillow in requirements.txt
