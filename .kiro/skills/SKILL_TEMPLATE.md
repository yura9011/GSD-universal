---
name: skill-name
description: What this skill does and when to use it. Include trigger keywords that users would naturally say.
allowed-tools: Read, Write, Bash
---

# Skill Name

## Overview

Brief description of what this skill helps with (1-2 sentences).

## When to Use

- Scenario 1: When user needs X
- Scenario 2: When working on Y
- Scenario 3: When user mentions "keyword"

## Instructions

Step-by-step guidance for Claude:

1. **Step 1**: Do this first
   - Detail A
   - Detail B

2. **Step 2**: Then do this
   - Detail A
   - Detail B

3. **Step 3**: Finally do this
   - Detail A
   - Detail B

## Validation

This skill includes validation scripts:

```bash
python .kiro/skills/skill-name/scripts/validate.py <file>
```

The validator checks:
- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Examples

### Example 1: Basic Usage

```
User: "Create a new spec"
Claude: [Uses this skill to guide creation]
```

### Example 2: With Validation

```
User: "Validate my spec"
Claude: [Runs validation script, reports results]
```

## Additional Resources

For detailed information, see [reference.md](reference.md)

## Notes

- Important note 1
- Important note 2
- Common pitfall to avoid
