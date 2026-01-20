---
phase: 2
plan: 2
wave: 2
---

# Plan 2.2: SPEC Writer Skill

## Objective

Create executable skill for SPEC.md creation with programmatic validation, replacing the static template.

## Context

- ROADMAP.md (Phase 2: Skill para SPEC.md)
- .gsd/phases/2/RESEARCH.md (Skill structure and validation)
- .gsd/templates/SPEC.md (current template)
- .kiro/skills/utils/ (validation framework from Plan 2.1)

## Tasks

<task type="auto">
  <name>Create SPEC writer skill</name>
  <files>
    .kiro/skills/spec-writer/SKILL.md
    .kiro/skills/spec-writer/reference.md
  </files>
  <action>
    Create spec-writer skill with progressive disclosure:
    
    **SKILL.md**:
    ```yaml
    ---
    name: spec-writer
    description: Creates and validates SPEC.md files for project specifications. Use when starting a new project, writing specifications, or when user mentions "spec", "specification", or "requirements".
    allowed-tools: Read, Write
    ---
    
    # SPEC Writer
    
    ## Overview
    Guides creation of SPEC.md with proper structure and validation.
    
    ## Required Sections
    1. Vision (one paragraph)
    2. Goals (numbered list)
    3. Non-Goals (what's out of scope)
    4. Constraints (technical/business limits)
    5. Success Criteria (measurable outcomes)
    
    ## Process
    1. Ask user about project vision
    2. Identify 3-5 main goals
    3. Define what's explicitly out of scope
    4. List constraints
    5. Define measurable success criteria
    6. Create SPEC.md with status: DRAFT
    7. Run validation script
    8. If validation fails: fix issues
    9. Ask user to review and finalize
    
    ## Validation
    Run: `python .kiro/skills/spec-writer/scripts/validate_spec.py SPEC.md`
    
    For detailed template, see [reference.md](reference.md)
    ```
    
    **reference.md**: Copy content from `.gsd/templates/SPEC.md`
    
    WHY progressive disclosure: Keep SKILL.md focused, details in reference
    AVOID: Duplicating all template content in SKILL.md
  </action>
  <verify>type .kiro\skills\spec-writer\SKILL.md</verify>
  <done>Skill files exist with complete structure</done>
</task>

<task type="auto">
  <name>Create SPEC validation script</name>
  <files>.kiro/skills/spec-writer/scripts/validate_spec.py</files>
  <action>
    Create validation script for SPEC.md:
    
    ```python
    #!/usr/bin/env python3
    import sys
    import os
    
    # Add skills utils to path
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'utils'))
    
    from validator_base import SkillValidator
    
    class SpecValidator(SkillValidator):
        REQUIRED_SECTIONS = [
            "Vision",
            "Goals",
            "Non-Goals",
            "Constraints",
            "Success Criteria"
        ]
        
        def validate(self, file_path):
            # Check file exists
            if not self.check_file_exists(file_path):
                self.report_error(f"File not found: {file_path}")
                return False
            
            # Read content
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Check YAML frontmatter
            yaml = self.check_yaml_frontmatter(content)
            if not yaml:
                self.report_error("Missing or invalid YAML frontmatter")
                return False
            
            # Check status field
            if 'status' not in yaml:
                self.report_error("Missing 'status' field in frontmatter")
                return False
            
            # Check required sections
            for section in self.REQUIRED_SECTIONS:
                if not self.check_section_exists(content, section):
                    self.report_error(f"Missing required section: ## {section}")
                    return False
            
            # Check sections are not empty
            for section in self.REQUIRED_SECTIONS:
                # Simple check: section header followed by content
                if f"## {section}\n\n##" in content or f"## {section}\n---" in content:
                    self.report_error(f"Section '{section}' appears to be empty")
                    return False
            
            return True
    
    if __name__ == "__main__":
        if len(sys.argv) < 2:
            print("Usage: validate_spec.py <spec-file>", file=sys.stderr)
            sys.exit(1)
        
        validator = SpecValidator()
        if validator.validate(sys.argv[1]):
            print("✓ SPEC.md validation passed")
            sys.exit(0)
        else:
            sys.exit(1)
    ```
    
    WHY inheritance: Reuses common validation logic
    AVOID: Hardcoding file paths - accept as argument
  </action>
  <verify>python .kiro\skills\spec-writer\scripts\validate_spec.py --help</verify>
  <done>Validation script exists and runs</done>
</task>

<task type="checkpoint:human-verify">
  <name>Test SPEC writer skill</name>
  <files>test_spec.md</files>
  <action>
    Manual test of spec-writer skill:
    
    1. Ask Claude to create a SPEC.md using the skill
    2. Verify skill is auto-invoked (description triggers)
    3. Verify all required sections are created
    4. Run validation script manually
    5. Verify validation passes
    6. Test with intentionally incomplete SPEC
    7. Verify validation catches missing sections
    
    This validates the skill works end-to-end.
  </action>
  <verify>User confirms skill creates valid SPEC.md</verify>
  <done>SPEC writer skill successfully creates and validates specifications</done>
</task>

## Success Criteria

- [ ] spec-writer skill exists with SKILL.md and reference.md
- [ ] Validation script exists and is functional
- [ ] Script validates all required sections
- [ ] Script checks for empty sections
- [ ] Skill auto-invokes when user mentions "spec"
- [ ] Changes committed to git

## Notes

This is the first "living template" - active documentation that validates itself.
