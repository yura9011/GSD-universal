---
name: spec-writer
description: Creates and validates SPEC.md files for project specifications. Use when starting a new project, writing specifications, or when user mentions "spec", "specification", or "requirements".
allowed-tools: Read, Write
---

# SPEC Writer

## Overview

Guides creation of SPEC.md with proper structure and programmatic validation.

## Required Sections

1. **Vision** - One paragraph describing what the project is and why it exists
2. **Goals** - Numbered list of 3-5 main objectives
3. **Non-Goals** - What's explicitly out of scope
4. **Constraints** - Technical, business, or timeline limitations
5. **Success Criteria** - Measurable outcomes (checkboxes)

## Process

1. Ask user about project vision
2. Identify 3-5 main goals
3. Define what's explicitly out of scope (non-goals)
4. List constraints (technical/business/timeline)
5. Define measurable success criteria
6. Create SPEC.md with status: DRAFT
7. Run validation script
8. If validation fails: fix issues automatically
9. Ask user to review and finalize

## Validation

Run validation script:

```bash
python .kiro/skills/spec-writer/scripts/validate_spec.py SPEC.md
```

The validator checks:
- [ ] File exists
- [ ] YAML frontmatter present with 'status' field
- [ ] All required sections present
- [ ] No empty sections
- [ ] Proper Markdown structure

## SPEC.md Structure

```markdown
---
status: DRAFT | FINALIZED
---

# SPEC.md — Project Specification

> **Status**: `DRAFT` | `FINALIZED`
>
> ⚠️ **Planning Lock**: No code may be written until this spec is marked `FINALIZED`.

## Vision
{One paragraph}

## Goals
1. **{Goal 1}** — {Description}
2. **{Goal 2}** — {Description}

## Non-Goals (Out of Scope)
- {What's excluded}

## Constraints
- {Technical constraint}
- {Business constraint}

## Success Criteria
- [ ] {Measurable outcome 1}
- [ ] {Measurable outcome 2}
```

## Examples

### Example 1: New Project

```
User: "I want to create a spec for my todo app"
Claude: [Uses spec-writer skill]
- Asks about vision
- Identifies goals
- Defines scope
- Creates SPEC.md
- Validates structure
```

### Example 2: Validation

```
User: "Validate my spec"
Claude: [Runs validation script]
- Checks all sections present
- Reports any issues
- Fixes automatically if needed
```

## Additional Resources

For the complete SPEC.md template with all sections and examples, see [reference.md](reference.md)

## Notes

- Status starts as DRAFT
- User must review and change to FINALIZED
- Planning Lock prevents code until FINALIZED
- Keep Vision to one paragraph
- Goals should be specific and achievable
- Success Criteria must be measurable
