---
phase: 2
plan: 1
wave: 1
---

# Plan 2.1: Skills Infrastructure Setup

## Objective

Create the foundational directory structure and base templates for Kiro Skills, establishing the framework for executable documentation.

## Context

- ROADMAP.md (Phase 2 objectives)
- .gsd/phases/2/RESEARCH.md (Skills implementation strategy)
- resarch/skills.md (Kiro skills documentation)
- .gsd/templates/ (existing templates to migrate)

## Tasks

<task type="auto">
  <name>Create Skills directory structure</name>
  <files>
    .kiro/skills/README.md
    .kiro/skills/.gitkeep
  </files>
  <action>
    Create the `.kiro/skills/` directory structure:
    
    1. Create `.kiro/skills/` directory
    2. Create `.kiro/skills/README.md` with overview
    3. Add .gitkeep to ensure directory is tracked
    
    **README.md content**:
    - Overview of GSD Skills
    - Directory structure explanation
    - How skills are auto-invoked
    - Link to Kiro skills documentation
    
    This establishes the foundation for all skill files.
    
    AVOID: Creating individual skill directories yet (next plans handle that)
  </action>
  <verify>dir .kiro\skills</verify>
  <done>Directory exists: .kiro/skills/ with README.md</done>
</task>

<task type="auto">
  <name>Create skill validation framework</name>
  <files>
    .kiro/skills/utils/__init__.py
    .kiro/skills/utils/validator_base.py
  </files>
  <action>
    Create shared validation utilities for skill scripts:
    
    **validator_base.py**: Base class for validators
    - Class: `SkillValidator` with common methods
    - Method: `check_file_exists(path)` returns boolean
    - Method: `check_section_exists(content, section)` returns boolean
    - Method: `check_yaml_frontmatter(content)` returns dict or None
    - Method: `report_error(message)` prints to stderr
    - Method: `validate()` abstract method (override in subclasses)
    
    These utilities will be inherited by all skill validators.
    
    WHY base class: Reduces code duplication across validators
    AVOID: Complex logic - keep base class simple and focused
  </action>
  <verify>python -c "from .kiro.skills.utils.validator_base import SkillValidator; print('OK')"</verify>
  <done>Validator base class exists and is importable</done>
</task>

<task type="auto">
  <name>Create skill template</name>
  <files>.kiro/skills/SKILL_TEMPLATE.md</files>
  <action>
    Create template for new skills:
    
    ```markdown
    ---
    name: skill-name
    description: What this skill does and when to use it. Include trigger keywords.
    allowed-tools: Read, Write, Bash
    ---
    
    # Skill Name
    
    ## Overview
    Brief description of what this skill helps with.
    
    ## When to Use
    - Scenario 1
    - Scenario 2
    
    ## Instructions
    Step-by-step guidance for Claude.
    
    ## Validation
    This skill includes validation scripts in `scripts/` directory.
    
    ## Examples
    Concrete examples of using this skill.
    ```
    
    This template will be copied when creating new skills.
    
    WHY template: Ensures consistency across all skills
  </action>
  <verify>type .kiro\skills\SKILL_TEMPLATE.md</verify>
  <done>Template exists with complete structure</done>
</task>

## Success Criteria

- [ ] `.kiro/skills/` directory exists with README.md
- [ ] Validator base class exists and is functional
- [ ] Skill template exists with complete structure
- [ ] All files committed to git

## Notes

This plan creates the skeleton. Actual skill implementations come in Plans 2.2 and 2.3.
