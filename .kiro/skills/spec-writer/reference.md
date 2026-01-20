# SPEC.md — Complete Template Reference

This is the complete SPEC.md template with all sections and detailed guidance.

---

## Full Template

```markdown
---
status: DRAFT | FINALIZED
---

# SPEC.md — Project Specification

> **Status**: `DRAFT` | `FINALIZED`
>
> ⚠️ **Planning Lock**: No code may be written until this spec is marked `FINALIZED`.

## Vision
{One paragraph describing what this project is and why it exists.}

## Goals
1. **{Goal 1}** — {Brief description}
2. **{Goal 2}** — {Brief description}
3. **{Goal 3}** — {Brief description}

## Non-Goals (Out of Scope)
- {What this project explicitly will NOT do}
- {Features that are intentionally excluded}
- {Scope boundaries}

## Constraints
- {Technical constraint 1}
- {Business constraint 1}
- {Timeline constraint 1}

## Success Criteria
- [ ] {Measurable outcome 1}
- [ ] {Measurable outcome 2}
- [ ] {Measurable outcome 3}
- [ ] {Measurable outcome 4}

## User Stories (Optional)

### As a {user type}
- I want to {action}
- So that {benefit}

### As a {user type}
- I want to {action}
- So that {benefit}

## Technical Requirements (Optional)

| Requirement | Priority | Notes |
|-------------|----------|-------|
| {Requirement 1} | Must-have | {Details} |
| {Requirement 2} | Should-have | {Details} |
| {Requirement 3} | Nice-to-have | {Details} |

---

*Last updated: <!-- date -->*
```

## Section Guidelines

### Vision

- **Length**: One paragraph (3-5 sentences)
- **Content**: What and why, not how
- **Tone**: Clear and compelling
- **Example**: "This project creates a task management system for solo developers. It helps developers track work across multiple projects without the overhead of enterprise tools. The system integrates with git to automatically track progress."

### Goals

- **Number**: 3-5 goals (not more)
- **Format**: Bold title + brief description
- **Specificity**: Concrete and achievable
- **Example**: "**Automatic Progress Tracking** — System detects completed tasks from git commits"

### Non-Goals

- **Purpose**: Set clear boundaries
- **Content**: What you're NOT building
- **Why**: Prevents scope creep
- **Example**: "Team collaboration features", "Mobile app", "Integration with Jira"

### Constraints

- **Types**: Technical, business, timeline
- **Format**: Bullet list
- **Specificity**: Concrete limitations
- **Example**: "Must work offline", "Budget: $0 (open source)", "Launch in 3 months"

### Success Criteria

- **Format**: Checkboxes
- **Measurability**: Must be verifiable
- **Specificity**: Clear pass/fail
- **Example**: "[ ] 100 users within first month", "[ ] < 2 second page load"

## Status Lifecycle

1. **DRAFT**: Initial creation, still being refined
2. **FINALIZED**: Approved, ready for implementation

**Planning Lock**: Code cannot be written while status is DRAFT.

## Best Practices

1. **Keep Vision Short**: One paragraph maximum
2. **Limit Goals**: 3-5 is ideal, more means unfocused
3. **Be Specific**: Vague goals lead to vague results
4. **Measurable Criteria**: If you can't measure it, you can't verify it
5. **Review with Stakeholders**: Get feedback before finalizing
6. **Update as Needed**: SPEC can evolve, but track changes

## Common Mistakes

- **Too Vague**: "Build a good system" → "Build a task tracker with git integration"
- **Too Many Goals**: 10+ goals → Focus on 3-5 core goals
- **Unmeasurable Criteria**: "Users like it" → "80% user satisfaction score"
- **Missing Non-Goals**: Leads to scope creep
- **Skipping Constraints**: Unrealistic expectations

## Validation

The validation script checks:

1. File exists
2. YAML frontmatter present
3. Status field exists
4. All required sections present:
   - Vision
   - Goals
   - Non-Goals
   - Constraints
   - Success Criteria
5. No empty sections
6. Proper Markdown structure

Run: `python .kiro/skills/spec-writer/scripts/validate_spec.py SPEC.md`
