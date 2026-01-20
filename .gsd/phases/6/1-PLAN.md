---
phase: 6
plan: 1
wave: 1
milestone: v1.1
---

# Plan 6.1: Consolidate Test Files

## Objective
Move all test scripts into a dedicated tests/ directory and organize them properly. This improves project structure and separates test code from production code.

## Context
- Current structure has test files scattered in src/ root
- Need to create tests/ directory and move all test_*.py files
- Must maintain functionality after move

## Tasks

<task type="auto">
  <name>Create tests directory and move test files</name>
  <files>tests/, src/test_*.py</files>
  <action>
    Create tests/ directory structure:
    ```
    tests/
    ├── __init__.py
    ├── test_audio.py
    ├── test_vad.py
    ├── test_whisper.py
    ├── test_speech_pipeline.py
    ├── test_translation.py
    ├── test_tts.py
    └── test_translation_pipeline.py
    ```
    
    Steps:
    1. Create tests/ directory
    2. Create tests/__init__.py (empty file)
    3. Move all src/test_*.py files to tests/
    4. Update import paths in test files:
       - Change `sys.path.insert(0, '.')` to `sys.path.insert(0, '..')`
       - Or use proper relative imports
    
    Files to move:
    - src/test_audio.py → tests/test_audio.py
    - src/test_vad.py → tests/test_vad.py
    - src/test_whisper.py → tests/test_whisper.py
    - src/test_speech_pipeline.py → tests/test_speech_pipeline.py
    - src/test_translation.py → tests/test_translation.py
    - src/test_tts.py → tests/test_tts.py
    - src/test_translation_pipeline.py → tests/test_translation_pipeline.py
    
    IMPORTANT:
    - Keep src/list_devices.py in src/ (it's a utility, not a test)
    - Update sys.path in each test file to point to src/
    - Maintain all test functionality
  </action>
  <verify>dir tests | Select-String "test_"</verify>
  <done>All test files moved to tests/ directory with correct imports</done>
</task>

<task type="auto">
  <name>Update .gitignore for __pycache__</name>
  <files>.gitignore</files>
  <action>
    Create or update .gitignore to exclude Python cache files:
    
    Add these lines:
    ```
    # Python
    __pycache__/
    *.py[cod]
    *$py.class
    *.so
    .Python
    
    # Virtual environments
    venv/
    env/
    ENV/
    
    # IDE
    .vscode/
    .idea/
    
    # OS
    .DS_Store
    Thumbs.db
    ```
    
    IMPORTANT:
    - If .gitignore exists, append missing entries
    - If it doesn't exist, create it with all entries
  </action>
  <verify>cat .gitignore | Select-String "__pycache__"</verify>
  <done>.gitignore created/updated with Python cache exclusions</done>
</task>

## Success Criteria
- [ ] tests/ directory exists with all test files
- [ ] All test files have correct import paths
- [ ] src/ directory only contains production code
- [ ] .gitignore excludes __pycache__ directories
- [ ] No test files remain in src/ root
