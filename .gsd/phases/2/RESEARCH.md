# Phase 2 Research: Skills Migration

**Phase**: 2 - Skills Migration
**Created**: 2026-01-20
**Research Level**: 2 (Standard Research)

---

## Research Question

How to convert GSD templates into executable Kiro Skills with embedded validation scripts?

---

## Findings

### 1. Skills vs Templates

**Current (Templates)**:
- Static Markdown files in `.gsd/templates/`
- No validation logic
- Just documentation/structure
- Agent reads and follows manually

**Target (Skills)**:
- Active Markdown files in `.kiro/skills/`
- Embedded validation scripts
- Programmatic structure checking
- Auto-invoked by Claude when relevant

### 2. Skill Structure

Based on `resarch/skills.md`:

```
.kiro/skills/
└── skill-name/
    ├── SKILL.md              # Main skill file (required)
    ├── reference.md          # Detailed docs (optional)
    └── scripts/
        └── validator.py      # Validation script
```

**SKILL.md frontmatter**:
```yaml
---
name: skill-name
description: When to use this skill (triggers auto-invocation)
allowed-tools: Read, Write, Bash
---
```

### 3. Progressive Disclosure

Skills use progressive disclosure:
- Essential info in SKILL.md (< 500 lines)
- Detailed reference in separate files
- Scripts executed, not loaded into context

**Benefits**:
- Keeps context focused
- Comprehensive documentation available
- Zero-context script execution

### 4. Validation Scripts

Scripts can:
- Validate structure (required sections present)
- Check format (YAML frontmatter valid)
- Verify content (no empty sections)
- Return exit codes (0 = pass, 1 = fail)

**Example**:
```python
#!/usr/bin/env python3
import sys

def validate_spec(file_path):
    with open(file_path) as f:
        content = f.read()
    
    required = ["Vision", "Goals", "Success Criteria"]
    for section in required:
        if f"## {section}" not in content:
            print(f"Missing required section: {section}")
            return False
    return True

if __name__ == "__main__":
    if validate_spec(sys.argv[1]):
        sys.exit(0)
    sys.exit(1)
```

### 5. Skills to Create

Based on ROADMAP Phase 2 deliverables:

**Priority 1 (Must-have)**:
1. **spec-writer**: SPEC.md creation with validation
2. **roadmap-builder**: ROADMAP.md structure validation
3. **commit-helper**: Atomic commit message generation

**Priority 2 (Nice-to-have)**:
4. **verification-helper**: Empirical verification guidance
5. **phase-planner**: Phase planning assistance

### 6. Skill Descriptions (Auto-invocation)

Critical for auto-invocation. Must include:
- What the skill does
- When to use it
- Trigger keywords

**Example**:
```yaml
description: Creates and validates SPEC.md files. Use when starting a new project, writing specifications, or when user mentions "spec", "specification", or "requirements".
```

### 7. Integration with Hooks

Skills and Hooks work together:
- **Hooks**: Enforce rules automatically (blocking)
- **Skills**: Guide creation with validation (assisting)

Example flow:
1. User asks to create SPEC.md
2. Claude invokes `spec-writer` skill
3. Skill guides creation with structure
4. Skill runs validation script
5. If validation fails: Claude fixes
6. Hook validates syntax (Phase 1)

### 8. Bash Command Execution

Skills can execute bash commands before running:

```markdown
---
allowed-tools: Bash(git:*)
---

## Context

Current git status: !`git status`
Recent commits: !`git log --oneline -5`
```

The `!` prefix executes command, output included in context.

---

## Recommendations

### Phase 2 Implementation Strategy

**Wave 1: Foundation**
- Create `.kiro/skills/` directory structure
- Create base skill template
- Create validation script framework

**Wave 2: Core Skills**
- Implement spec-writer skill
- Implement roadmap-builder skill
- Implement commit-helper skill

**Wave 3: Integration**
- Test skills with real workflows
- Document skill usage
- Update GSD workflows to reference skills

### Skill Organization

```
.kiro/skills/
├── spec-writer/
│   ├── SKILL.md
│   ├── reference.md (SPEC template details)
│   └── scripts/
│       └── validate_spec.py
├── roadmap-builder/
│   ├── SKILL.md
│   └── scripts/
│       └── validate_roadmap.py
└── commit-helper/
    └── SKILL.md
```

### Validation Strategy

Each skill validator should:
1. Check file exists
2. Validate structure (sections present)
3. Check format (YAML valid, Markdown valid)
4. Verify content (no empty required sections)
5. Return clear error messages

### Testing Strategy

1. Create test files with intentional errors
2. Invoke skills manually
3. Verify validation catches errors
4. Verify Claude receives feedback
5. Test auto-invocation with trigger keywords

---

## Open Questions

1. Should skills be project-level or user-level?
   - **Recommendation**: Project-level (`.kiro/skills/`)
   - Reason: Team shares same standards

2. How verbose should skill instructions be?
   - **Recommendation**: Concise in SKILL.md, detailed in reference.md
   - Use progressive disclosure

3. Should skills replace templates entirely?
   - **Recommendation**: Keep templates as fallback
   - Skills are active, templates are passive reference

---

## References

- `resarch/skills.md` - Complete Kiro skills documentation
- `resarch/ideas.md` - Integration concepts
- `.gsd/templates/` - Current template structure
- Kiro docs: https://code.claude.com/docs/skills

---

## Next Steps

Proceed to planning with this research as foundation.
