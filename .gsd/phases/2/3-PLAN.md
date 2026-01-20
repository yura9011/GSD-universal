---
phase: 2
plan: 3
wave: 2
---

# Plan 2.3: ROADMAP Builder Skill

## Objective

Create executable skill for ROADMAP.md creation with structure validation, ensuring proper phase definitions.

## Context

- ROADMAP.md (Phase 2: Skill para ROADMAP.md)
- .gsd/phases/2/RESEARCH.md (Skill structure)
- .gsd/templates/ROADMAP.md (current template)
- .kiro/skills/utils/ (validation framework)

## Tasks

<task type="auto">
  <name>Create ROADMAP builder skill</name>
  <files>
    .kiro/skills/roadmap-builder/SKILL.md
    .kiro/skills/roadmap-builder/reference.md
  </files>
  <action>
    Create roadmap-builder skill:
    
    **SKILL.md**:
    ```yaml
    ---
    name: roadmap-builder
    description: Creates and validates ROADMAP.md files with phase definitions. Use when planning project phases, creating milestones, or when user mentions "roadmap", "phases", or "milestone".
    allowed-tools: Read, Write
    ---
    
    # ROADMAP Builder
    
    ## Overview
    Guides creation of ROADMAP.md with proper phase structure.
    
    ## Required Structure
    1. Current Milestone header
    2. Must-Haves checklist
    3. Phases section with:
       - Phase number and name
       - Status indicator
       - Objective
       - Key deliverables
    
    ## Process
    1. Identify milestone name and goal
    2. List must-have deliverables
    3. Break work into 3-7 phases
    4. For each phase:
       - Define clear objective
       - List 3-5 key deliverables
       - Set status to ⬜ Not Started
    5. Create ROADMAP.md
    6. Run validation script
    7. If validation fails: fix issues
    
    ## Validation
    Run: `python .kiro/skills/roadmap-builder/scripts/validate_roadmap.py ROADMAP.md`
    
    For detailed template, see [reference.md](reference.md)
    ```
    
    **reference.md**: Copy content from `.gsd/templates/ROADMAP.md`
    
    WHY separate skill: ROADMAP has different structure than SPEC
    AVOID: Combining with spec-writer - keep skills focused
  </action>
  <verify>type .kiro\skills\roadmap-builder\SKILL.md</verify>
  <done>Skill files exist with complete structure</done>
</task>

<task type="auto">
  <name>Create ROADMAP validation script</name>
  <files>.kiro/skills/roadmap-builder/scripts/validate_roadmap.py</files>
  <action>
    Create validation script for ROADMAP.md:
    
    ```python
    #!/usr/bin/env python3
    import sys
    import os
    import re
    
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'utils'))
    
    from validator_base import SkillValidator
    
    class RoadmapValidator(SkillValidator):
        def validate(self, file_path):
            if not self.check_file_exists(file_path):
                self.report_error(f"File not found: {file_path}")
                return False
            
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Check for milestone header
            if not re.search(r'\*\*Current Milestone\*\*:', content):
                self.report_error("Missing 'Current Milestone' header")
                return False
            
            # Check for Must-Haves section
            if not self.check_section_exists(content, "Must-Haves"):
                self.report_error("Missing '## Must-Haves' section")
                return False
            
            # Check for Phases section
            if not self.check_section_exists(content, "Phases"):
                self.report_error("Missing '## Phases' section")
                return False
            
            # Check for at least one phase definition
            phase_pattern = r'###\s+Phase\s+\d+:'
            if not re.search(phase_pattern, content):
                self.report_error("No phase definitions found (expected '### Phase N:')")
                return False
            
            # Check each phase has required fields
            phases = re.findall(r'###\s+Phase\s+\d+:.*?(?=###\s+Phase|\Z)', content, re.DOTALL)
            for i, phase in enumerate(phases, 1):
                if '**Status**:' not in phase:
                    self.report_error(f"Phase {i} missing **Status** field")
                    return False
                if '**Objective**:' not in phase:
                    self.report_error(f"Phase {i} missing **Objective** field")
                    return False
            
            return True
    
    if __name__ == "__main__":
        if len(sys.argv) < 2:
            print("Usage: validate_roadmap.py <roadmap-file>", file=sys.stderr)
            sys.exit(1)
        
        validator = RoadmapValidator()
        if validator.validate(sys.argv[1]):
            print("✓ ROADMAP.md validation passed")
            sys.exit(0)
        else:
            sys.exit(1)
    ```
    
    WHY regex: Phase structure is more complex than simple sections
    AVOID: Over-validating - check structure, not content quality
  </action>
  <verify>python .kiro\skills\roadmap-builder\scripts\validate_roadmap.py ROADMAP.md</verify>
  <done>Validation script exists and validates current ROADMAP.md</done>
</task>

<task type="checkpoint:human-verify">
  <name>Test ROADMAP builder skill</name>
  <files>test_roadmap.md</files>
  <action>
    Manual test of roadmap-builder skill:
    
    1. Ask Claude to create a ROADMAP.md using the skill
    2. Verify skill is auto-invoked
    3. Verify all required sections are created
    4. Verify phases have proper structure
    5. Run validation script
    6. Verify validation passes
    7. Test with incomplete ROADMAP
    8. Verify validation catches missing fields
    
    This validates the skill works end-to-end.
  </action>
  <verify>User confirms skill creates valid ROADMAP.md</verify>
  <done>ROADMAP builder skill successfully creates and validates roadmaps</done>
</task>

## Success Criteria

- [ ] roadmap-builder skill exists with SKILL.md and reference.md
- [ ] Validation script exists and is functional
- [ ] Script validates milestone header
- [ ] Script validates phase structure
- [ ] Script checks for required phase fields
- [ ] Skill auto-invokes when user mentions "roadmap"
- [ ] Changes committed to git

## Notes

This skill ensures ROADMAPs have consistent structure across all GSD projects.
