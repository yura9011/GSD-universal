---
phase: 6
plan: 3
wave: 2
milestone: v1.1
---

# Plan 6.3: Clean Up Root Directory

## Objective
Remove temporary files and organize root directory for a clean, professional project structure.

## Context
- Root has temporary scripts (verify_no_emojis.py, remove_test_emojis.py)
- __pycache__ directories should be removed
- Need clean root for professional appearance

## Tasks

<task type="auto">
  <name>Remove temporary and cache files</name>
  <files>verify_no_emojis.py, remove_test_emojis.py, src/__pycache__, src/audio/__pycache__, src/translator/__pycache__</files>
  <action>
    Clean up temporary files and Python cache:
    
    Files to remove:
    1. verify_no_emojis.py (temporary verification script)
    2. remove_test_emojis.py (temporary helper script)
    3. src/__pycache__/ (Python cache)
    4. src/audio/__pycache__/ (Python cache)
    5. src/translator/__pycache__/ (Python cache)
    
    Commands:
    ```powershell
    Remove-Item verify_no_emojis.py -ErrorAction SilentlyContinue
    Remove-Item remove_test_emojis.py -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force src/__pycache__ -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force src/audio/__pycache__ -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force src/translator/__pycache__ -ErrorAction SilentlyContinue
    ```
    
    IMPORTANT:
    - Use -ErrorAction SilentlyContinue to avoid errors if files don't exist
    - .gitignore should prevent these from being committed in future
    - Keep all production code and documentation
  </action>
  <verify>Test-Path verify_no_emojis.py</verify>
  <done>Temporary files and cache directories removed</done>
</task>

<task type="auto">
  <name>Verify final directory structure</name>
  <files>Root directory</files>
  <action>
    Verify the final clean directory structure:
    
    Expected root structure:
    ```
    txt2world/
    ├── .gsd/              # GSD system files
    ├── .summaries/        # Phase summaries
    ├── docs/              # Documentation
    ├── src/               # Production code
    │   ├── audio/         # Audio modules
    │   ├── translator/    # Translation modules
    │   ├── config.py
    │   ├── list_devices.py
    │   ├── main.py
    │   └── voice_translator.py
    ├── tests/             # Test files
    ├── .gitignore
    ├── DECISIONS.md
    ├── JOURNAL.md
    ├── QUICKSTART.md
    ├── README.md
    ├── requirements.txt
    ├── ROADMAP.md
    ├── SPEC.md
    ├── STATE.md
    └── TODO.md
    ```
    
    Verification steps:
    1. List root directory contents
    2. Verify tests/ exists with test files
    3. Verify docs/ exists with documentation
    4. Verify src/ only has production code
    5. Verify no __pycache__ directories
    6. Verify no temporary .py scripts in root
    
    IMPORTANT:
    - Document the final structure
    - Ensure all imports still work
    - Confirm clean, professional appearance
  </action>
  <verify>dir . | Select-String -Pattern "test_" -NotMatch</verify>
  <done>Directory structure verified and documented</done>
</task>

## Success Criteria
- [ ] No temporary files in root
- [ ] No __pycache__ directories
- [ ] Clean, professional directory structure
- [ ] All production code in src/
- [ ] All tests in tests/
- [ ] All docs in docs/ or root (README, QUICKSTART)
