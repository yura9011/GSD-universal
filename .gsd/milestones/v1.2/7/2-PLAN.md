---
phase: 7
plan: 2
wave: 1
milestone: v1.1
---

# Plan 7.2: Polish Code Comments

## Objective
Review and improve code comments throughout the codebase to ensure they are clear, professional, and helpful.

## Context
- Code already has docstrings and comments
- Need to ensure all comments are professional (no emojis)
- Focus on clarity and usefulness

## Tasks

<task type="auto">
  <name>Review and update module docstrings</name>
  <files>src/audio/*.py, src/translator/*.py, src/*.py</files>
  <action>
    Review all Python files and ensure:
    
    1. **Module docstrings** are clear and complete:
       - What the module does
       - Key classes/functions
       - Usage examples if complex
    
    2. **Class docstrings** include:
       - Purpose of the class
       - Key responsibilities
       - Usage example if not obvious
    
    3. **Function docstrings** follow format:
       ```python
       """
       Brief description.
       
       Detailed explanation if needed.
       
       Args:
           param1 (type): Description
           param2 (type): Description
       
       Returns:
           type: Description
       
       Raises:
           ExceptionType: When this happens
       """
       ```
    
    Files to review:
    - src/config.py
    - src/main.py
    - src/voice_translator.py
    - src/list_devices.py
    - src/audio/*.py (all files)
    - src/translator/*.py (all files)
    
    IMPORTANT:
    - Keep existing good comments
    - Improve unclear or missing comments
    - Ensure professional tone
    - No emojis in comments
    - Focus on "why" not just "what"
  </action>
  <verify>python -c "import sys; sys.path.insert(0, 'src'); import voice_translator; print('[OK] Imports work')"</verify>
  <done>All code comments reviewed and polished</done>
</task>

## Success Criteria
- [ ] All modules have clear docstrings
- [ ] All classes have descriptive docstrings
- [ ] All public functions have complete docstrings
- [ ] Comments explain "why" not just "what"
- [ ] Professional tone throughout
